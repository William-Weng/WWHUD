//
//  Extension.swift
//  Example
//
//  Created by iOS on 2022/3/7.
//

import UIKit

// MARK: - UINavigationBar (class function)
extension UINavigationBar {
    
    /// [透明背景 (透明底線) => application(_:didFinishLaunchingWithOptions:)](https://sarunw.com/posts/uinavigationbar-changes-in-ios13/)
    func _transparent() {
                
        let transparentBackground = UIImage()
        
        self.isTranslucent = true
        self.setBackgroundImage(transparentBackground, for: .default)
        self.shadowImage = transparentBackground
    }
}

// MARK: - CADisplayLink (static function)
extension CADisplayLink {
    
    /// [產生CADisplayLink](https://www.hangge.com/blog/cache/detail_2278.html)
    /// - Parameters:
    ///   - target: AnyObject
    ///   - selector: Selector
    /// - Returns: CADisplayLink
    static func _build(target: AnyObject, selector: Selector) -> CADisplayLink {
        return CADisplayLink(target: target, selector: selector)
    }
}

// MARK: - CADisplayLink (class function)
extension CADisplayLink {
    
    /// [執行CADisplayLink Timer](https://ios.devdon.com/archives/922)
    /// - Parameters:
    ///   - runloop: [RunLoop](https://www.jianshu.com/p/b6ffd736729c)
    ///   - mode: [RunLoop.Mode](https://www.hangge.com/blog/cache/detail_2278.html)
    func _fire(to runloop: RunLoop = .main, forMode mode: RunLoop.Mode = .default) {
        self.add(to: runloop, forMode: mode)
        self.add(to: runloop, forMode: .tracking)
    }
}
