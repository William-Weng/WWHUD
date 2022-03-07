//
//  AppDelegate.swift
//  Example
//
//  Created by William.Weng on 2021/9/15.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance()._transparent()
        return true
    }
}

// MARK: - UINavigationBar (class function)
extension UINavigationBar {
    
    /// [透明背景 (透明底線) => application(_:didFinishLaunchingWithOptions:)](https://sarunw.com/posts/uinavigationbar-changes-in-ios13/)
    func _transparent() {
        
        if #available(iOS 13.0, *) { self.standardAppearance = UINavigationBarAppearance()._transparent(); return }
        
        let transparentBackground = UIImage()
        
        self.isTranslucent = true
        self.setBackgroundImage(transparentBackground, for: .default)
        self.shadowImage = transparentBackground
    }
}

// MARK: - UINavigationBarAppearance
@available(iOS 13.0, *)
extension UINavigationBarAppearance {
    
    /// 設定背景色透明 - UINavigationBar.appearance()._transparent()
    /// - Returns: UINavigationBarAppearance
    func _transparent() -> Self { configureWithTransparentBackground(); return self }
}
