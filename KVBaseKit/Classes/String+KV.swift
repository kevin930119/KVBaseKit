//
//  String+KV.swift
//  Alamofire
//
//  Created by 魏佳林 on 2020/1/11.
//

import Foundation
import CommonCrypto

extension String {
    public func MD5String() -> String {
        if self.lengthOfBytes(using: .utf8) == 0 {
            return ""
        }
        
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: .utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        return String(format: hash as String)
    }
}
