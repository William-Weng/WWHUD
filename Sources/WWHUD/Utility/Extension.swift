//
//  Extension.swift
//  WWHUD
//
//  Created by iOS on 2022/3/2.
//

import UIKit

// MARK: - Float (class function)
extension Float {
    
    /// 180° => π
    func _radian() -> Float { return (self / 180.0) * Float.pi }
}

// MARK: - UIColr (class function)
extension UIColor {
    
    /// [取得顏色的RGBA值 => 0% ~ 100%](https://stackoverflow.com/questions/28644311/how-to-get-the-rgb-code-int-from-an-uicolor-in-swift)
    func _rgba() -> Constant.RGBAInformation? {
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else { return nil }
        return (red: red, green: green, blue: blue, alpha: alpha)
    }
}

// MARK: - UIWindow (static function)
extension UIWindow {
    
    /// 建立UIWindow
    /// - Parameters:
    ///   - rootViewController: UIViewController
    ///   - alpha: CGFloat
    ///   - windowLevel: UIWindow.Level
    ///   - backgroundColor: UIColor?
    /// - Returns: UIWindow?
    static func _build(rootViewController: UIViewController, alpha: CGFloat = 1.0, windowLevel: UIWindow.Level = .alert, backgroundColor: UIColor? = nil) -> UIWindow? {
        guard let scene = UIWindowScene._connected() else { return nil }
        return Self._build(scene: scene, rootViewController: rootViewController, alpha: alpha, windowLevel: windowLevel, backgroundColor: backgroundColor)
    }
    
    /// 建立UIWindow
    /// - Parameters:
    ///   - scene: UIWindowScene
    ///   - rootViewController: UIViewController
    ///   - alpha: CGFloat
    ///   - windowLevel: UIWindow.Level
    ///   - backgroundColor: UIColor?
    /// - Returns: UIWindow
    static func _build(scene: UIWindowScene, rootViewController: UIViewController, alpha: CGFloat = 1.0, windowLevel: UIWindow.Level = .alert, backgroundColor: UIColor? = nil) -> UIWindow {
        let newWindow = UIWindow(windowScene: scene)._alpha(alpha)._windowLevel(windowLevel)._backgroundColor(backgroundColor)._rootViewController(rootViewController)
        return newWindow
    }
}

// MARK: - UIWindow (class function)
extension UIWindow {
    
    /// 設定透明色
    /// - Parameter alpha: CGFloat
    /// - Returns: Self
    func _alpha(_ alpha: CGFloat) -> Self { self.alpha = alpha; return self }
    
    /// 設定背景色
    /// - Parameter color: UIColor
    /// - Returns: Self
    func _backgroundColor(_ color: UIColor?) -> Self { self.backgroundColor = color; return self }
    
    /// 設定Window的等級 => 越大越上層
    /// - Parameter level: UIWindow.Level
    /// - Returns: Self
    func _windowLevel(_ level: UIWindow.Level) -> Self { self.windowLevel = level; return self }
    
    /// 設定第一個ViewController
    /// - Parameter rootViewController: UIViewController
    /// - Returns: Self
    func _rootViewController(_ rootViewController: UIViewController?) -> Self { self.rootViewController = rootViewController; return self }
}

// MARK: - UIWindowScene
extension UIWindowScene {
    
    /// 取得第一個連接到的UIWindowScene
    /// - Returns: UIWindowScene
    static func _connected() -> UIWindowScene? {
        return UIApplication.shared.connectedScenes.first as? UIWindowScene
    }
}

// MARK: - UIView (class function)
extension UIView {
    
    /// [加上Z軸晃動效果](https://blog.csdn.net/zhaojian3513012/article/details/46532707)
    /// - Parameters:
    ///   - angle: 角度 (0° ~ 360°)
    ///   - duration: 左右晃動的時間
    func _shakeEffect(angle: Float = 7.0, duration: CFTimeInterval = 0.5) {
        _ = self.layer._shakeEffect(angle: angle, duration: duration)
    }
    
    /// [加上轉圈圈效果](https://github.com/William-Weng/Swift-4/blob/master/ImageDeleteShakeAnimation/ImageDeleteShakeAnimation/ViewController.swift)
    /// - Parameters:
    ///   - duration: 轉一圈的時間
    func _translationEffect(duration: CFTimeInterval = 0.5) {
        _ = self.layer._translationEffect(duration: duration)
    }
}

// MARK: - UIView (class function)
extension UIImageView {
    
