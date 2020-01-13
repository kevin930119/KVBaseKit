//
//  TestViewController.swift
//  KVBaseKit_Example
//
//  Created by 魏佳林 on 2020/1/11.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import KVBaseKit

class TestViewController: KVViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.kv_navigationBarColor = UIColor.red
        // Do any additional setup after loading the view.
        self.title = "你好"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = TestOneViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
