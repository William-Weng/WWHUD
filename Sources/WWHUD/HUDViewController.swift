//
//  HUDViewController.swift
//  WWHUD
//
//  Created by William.Weng on 2022/2/10.
//

import UIKit

// MARK: - HUDViewController
final class HUDViewController: UIViewController {
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myProgressLabel: UILabel!
    @IBOutlet weak var forceCloseLabel: UILabel!
    @IBOutlet weak var myActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var heightLayoutConstraint: NSLayoutConstraint!
    
    weak var delegate: HUDViewController.Delegate?
    
    private var replicatorLayer = CAReplicatorLayer()
    private var gifEffectImageView: UIImageView?
    private var gifEffectBlock: ((Result<WWHUD.GIFImageInformation, Error>) -> Void)?
    private var isGifEffectStop = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transparent()
        updateProgess(text: nil)
        forceCloseLabelSetting()
    }
    
    @objc func forceClose(_ recognizer: UITapGestureRecognizer) {
        delegate?.forceClose()
    }
    
    deinit {
        delegate = nil
    }
}

// MARK: - 半公開的funciton
extension HUDViewController {
    
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
    
    /// 呼吸燈動畫效果 (透明度動畫)
    /// - Parameters:
    ///   - duration: 透明度變化時間
    ///   - minAlpha: 最小透明度
    ///   - maxAlpha: 最大透明度
    func breathingLightEffect(with image: UIImage?, duration: TimeInterval, minAlpha: CGFloat, maxAlpha: CGFloat) {
        
        removeAllEffect()
        
        myImageView.image = image
        myImageView.breathingLightEffect(duration: duration, minAlpha: minAlpha, maxAlpha: maxAlpha)
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
        
        isGifEffectStop = false
        
        gifEffectBlock = { result in
            switch result {
            case .failure(_): break
            case .success(let info): info.pointer.pointee = self.isGifEffectStop
            }
        }
        
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
    ///   - cornerRadius: 圓角
    func indicatorEffect(with image: UIImage, count: Float, size: CGSize, cornerRadius: CGFloat, duration: CFTimeInterval = 0.5, backgroundColor: UIColor = .white, colorOffset: WWHUD.RGBAInformation = (1.0, 0, 0, 0)) {
        
        let instanceLayer = instanceLayerMaker(image: image, size: size, backgroundColor: backgroundColor, cornerRadius: cornerRadius)._opacityEffect(duration: duration)
        
        removeAllEffect()
        replicatorLayer = replicatorLayerMaker(frame: myImageView.bounds, count: count, duration: duration, backgroundColor: backgroundColor, colorOffset: colorOffset)
        replicatorLayer.addSublayer(instanceLayer)
        
        myImageView.layer.addSublayer(replicatorLayer)
    }
        
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
    
    /// 更新進度文字及字型
    /// - Parameters:
    ///   - text: String?
    ///   - font: UIFont
    ///   - textColor: 文字顏色
    func updateProgess(text: String?, font: UIFont = .systemFont(ofSize: 36.0), textColor: UIColor = .white) {
        myProgressLabel.textColor = textColor
        myProgressLabel.font = font
        myProgressLabel.text = text
    }
    
    /// 關閉Label設定
    /// - Parameters:
    ///   - title: String?
    ///   - isHidden: Bool
    ///   - font: UIFont
    func closeLabelSetting(title: String? = "CLOSE", isHidden: Bool = false, font: UIFont = .systemFont(ofSize: 16)) {
        forceCloseLabel.text = title
        forceCloseLabel.font = font
        forceCloseLabel.isHidden = isHidden
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
    func replicatorLayerMaker(frame: CGRect, count: Float, duration: CFTimeInterval, backgroundColor: UIColor = .white, colorOffset: WWHUD.RGBAInformation = (1.0, 0, 0, 0)) -> CAReplicatorLayer {
        
        print(frame)
        
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
    ///   - cornerRadius: 圓角大小
    /// - Returns: CALayer
    func instanceLayerMaker(image: UIImage, size: CGSize, backgroundColor: UIColor, cornerRadius: CGFloat) -> CALayer {
        
        let middleX = myImageView.bounds.midX - size.width / 2.0
        let imageView = UIImageView(frame: CGRect(x: middleX, y: 0.0, width: size.width * 2, height: size.height))
        
        imageView.image = image
        imageView.layer.opacity = 0.0
        imageView.backgroundColor = backgroundColor
        
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = cornerRadius
        
        return imageView.layer
    }
    
    /// 加上GIF動畫使用的UIImageView
    /// - Returns: Bool
    func addGifImageView() -> Bool {
        
        gifEffectImageView = UIImageView(frame: myImageView.bounds)
        gifEffectImageView?.backgroundColor = .clear
        gifEffectImageView?.contentMode = .scaleAspectFit
        
        guard let gifEffectImageView = gifEffectImageView else { return false }
        myImageView.addSubview(gifEffectImageView)
        
        return true
    }
    
    /// 移除GIF效果 => 把View移掉 / GIF動畫關掉
    func removeGifEffect() {
        
        isGifEffectStop = true
        myImageView.alpha = 1.0
        
        gifEffectImageView?.removeFromSuperview()
        gifEffectImageView = nil
    }
    
    /// 設定強制關閉Label功能
    func forceCloseLabelSetting() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(HUDViewController.forceClose(_:)))
        
        closeLabelSetting(title: nil, isHidden: true)
        forceCloseLabel.addGestureRecognizer(tap)
        forceCloseLabel.isUserInteractionEnabled = true
    }
}
