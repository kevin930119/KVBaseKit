//
//  PKDevice.swift
//  Alamofire
//
//  Created by 魏佳林 on 2020/1/11.
//

import UIKit

let kKVDeviceScreenWidth = UIScreen.main.bounds.size.width
let kKVDeviceScreenHeight = UIScreen.main.bounds.size.height

let kvdevice1 = KVDevice()

open class KVDevice: NSObject {
    class open func current() -> KVDevice {
        return kvdevice1
    }
    
    open var isPad: Bool {
        let model = UIDevice.current.model
        let range = model.range(of: "iPad")
        if range == nil {
            return false
        }
        return true
    }
    
    open var isIphoneX: Bool {
        if self.isPad {
            return false
        }
        
        let size = UIScreen.main.bounds.size
        let maxValue = max(size.width, size.height)
        if maxValue >= 812 {
            return true
        }
        
        return false
    }
    
    open var maxLengthOfScreen: CGFloat {
        let size = UIScreen.main.bounds.size
        return max(size.width, size.height)
    }
    
    open var minLengthOfScreen: CGFloat {
        let size = UIScreen.main.bounds.size
        return min(size.width, size.height)
    }
    
    open var appBundleIdentifier: String? {
        return Bundle.main.bundleIdentifier
    }
    
    open var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
        if version == nil {
            return ""
        }
        return version! as! String
    }
    
    open var appBuild: String {
        let build = Bundle.main.infoDictionary?["CFBundleVersion"]
        if build == nil {
            return ""
        }
        return build! as! String
    }
    
    open var appFullVersion: String {
        let str = String.init(format: "%@.%@", self.appVersion, self.appBuild)
        return str
    }
    
    open var navigationBarHeight: CGFloat {
        var height: CGFloat = 44.0
        if self.isPad {
            if #available(iOS 12.0, *) {
                height = 50.0;
            }
        }
        return height
    }
    
    open var statusBarHeight: CGFloat {
        if self.isIphoneX {
            return 44.0
        }
        return 20.0
    }
    
    open var tabBarHeight: CGFloat {
        if self.isIphoneX {
            return (49.0+34.0)
        }
        return 49.0
    }
    
    open var topSafeHeight: CGFloat {
        if self.isIphoneX {
            return 44.0
        }
        return 0.0
    }
    
    open var bottomSafeHeight: CGFloat {
        if self.isIphoneX {
            return 34.0
        }
        return 0.0
    }
}