    /// [播放GIF圖片 - 本地圖片](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/利用-cganimateimageaturlwithblock-播放-gif-4780071b835e)
    /// - Parameters:
    ///   - url: [URL](https://developer.apple.com/documentation/imageio/3333271-cganimateimageaturlwithblock)
    ///   - options: CFDictionary?
    ///   - result: Result<Bool, Error>
    /// - Returns: [OSStatus?](https://www.osstatus.com/)
    func _GIF(url: URL, options: CFDictionary? = nil, result: ((Result<Constant.GIFImageInformation, Error>) -> Void)?) -> OSStatus? {
        
        let cfUrl = url as CFURL
        let status = CGAnimateImageAtURLWithBlock(cfUrl, options) { (index, cgImage, pointer) in
            self.image = UIImage(cgImage: cgImage)
            result?(.success((index, cgImage, pointer)))
        }
        
        return status
    }
}

// MARK: - CALayer (class function)
extension CALayer {
    
    /// 加上動畫資訊
    /// - Parameters:
    ///   - info: (animation: T: CAAnimation, keyPath: Constant.AnimationKeyPath)
    /// - Returns: Self
    func _addAnimationInformation<T: CAAnimation>(_ info: (animation: T, keyPath: Constant.AnimationKeyPath)) -> Self {
        self.add(info.animation, forKey: info.keyPath.rawValue)
        return self
    }
    
    /// 加上透明度動畫效果 (全亮 100% => 全暗 0%)
    /// - Parameters:
    ///   - fromValue: Float
    ///   - toValue: Float
    ///   - duration: CFTimeInterval
    ///   - repeatCount: Float
    func _opacityEffect(fromValue: Float = 1.0, toValue: Float = 0.0, duration: CFTimeInterval = 1, repeatCount: Float = .infinity) -> Self {
        let info = CAAnimation._opacityAnimation(fromValue: fromValue, toValue: toValue, duration: duration, repeatCount: repeatCount)
        return self._addAnimationInformation(info)
    }
    
    /// [加上Z軸晃動效果](https://blog.csdn.net/zhaojian3513012/article/details/46532707)
    /// - Parameters:
    ///   - angle: 角度 (0° ~ 360°)
    ///   - duration: 左右晃動的時間
    /// - Returns: Constant.KeyframeAnimationInformation
    func _shakeEffect(angle: Float = 7.0 , duration: CFTimeInterval = 1.0) -> Self {
        let info = CAAnimation._shakeAnimation(angle: angle, duration: duration)
        return self._addAnimationInformation(info)
    }
    
    /// [加上轉圈圈效果](https://github.com/William-Weng/Swift-4/blob/master/ImageDeleteShakeAnimation/ImageDeleteShakeAnimation/ViewController.swift)
    /// - Parameter duration: 轉圈圈的時間
    /// - Returns: Self
    func _translationEffect(duration: CFTimeInterval = 0.5) -> Self {
        let info = CAAnimation._translationAnimation(duration: duration)
        return self._addAnimationInformation(info)
    }
}

// MARK: - CAReplicatorLayer (static function)
extension CAReplicatorLayer {
    
    /// [產生ReplicatorLayer (複製圖層 => 利用產生的時間差異的假象 -> 在圓形的路徑上，10秒內產生20個反射的layer)](https://www.jianshu.com/p/a927157ac62a)
    /// - Parameters:
    ///   - frame: [CGRect](https://www.jianshu.com/p/9ed9ce30a2e8)
    ///   - count: [Float](https://zsisme.gitbooks.io/ios-/content/chapter6/careplicatorLayer.html)
    ///   - preservesDepth: [preservesDepth](http://www.cocoachina.com/ios/20150318/11350.html)
    ///   - transform: [CATransform3D](https://www.appcoda.com.tw/catransform3d/)
    ///   - duration: [CFTimeInterval](https://www.raywenderlich.com/402-calayer-tutorial-for-ios-getting-started)
    ///   - color: UIColor
    ///   - colorOffset: Constant.RGBAInformation
    /// - Returns: Constant.RGBAInformation
    static func _build(with frame: CGRect, count: Float = 12, preservesDepth: Bool = false, transform: CATransform3D, duration: CFTimeInterval = 1.0, backgroundColor: UIColor = .white, colorOffset: Constant.RGBAInformation = (0, 0, 0, 0)) -> CAReplicatorLayer {
        
        let layer = CAReplicatorLayer()
        let delay = duration / Double(count)
        
        layer.frame = frame
        layer.preservesDepth = preservesDepth
        
        layer.instanceCount = Int(count)
        layer.instanceColor = backgroundColor.cgColor
        layer.instanceTransform = transform
        
        layer.instanceRedOffset = Float(colorOffset.red)
        layer.instanceGreenOffset = Float(colorOffset.green)
        layer.instanceBlueOffset = Float(colorOffset.blue)
        layer.instanceAlphaOffset = Float(colorOffset.alpha)
        
        layer.instanceDelay = CFTimeInterval(delay)
        
        return layer
    }
}

