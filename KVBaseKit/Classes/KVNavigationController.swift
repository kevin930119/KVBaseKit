//
//  KVNavigationController.swift
//  Alamofire
//
//  Created by 魏佳林 on 2020/1/11.
//

import UIKit

open class KVNavigationController: UINavigationController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    // 自定义导航栏返回按钮图片
    open var kv_backNavigationItemImage: UIImage?
    
    public override init(rootViewController: UIViewController) {
        super.init(navigationBarClass: KVNavigationBar.self, toolbarClass: nil)
        self.viewControllers = [rootViewController]
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        // 右滑手势代理
        self.interactivePopGestureRecognizer?.delegate = self
        // 导航控制器代理
        self.delegate = self
        // 设置导航栏为透明
        self._setNavigationBarToClear()
        
        self.navigationBar.isTranslucent = true
    }
    
    // pop回指定控制器之前的界面
    open func popFromViewController(viewController: UIViewController, animated: Bool) {
        let viewControllers = self.viewControllers
        let index = viewControllers.firstIndex(of: viewController)
        if index == NSNotFound {
            return
        }
        let targetIndex = index!-1
        if targetIndex < 0 {
            return
        }
        if targetIndex >= viewControllers.count {
            return
        }
        let targetViewController = viewControllers[targetIndex]
        self.popToViewController(targetViewController, animated: animated)
    }
    
    // 使用最上层控制器的配置更新导航栏
    open func updateOfBaseNavigationBarUsingTopViewControllerConfig() {
        if self.viewControllers.last == nil {
            return
        }
        if !(self.viewControllers.last! is KVViewController) {
            return
        }
        // 更新导航栏
        self._updateNavigationBarWithViewController(viewController: self.viewControllers.last! as! KVViewController)
        // 隐藏所有子控制器的假导航栏
        for viewController in self.viewControllers {
            if !(viewController is KVViewController) {
                continue
            }
            (viewController as! KVViewController).setFakeNavigationBarHidden(hidden: true)
        }
    }
    
    /// UIGestureRecognizerDelegate
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.viewControllers.count < 2 {
            return false
        }
        
        if !(self.topViewController is KVViewController) {
            return true
        }
        
        let viewController = self.topViewController! as! KVViewController
        return viewController.kv_supportPopGestureRecognizer
    }
    /// UINavigationControllerDelegate
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if !(viewController is KVViewController) {
            return
        }
        
        let baseVC = viewController as! KVViewController
        let prefersNavigationBarHidden = baseVC.kv_prefersNavigationBarHidden
        if self.isNavigationBarHidden != prefersNavigationBarHidden {
            self.setNavigationBarHidden(prefersNavigationBarHidden, animated: animated)
        }
        
        let coordinator = self.transitionCoordinator
        if coordinator != nil {
            let from = coordinator?.viewController(forKey: .from)
            let to = coordinator?.viewController(forKey: .to)
            if (from is KVViewController) && (to is KVViewController) {
                (from as! KVViewController).setFakeNavigationBarHidden(hidden: false)
                (to as! KVViewController).setFakeNavigationBarHidden(hidden: false)
                
                // 更新导航栏为透明
                self._updateNavigationBarToEmpty()
            }
            
            // 更新状态栏
            self._updateStatusBarWithViewController(viewController: baseVC)
        } else {
            // 更新导航栏
            self._updateNavigationBarWithViewController(viewController: baseVC)
            baseVC.setFakeNavigationBarHidden(hidden: true)
        }
    }
    
    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.hidesBackButton = true
        if self.viewControllers.count > 0 {
            // 第二个控制器开始隐藏底部栏
            viewController.hidesBottomBarWhenPushed = true;
            // 增加返回按钮
            if self.kv_backNavigationItemImage != nil {
                self._addBackItemForViewController(viewController: viewController)
            }
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    func _updateNavigationBarWithViewController(viewController: KVViewController) {
        if !(self.navigationBar is KVNavigationBar) {
            return
        }
        let navigationBar = self.navigationBar as! KVNavigationBar
        navigationBar.kv_navigationBarColor = viewController.kv_navigationBarColor
        navigationBar.kv_navigationBarAlpha = viewController.kv_navigationBarAlpha
        navigationBar.kv_navigationBarHidden = viewController.kv_navigationBarHidden
        navigationBar.kv_navigationBarShadowLineHidden = viewController.kv_navigationBarShadowLineHidden
        self._updateStatusBarWithViewController(viewController: viewController)
    }
    
    func _updateStatusBarWithViewController(viewController: KVViewController) {
        let statusBarStyle = viewController.preferredStatusBarStyle
        if statusBarStyle == .default {
            self.navigationBar.barStyle = .default
        } else {
            self.navigationBar.barStyle = .black
        }
    }
    
    func _updateNavigationBarToEmpty() {
        if !(self.navigationBar is KVNavigationBar) {
            return
        }
        let navigationBar = self.navigationBar as! KVNavigationBar
        navigationBar.kv_navigationBarColor = UIColor.clear
        navigationBar.kv_navigationBarAlpha = 1.0
        navigationBar.kv_navigationBarHidden = false
        navigationBar.kv_navigationBarShadowLineHidden = true
    }
    
    func _setNavigationBarToClear() {
        // 设置导航栏为透明
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    func _addBackItemForViewController(viewController: UIViewController) {
        var item: UIBarButtonItem? = nil
        if viewController is KVViewController {
            let baseVC = viewController as! KVViewController
            item = UIBarButtonItem.init(image: self.kv_backNavigationItemImage, style: .plain, target: baseVC, action: NSSelectorFromString("customNavigationBarBackItemDidClick"))
        } else {
            item = UIBarButtonItem.init(image: self.kv_backNavigationItemImage, style: .plain, target: self, action: #selector(_customBackItemClick))
        }
        viewController.navigationItem.leftBarButtonItem = item
    }
    
    @objc func _customBackItemClick() {
        self.popViewController(animated: true)
    }
    
    open override var shouldAutorotate: Bool {
        if self.topViewController == nil {
            return false
        }
        return self.topViewController!.shouldAutorotate
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        if self.topViewController == nil {
            return super.preferredInterfaceOrientationForPresentation
        }
        return self.topViewController!.preferredInterfaceOrientationForPresentation
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if self.topViewController == nil {
            return super.supportedInterfaceOrientations
        }
        return self.topViewController!.supportedInterfaceOrientations
    }
}

class KVNavigationBar: UINavigationBar {
    override func addSubview(_ view: UIView) {
        let className = NSStringFromClass(type(of: view))
        if className == "UINavigationItemButtonView" {
            view.isHidden = true
        }
        
        super.addSubview(view)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.kv_insteadBackgroundView.superview != nil {
            return;
        }
        
        self.subviews.first?.insertSubview(self.kv_insteadBackgroundView, at: 0)
        if self.kv_insteadBackgroundView.superview == nil {
            return;
        }
        let bounds = self.kv_insteadBackgroundView.superview!.bounds
        self.kv_insteadBackgroundView.frame = bounds
        self.kv_insteadBackgroundView.addSubview(self.kv_insteadShadowLine)
        let width = self.kv_insteadBackgroundView.frame.size.width
        let height = self.kv_insteadBackgroundView.frame.size.height
        let lineHeight = 1.0/UIScreen.main.scale
        self.kv_insteadShadowLine.frame = CGRect.init(x: 0.0, y: height-lineHeight, width:width, height: lineHeight)
    }
    
    lazy var kv_insteadBackgroundView: UIView = {
        let insteadBackgroundView = UIView()
        insteadBackgroundView.isUserInteractionEnabled = false
        insteadBackgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return insteadBackgroundView
    }()
    
    lazy var kv_insteadShadowLine: UIView = {
        let insteadShadowLine = UIView()
        insteadShadowLine.isUserInteractionEnabled = false
        insteadShadowLine.backgroundColor = UIColor.init(red: 222.0/255.0, green: 222.0/255.0, blue: 222.0/255.0, alpha: 1)
        insteadShadowLine.isHidden = true
        insteadShadowLine.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        return insteadShadowLine
    }()
    
    var kv_navigationBarColor: UIColor? {
        willSet {
            self.kv_insteadBackgroundView.backgroundColor = newValue ?? UIColor.white
        }
    }
    
    var kv_navigationBarAlpha: CGFloat? {
        willSet {
            self.kv_insteadBackgroundView.alpha = newValue ?? 0.0
        }
    }
    
    var kv_navigationBarHidden: Bool? {
        willSet {
            self.kv_insteadBackgroundView.isHidden = newValue ?? false
        }
    }
    
    var kv_navigationBarShadowLineHidden: Bool? {
        willSet {
            self.kv_insteadShadowLine.isHidden = newValue ?? false
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == nil {
            return nil
        }
        var className = NSStringFromClass(type(of: view!))
        className = className.replacingOccurrences(of: "_", with: "")
        if className == "UINavigationBarContentView" || className == "KVNavigationBar" {
            // 获取背景色alpha
            var alpha: CGFloat = 0.0;
            if self.kv_navigationBarColor != nil {
                self.kv_navigationBarColor?.getRed(nil, green: nil, blue: nil, alpha: &alpha)
            }
            if (self.kv_navigationBarAlpha ?? 0 <= 0.01 || self.kv_navigationBarHidden == true || alpha <= 0.01) {
                return nil;
            }
        }
        return view
    }
}
