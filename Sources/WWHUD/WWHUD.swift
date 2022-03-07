//
//  WWHUD.swift
//  WWHUD
//
//  Created by iOS on 2022/3/2.
//

import UIKit

open class WWHUD {
    
    public enum AnimationEffect {
        case `default`
        case shake(image: UIImage?, angle: Float = 0.7, duration: CFTimeInterval = 0.5)
        case translation(image: UIImage?, duration: CFTimeInterval = 1.0)
        case gif(url: URL, options: CFDictionary? = nil)
        case indicator(image: UIImage, count: Float = 12, size: CGSize, duration: CFTimeInterval = 0.5, backgroundColor: UIColor = .white, colorOffset: Constant.RGBAInformation = (0, 0, 0, 0))
    }
    
    public static let shared = WWHUD()
    
    private let hudWindow: UIWindow
    private let hudViewController: HUDViewController
    
    /// 初始化HUD
    init() {
        
        guard let rootViewController = Optional.some(HUDViewController(nibName: String(describing: HUDViewController.self), bundle: .module)),
              let window = UIWindow._build(rootViewController: rootViewController)
        else {
            fatalError("HUD do not created !!!")
        }
        
        hudWindow = window
        hudWindow.makeKeyAndVisible()
        hudViewController = rootViewController
        hudViewController.loadViewIfNeeded()
    }
}

// MARK: - 公開的function
public extension WWHUD {
    
    /// [顯示HUD動畫](https://github.com/relatedcode/ProgressHUD)
    /// - Parameters:
    ///   - effect: 選擇HUD的樣式
    ///   - height: HUD框框的大小
    ///   - backgroundColor: 整個的背景色
    func display(effect: AnimationEffect? = nil, height: CGFloat = 64.0, backgroundColor: UIColor = .black.withAlphaComponent(0.3)) {
        
        hudWindow.alpha = 1.0
        hudWindow.backgroundColor = backgroundColor
        hudViewController.heightSetting(height)
        
        guard let effect = effect else { return }
        
        switch effect {
        case .default: hudViewController.defaultEffect()
        case .shake(let image, let angle, let duration): hudViewController.shakeEffect(with: image, angle: angle, duration: duration)
        case .translation(let image, let duration): hudViewController.translationEffect(with: image, duration: duration)
        case .gif(let url, let options): hudViewController.gifEffect(url: url, options: options)
        case .indicator(let image, let count, let size, let duration, let color, let colorOffset): hudViewController.indicatorEffect(with: image, count: count, size: size, duration: duration, backgroundColor: color, colorOffset: colorOffset)
        }
    }
    
    /// 移除HUD顯示
    /// - Parameters:
    ///   - duration: TimeInterval
    ///   - options: UIView.AnimationOptions
    ///   - completion: ((UIViewAnimatingPosition) -> Void)?
    func dismiss(animation duration: TimeInterval = 0.5, options: UIView.AnimationOptions = [.curveEaseInOut], completion: ((UIViewAnimatingPosition) -> Void)?) {
        
        hudWindow.alpha = 1.0
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: duration, delay: 0, options: [.curveEaseInOut], animations: {
            self.hudWindow.alpha = 0.0
        }, completion: { (position) in
            self.hudViewController.removeAllEffect()
            completion?(position)
        })
    }
    
    /// 顯示一段時間的HUD動畫，然後會移除
    /// - Parameters:
    ///   - effect: AnimationEffec?
    ///   - height: CGFloat
    ///   - backgroundColor: UIColor
    ///   - duration: TimeInterval
    ///   - options: UIView.AnimationOptions
    ///   - completion: ((UIViewAnimatingPosition) -> Void)?
    func flash(effect: AnimationEffect? = nil, height: CGFloat = 64.0, backgroundColor: UIColor = .black.withAlphaComponent(0.1), animation duration: TimeInterval = 0.5, options: UIView.AnimationOptions = [.curveEaseInOut], completion: ((UIViewAnimatingPosition) -> Void)?) {
        display(effect: effect, height: height, backgroundColor: backgroundColor)
        dismiss(animation: duration, options: options) { postion in completion?(postion) }
    }
}
