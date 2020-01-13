//
//  KVAdaptScreenEdgePanScollView.swift
//  Alamofire
//
//  Created by 魏佳林 on 2020/1/11.
//

import UIKit

class KVAdaptScreenEdgePanScollView: UIScrollView, UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer.isKind(of: UIScreenEdgePanGestureRecognizer.self) {
            return true
        }
        return false
    }

}
