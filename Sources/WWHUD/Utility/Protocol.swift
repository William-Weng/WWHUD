//
//  Protocol.swift
//  WWHUD
//
//  Created by William Weng on 2025/3/16.
//

import UIKit

// MARK: - WWHUD.Delegate
extension WWHUD {
    
    public protocol Delegate: AnyObject {
        func forceClose(hud: WWHUD)     // 強制關閉HUD
    }
}

// MARK: - HUDViewController.Delegate
extension HUDViewController {
    
    protocol Delegate: AnyObject {
        func forceClose()               // 強制關閉HUD
    }
}
