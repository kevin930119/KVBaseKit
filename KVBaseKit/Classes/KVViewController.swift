//
//  KVViewController.swift
//  KVBaseKit
//
//  Created by 魏佳林 on 2020/1/11.
//

import UIKit

open class KVViewController: UIViewController {
    
    // 是否支持导航控制器的Pop手势，默认true
    open var kv_supportPopGestureRecognizer: Bool {
        return true
    }
    
    // 是否隐藏导航栏，默认false，用于平滑地隐藏导航栏
    open var kv_prefersNavigationBarHidden: Bool {
        return false
    }
    
    /// 导航控制器方法
    // 自定义导航栏返回按钮点击，默认pop回上个页面，需要额外操作需重写此方法
    open func customNavigationBarBackItemDidClick() {
        if self.navigationController == nil {
            return;
        }
        
        if self.navigationController!.topViewController != self {
            return;
        }
        
        self.navigationController!.popViewController(animated: true)
    }
    
    // 将自身控制器从导航控制器栈上移除（之后的控制器一并出栈）
    open func popMyselfOutOfNavigationStackWithAnimated(animated: Bool) {
        if self.navigationController == nil {
            return;
        }
        
        let viewControllers = self.navigationController!.viewControllers
        let index = viewControllers.index(of: self)
        if index == NSNotFound {
            return;
        }
        let targetIndex = index!-1
        if targetIndex < 0 {
            return;
        }
        if targetIndex >= viewControllers.count-1 {
            return
        }
        let targetViewController = viewControllers[targetIndex]
        self.navigationController?.popToViewController(targetViewController, animated: animated)
    }
    
    /// 导航栏配置
    // 顶部预留空间的偏移量（状态栏+导航栏高度）
    open var kv_offetForHeadspace: Int {
        if self.navigationController == nil {
            return 0
        }
        if self.kv_prefersNavigationBarHidden {
            return 0
        }
        var statusBarHeight = KVDevice.current().statusBarHeight
        if self.prefersStatusBarHidden {
            statusBarHeight = 0
        }
        
        return Int(KVDevice.current().navigationBarHeight)+Int(statusBarHeight)
    }
    
    /// 以下属性请确保在控制器viewDidLoad里初始化
    // 导航栏颜色，默认白色
    open var kv_navigationBarColor: UIColor? = UIColor.white {
        willSet {
            self.kv_fakeNavigationBar.backgroundColor = newValue ?? UIColor.white
        }
    }
    // 导航栏透明度，默认1
    open var kv_navigationBarAlpha: CGFloat? = 1.0 {
        willSet {
            self.kv_fakeNavigationBar.alpha = newValue ?? 1.0
        }
    }
    // 导航栏阴影线是否隐藏，默认false
    open var kv_navigationBarShadowLineHidden: Bool? = false {
        willSet {
            self.kv_fakeNavigationBarShadowLine.isHidden = newValue ?? false
        }
    }
    // 是否隐藏导航栏，默认false，这里的隐藏导航栏并不会真正隐藏导航栏，只不过将导航栏变透明了
    open var kv_navigationBarHidden: Bool? = false {
        willSet {
            self.kv_fakeNavigationBar.isHidden = newValue ?? false
        }
    }
    
    // 更新导航栏样式
    // PS：想要修改导航栏样式请修改完以上属性后调用该方法使导航栏样式更新
    open func setNeedsUpdateOfKVNavigationBar() {
        if self.navigationController == nil {
            return
        }
        if !(self.navigationController is KVNavigationController) {
            return
        }
        let navigationController = self.navigationController as? KVNavigationController
        navigationController?.updateOfBaseNavigationBarUsingTopViewControllerConfig()
    }
    
    // 设置是否隐藏假导航栏，请勿调用
    open func setFakeNavigationBarHidden(hidden: Bool) {
        if self.kv_fakeNavigationBar.superview == nil {
            self.view.addSubview(self.kv_fakeNavigationBar)
            let width = self.view.frame.size.width
            self.kv_fakeNavigationBar.frame = CGRect.init(x: 0, y: 0, width: Int(width), height: self.kv_offetForHeadspace)
            let lineHeight = 1.0/UIScreen.main.scale
            self.kv_fakeNavigationBar.addSubview(self.kv_fakeNavigationBarShadowLine)
            self.kv_fakeNavigationBarShadowLine.frame = CGRect.init(x: 0, y: CGFloat(self.kv_offetForHeadspace)-lineHeight, width: width, height: lineHeight)
        }
        
        if hidden {
            self.kv_fakeNavigationBar.isHidden = hidden
        } else {
            self.kv_fakeNavigationBar.isHidden = self.kv_navigationBarHidden ?? false
            self.view.bringSubview(toFront: self.kv_fakeNavigationBar)
        }
    }
    
    lazy var kv_fakeNavigationBar: UIView = {
        let fakeNavigationBar = UIView()
        fakeNavigationBar.isUserInteractionEnabled = false
        fakeNavigationBar.isHidden = true
        fakeNavigationBar.autoresizingMask = .flexibleWidth
        return fakeNavigationBar
    }()
    
    lazy var kv_fakeNavigationBarShadowLine: UIView = {
        let fakeNavigationBarShadowLine = UIView()
        fakeNavigationBarShadowLine.isUserInteractionEnabled = false
        fakeNavigationBarShadowLine.backgroundColor = UIColor.init(red: 222.0/255.0, green: 222.0/255.0, blue: 222.0/255.0, alpha: 1)
        fakeNavigationBarShadowLine.autoresizingMask = .flexibleWidth
        return fakeNavigationBarShadowLine
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 刷新导航栏状态
        self.setNeedsUpdateOfKVNavigationBar()
    }
}
