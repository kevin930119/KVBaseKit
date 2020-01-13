//
//  UIColor+KV.swift
//  Alamofire
//
//  Created by 魏佳林 on 2020/1/11.
//

import Foundation

extension UIColor {
    open class func color(hexString hex: String) -> UIColor {
        return self.color(hexString: hex, alpha: 1)
    }
    
    open class func color(hexString hex: String, alpha a: CGFloat) -> UIColor {
        var resultHexString: String = "000000"
        if hex.hasPrefix("0x") {
            if hex.lengthOfBytes(using: .utf8) < 8 {
                return UIColor.black
            }
            
            let startIndex = hex.index(hex.startIndex, offsetBy: 2)
            let stopIndex = hex.index(hex.startIndex, offsetBy: 6)
            resultHexString = String(hex[startIndex..<stopIndex])
        } else if hex.hasPrefix("#") {
            if hex.lengthOfBytes(using: .utf8) < 7 {
                return UIColor.black
            }
            
            let startIndex = hex.index(hex.startIndex, offsetBy: 1)
            let stopIndex = hex.index(hex.startIndex, offsetBy: 6)
            resultHexString = String(hex[startIndex..<stopIndex])
        } else {
            if hex.lengthOfBytes(using: .utf8) < 6 {
                return UIColor.black
            }
            
            resultHexString = hex
        }
        
        let scanner = Scanner.init(string: resultHexString)
        var hexInt: Int32 = 0x000000
        scanner.scanInt32(&hexInt)
        
        return self.color(hexInt: UInt32(hexInt), alpha: a)
    }
    
    open class func color(hexInt hex: UInt32) -> UIColor {
        return self.color(hexInt: hex, alpha: 1)
    }
    
    open class func color(hexInt hex: UInt32, alpha a: CGFloat) -> UIColor {
        let r = (hex & 0x00FF0000) >> 16;
        let g = (hex & 0x0000FF00) >> 8;
        let b = (hex & 0x000000FF);
        let red = CGFloat(r)/255.0;
        let green = CGFloat(g)/255.0;
        let blue = CGFloat(b)/255.0;
        return UIColor.init(red: red, green: green, blue: blue, alpha: a)
    }
    
    // MARK: - 动态颜色创建方法（适配暗黑模式）
    open class func colorByUserInterfaceStyle(light lc:UIColor, dark dc:UIColor?) -> UIColor {
        if dc == nil {
            return lc
        }
        
        if #available(iOS 13.0, *) {
            return UIColor.init { (t) -> UIColor in
                if t.userInterfaceStyle == UIUserInterfaceStyle.light {
                    return lc
                } else {
                    return dc!
                }
            }
        } else {
            return lc
        }
    }
    
    open class func colorByUserInterfaceStyleUsingHexInt(light lc:UInt32, dark dc:UInt32) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.init { (t) -> UIColor in
                if t.userInterfaceStyle == UIUserInterfaceStyle.light {
                    return UIColor.color(hexInt: lc)
                } else {
                    return UIColor.color(hexInt: dc)
                }
            }
        } else {
            return UIColor.color(hexInt: lc)
        }
    }
    
    open class func colorByUserInterfaceStyleUsingHexString(light lc:String, dark dc:String?) -> UIColor {
        if dc == nil {
            return UIColor.color(hexString: lc)
        }
        
        if #available(iOS 13.0, *) {
            return UIColor.init { (t) -> UIColor in
                if t.userInterfaceStyle == UIUserInterfaceStyle.light {
                    return UIColor.color(hexString: lc)
                } else {
                    return UIColor.color(hexString: dc!)
                }
            }
        } else {
            return UIColor.color(hexString: lc)
        }
    }
}
