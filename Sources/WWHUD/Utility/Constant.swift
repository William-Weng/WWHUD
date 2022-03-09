//
//  Constant.swift
//  WWHUDb
//
//  Created by iOS on 2022/3/2.
//

import UIKit

// MARK: - Utility (單例)
open class Constant: NSObject {}

// MARK: - typealias
public extension Constant {
    typealias GIFImageInformation = (index: Int, cgImage: CGImage, pointer: UnsafeMutablePointer<Bool>)             // GIF動畫: (第幾張, CGImage, UnsafeMutablePointer<Bool>)
    typealias BasicAnimationInformation = (animation: CABasicAnimation, keyPath: Constant.AnimationKeyPath)         // Basic動畫資訊
    typealias KeyframeAnimationInformation = (animation: CAKeyframeAnimation, keyPath: Constant.AnimationKeyPath)   // Keyframe動畫資訊
    typealias RGBAInformation = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)                       // [RGBA色彩模式的數值](https://stackoverflow.com/questions/28644311/how-to-get-the-rgb-code-int-from-an-uicolor-in-swift)
}

// MARK: - enum
public extension Constant {
    
    /// [動畫路徑 (KeyPath)](https://stackoverflow.com/questions/44230796/what-is-the-full-keypath-list-for-cabasicanimation)
    enum AnimationKeyPath: String {
        case strokeEnd = "strokeEnd"
        case opacity = "opacity"
        case rotationZ = "transform.rotation.z"
    }
}
