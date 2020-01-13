//
//  KVImageView.swift
//  Alamofire
//
//  Created by 魏佳林 on 2020/1/11.
//

import UIKit
//import SDWebImage

//class KVImageView: SDAnimatedImageView {
//
//    open func setImageWithURLString(urlString: String?) {
//        self.setImageWithURLString(urlString: urlString, placeholderImage: nil)
//    }
//
//    open func setImageWithURLString(urlString: String?, placeholderImage: UIImage?) {
//        if urlString == nil {
//            self.image = nil
//            return
//        }
//
//        if urlString!.hasPrefix("http") {
//            // 网络图片
//            self.sd_setImage(with: URL.init(string: urlString!), placeholderImage: placeholderImage, options: .retryFailed, progress: nil, completed: nil)
//        } else {
//            // 本地图片
//            let image = UIImage.init(named: urlString!)
//            if image == nil {
//                self.image = placeholderImage
//            } else {
//                self.image = image
//            }
//        }
//    }
//
//}
