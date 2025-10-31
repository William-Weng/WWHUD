//
//  Constant.swift
//  WWHUD
//
//  Created by William Weng on 2025/3/16.
//

import UIKit

// MARK: - typealias
public extension WWHUD {
    typealias GIFImageInformation = (index: Int, cgImage: CGImage, pointer: UnsafeMutablePointer<Bool>)     // GIF動畫: (第幾張, CGImage, UnsafeMutablePointer<Bool>)
    typealias BasicAnimationInformation = (animation: CABasicAnimation, keyPath: AnimationKeyPath)          // Basic動畫資訊
    typealias KeyframeAnimationInformation = (animation: CAKeyframeAnimation, keyPath: AnimationKeyPath)    // Keyframe動畫資訊
    typealias RGBAInformation = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)               // [RGBA色彩模式的數值](https://stackoverflow.com/questions/28644311/how-to-get-the-rgb-code-int-from-an-uicolor-in-swift)
}

// MARK: - enum
public extension WWHUD {
    
    /// 動畫類型
    enum AnimationEffect {
        case `default`
        case shake(image: UIImage?, angle: Float = 0.7, duration: CFTimeInterval = 0.5)
        case translation(image: UIImage?, duration: CFTimeInterval = 1.0)
        case gif(url: URL, options: CFDictionary? = nil)
        case indicator(image: UIImage, count: Float = 12, size: CGSize, duration: CFTimeInterval = 0.5, cornerRadius: CGFloat = 0, backgroundColor: UIColor = .white, colorOffset: RGBAInformation = (0, 0, 0, 0))
        case breathingLight(image: UIImage?, duration: CFTimeInterval = 2.5, minAlpha: CGFloat = 0.2, maxAlpha: CGFloat = 1.0)
    }
    
    /// [動畫路徑 (KeyPath)](https://stackoverflow.com/questions/44230796/what-is-the-full-keypath-list-for-cabasicanimation)
    enum AnimationKeyPath: String {
        case strokeEnd = "strokeEnd"
        case opacity = "opacity"
        case rotationZ = "transform.rotation.z"
    }
}
