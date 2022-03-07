//
//  HUDViewController.swift
//  WWHUD
//
//  Created by iOS on 2022/2/10.
//

import UIKit

final class HUDViewController: UIViewController {
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var heightLayoutConstraint: NSLayoutConstraint!
    
    private var gifEffectImageView: UIImageView?
    private var replicatorLayer = CAReplicatorLayer()
    private var gifEffectBlock: ((Result<Constant.GIFImageInformation, Error>) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transparent()
    }
}

// MARK: - 公開的funciton
extension HUDViewController {
    
    /// 設定高度 (大小)
    /// - Parameter height: CGFloat
    func heightSetting(_ height: CGFloat = 64.0) {
        heightLayoutConstraint.constant = height
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    /// 移除所有動畫效果
    func removeAllEffect() {
        
        removeGifEffect()
        replicatorLayer.removeAllAnimations()
        replicatorLayer.removeFromSuperlayer()
        
        myActivityIndicatorView.isHidden = true
        myImageView.image = nil
        myImageView.layer.removeAllAnimations()
    }
    
    /// [顯示iOS系統預設的UIActivityIndicatorView](http://furnacedigital.blogspot.com/2011/06/uiactivityindicatorview.html)
    func defaultEffect() {
        removeAllEffect()
        myActivityIndicatorView.isHidden = false
    }
    
    /// [晃動效果](https://blog.csdn.net/zhaojian3513012/article/details/46532707)
    /// - Parameters:
    ///   - image: UIImage?
    ///   - angle: 角度 (0° ~ 360°)
    ///   - duration: 左右晃動的時間
    func shakeEffect(with image: UIImage?, angle: Float = 7.0, duration: CFTimeInterval = 0.5) {
        
        removeAllEffect()
        
        myImageView.image = image
        myImageView._shakeEffect(angle: angle, duration: duration)
    }
    
    /// [轉圈圈效果](https://github.com/William-Weng/Swift-4/blob/master/ImageDeleteShakeAnimation/ImageDeleteShakeAnimation/ViewController.swift)
    /// - Parameters:
    ///   - image: UIImage?
    ///   - duration: 轉一圈的時間
    func translationEffect(with image: UIImage?, duration: CFTimeInterval = 1.0) {
        
        removeAllEffect()
        
        myImageView.image = image
        myImageView._translationEffect(duration: duration)
    }
    
    /// [播放GIF圖片 - 本地圖片](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/利用-cganimateimageaturlwithblock-播放-gif-4780071b835e)
    /// - Parameters:
    ///   - url: [URL](https://developer.apple.com/documentation/imageio/3333271-cganimateimageaturlwithblock)
    ///   - options: CFDictionary?
    func gifEffect(url: URL, options: CFDictionary? = nil) {
        
        removeAllEffect()
        
        guard addGifImageView() else { return }
        
        gifEffectBlock = { _ in }
        _ = gifEffectImageView?._GIF(url: url, options: options, result: { self.gifEffectBlock?($0) })
    }
    
    /// [自定義的轉圈圈效果](https://www.jianshu.com/p/a927157ac62a)
    /// - Parameters:
    ///   - image: 那一條的圖片
    ///   - count: 一圈的數量
    ///   - size: 那一條的大小
    ///   - duration: 轉一圈的時間
    ///   - backgroundColor: 圖片的底色
    ///   - colorOffset: 一圈的顏色變化
    func indicatorEffect(with image: UIImage, count: Float = 12, size: CGSize = CGSize(width: 2.0, height: 15.0), duration: CFTimeInterval = 0.5, backgroundColor: UIColor = .white, colorOffset: Constant.RGBAInformation = (1.0, 0, 0, 0)) {
        
        let instanceLayer = instanceLayerMaker(image: image, size: size, backgroundColor: backgroundColor)._opacityEffect(duration: duration)
        
        removeAllEffect()
        replicatorLayer = replicatorLayerMaker(frame: myImageView.bounds, count: count, duration: duration, backgroundColor: backgroundColor, colorOffset: colorOffset)
        replicatorLayer.addSublayer(instanceLayer)
                
        myImageView.layer.addSublayer(replicatorLayer)
    }
}

// MARK: - 小工具
private extension HUDViewController {
    
    /// 設定UIViewController透明背景 (當Alert用)
    func transparent() {
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .coverVertical
    }
    
    /// 產生ReplicatorLayer (複製圖層 => 利用產生的時間差異的假象 -> 在圓形的路徑上，10秒內產生20個反射的layer)
    /// - Parameters:
    ///   - frame: 圖層大小
    ///   - count: 有幾個轉圈圈
    ///   - duration: 轉一圈的時間
    ///   - backgroundColor: 單一條的底色
    ///   - colorOffset: 顏色偏移量
    /// - Returns: CAReplicatorLayer
    func replicatorLayerMaker(frame: CGRect, count: Float, duration: CFTimeInterval, backgroundColor: UIColor = .white, colorOffset: Constant.RGBAInformation = (1.0, 0, 0, 0)) -> CAReplicatorLayer {
        
        let angle = Float.pi * 2.0 / count
        let transform = CATransform3DMakeRotation(CGFloat(angle), 0.0, 0.0, 1.0)
        let layer = CAReplicatorLayer._build(with: frame, count: count, preservesDepth: false, transform: transform, duration: duration, backgroundColor: backgroundColor, colorOffset: colorOffset)
        
        return layer
    }
    
    /// 產生CALayer (做一個複製的基底標本)
    /// - Parameters:
    ///   - image: 單一條的底圖
    ///   - size: 單一條的大小
    ///   - backgroundColor: 單一條的底色
    /// - Returns: CALayer
    func instanceLayerMaker(image: UIImage, size: CGSize = CGSize(width: 2.0, height: 15.0), backgroundColor: UIColor = .white) -> CALayer {
        
        let middleX = myImageView.bounds.midX - size.width / 2.0
        let imageView = UIImageView(frame: CGRect(x: middleX, y: 0.0, width: size.width * 2, height: size.height))
        
        imageView.image = image
        imageView.layer.opacity = 0.0
        imageView.backgroundColor = backgroundColor
        
        return imageView.layer
    }
    
    /// 加上GIF動畫使用的UIImageView
    /// - Returns: Bool
    func addGifImageView() -> Bool {
        
        gifEffectImageView = UIImageView(frame: myImageView.bounds)
        gifEffectImageView?.backgroundColor = .clear
        
        guard let gifEffectImageView = gifEffectImageView else { return false }
        myImageView.addSubview(gifEffectImageView)
        
        return true
    }
    
    /// 移除GIF效果 => 把View移掉 / Block移掉
    func removeGifEffect() {
        gifEffectImageView?.removeFromSuperview()
        gifEffectImageView = nil
        gifEffectBlock = nil
    }
}


