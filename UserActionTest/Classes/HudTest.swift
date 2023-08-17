//
//  HudTest.swift
//  UserActionTest
//
//  Created by whqpMac007 on 2023/8/17.
//

import Foundation
import ProgressHUD

public class HudTest {
    
    public init() {
        
    }
    
    public func hud(str: String = "😂哈哈哈") {
        ProgressHUD.showError(str)
    }
}
