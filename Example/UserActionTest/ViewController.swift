//
//  ViewController.swift
//  UserActionTest
//
//  Created by 1243930473@qq.com on 08/17/2023.
//  Copyright (c) 2023 1243930473@qq.com. All rights reserved.
//

import UIKit
import ProgressHUD
import UserActionTest

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        HudTest().hud(str: "ddd")
        LoginTestFile().loginTest()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