// MARK: - CAAnimation (static function)
extension CAAnimation {
    
    /// [Layer動畫產生器 (CABasicAnimation)](https://jjeremy-xue.medium.com/swift-說說-cabasicanimation-9be31ee3eae0)
    /// - Parameters:
    ///   - keyPath: [要產生的動畫key值](https://blog.csdn.net/iosevanhuang/article/details/14488239)
    ///   - fromValue: 開始的值
    ///   - toValue: 結束的值
    ///   - duration: 動畫時間
    /// - Returns: Constant.CAAnimationInformation
    static func _basicAnimation(keyPath: Constant.AnimationKeyPath = .strokeEnd, fromValue: Any?, toValue: Any?, duration: CFTimeInterval = 5.0, repeatCount: Float = 1.0) -> Constant.BasicAnimationInformation {
        
        let animation = CABasicAnimation(keyPath: keyPath.rawValue)
        
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.duration = duration
        animation.repeatCount = repeatCount
        
        return (animation, keyPath)
    }
    
    /// [Layer動畫產生器 (CAKeyframeAnimation)](https://blog.csdn.net/longshihua/article/details/51159654)
    /// - Parameters:
    ///   - keyPath: [Constant.AnimationKeyPath](https://ios.devdon.com/archives/1156)
    ///   - values: [Any]?
    ///   - duration: CFTimeInterval
    ///   - repeatCount: Float
    /// - Returns: Constant.KeyframeAnimationInformation
    static func _keyframeAnimation(keyPath: Constant.AnimationKeyPath = .rotationZ, values: [Any]? , duration: CFTimeInterval = 5.0, repeatCount: Float = 1.0) -> Constant.KeyframeAnimationInformation {
        
        let animation = CAKeyframeAnimation()
        
        animation.keyPath = keyPath.rawValue
        animation.values = values
        animation.repeatCount = repeatCount
        animation.duration = duration

        return (animation, keyPath)
    }
    
    /// 加上透明度動畫效果 (全亮 100% => 全暗 0% / 一直閃)
    /// - Parameters:
    ///   - fromValue: Float
    ///   - toValue: Float
    ///   - duration: CFTimeInterval
    ///   - repeatCount: Float
    /// - Returns: Constant.CAAnimationInformation
    static func _opacityAnimation(fromValue: Float = 1.0, toValue: Float = 0.0, duration: CFTimeInterval = 1, repeatCount: Float = .infinity) -> Constant.BasicAnimationInformation {
        return self._basicAnimation(keyPath: .opacity, fromValue: fromValue, toValue: toValue, duration: duration, repeatCount: repeatCount)
    }
    
    /// [Z軸晃動效果](https://blog.csdn.net/zhaojian3513012/article/details/46532707)
    /// - Parameters:
    ///   - angle: [角度 (0° ~ 360°)](https://blog.csdn.net/longshihua/article/details/51159654)
    ///   - duration: 左右晃動的時間
    /// - Returns: Constant.KeyframeAnimationInformation
    static func _shakeAnimation(angle: Float = 7.0 , duration: CFTimeInterval = 1.0) -> Constant.KeyframeAnimationInformation {
        
        let animationKey = Constant.AnimationKeyPath.rotationZ
        let shakeAngle = angle._radian()
        let values = [shakeAngle, -1 * shakeAngle, shakeAngle]
        
        return self._keyframeAnimation(keyPath: animationKey, values: values, duration: duration, repeatCount: .infinity)
    }
    
    /// [轉圈圈效果](https://github.com/William-Weng/Swift-4/blob/master/ImageDeleteShakeAnimation/ImageDeleteShakeAnimation/ViewController.swift)
    /// - Parameter duration: 轉圈圈的時間
    /// - Returns: Constant.KeyframeAnimationInformation
    static func _translationAnimation(duration: CFTimeInterval = 0.5) -> Constant.KeyframeAnimationInformation {
        
        let animationKey = Constant.AnimationKeyPath.rotationZ
        let values = [0, 2 * Double.pi]
        
        return self._keyframeAnimation(keyPath: animationKey, values: values, duration: duration, repeatCount: .infinity)
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
