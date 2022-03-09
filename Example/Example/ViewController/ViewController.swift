//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2021/9/15.
//  ~/Library/Caches/org.swift.swiftpm/
//  file:///Users/william/Desktop/WWHUD

import UIKit
import WWPrint
import WWHUD

final class ViewController: UIViewController {
    
    private var timer: CADisplayLink?
    private var percentage: Int = 0
    
    override func viewDidLoad() { super.viewDidLoad() }
    
    @IBAction func displayHUD(_ sender: UIBarButtonItem) {
        
        let image = #imageLiteral(resourceName: "Crab")
        
        updateProgressPercentage(selector: #selector(updateProgressForHUD))
        WWHUD.shared.display(effect: .shake(image: image, angle: 10.0, duration: 1.0), height: 128, backgroundColor: .green.withAlphaComponent(0.3))
    }
    
    @IBAction func displayGifHUD(_ sender: UIBarButtonItem) {
        
        guard let gifUrl = Bundle.main.url(forResource: "SeeYou", withExtension: ".gif") else { return }
        
        updateProgressPercentage(selector: #selector(updateProgressForGifHUD))
        WWHUD.shared.display(effect: .gif(url: gifUrl, options: nil), height: 256.0, backgroundColor: .red.withAlphaComponent(0.3))
    }
    
    @IBAction func flashHUD(_ sender: UIBarButtonItem) {
        
        let image = #imageLiteral(resourceName: "White")
        
        WWHUD.shared.flash(effect: .indicator(image: image, count: 12, size: CGSize(width: 2.0, height: 20), duration: 1.0, backgroundColor: .purple), height: 64, backgroundColor: .green.withAlphaComponent(0.3), animation: 3.0) { postion in
            wwPrint(postion)
        }
    }
    
    /// 更新進度 => 0% ~ 100%
    /// - Parameter sender: CADisplayLink
    @objc private func updateProgressForHUD(_ sender: CADisplayLink) {
        
        let percentageText = "\(percentage) %"
        
        WWHUD.shared.updateProgess(text: percentageText)
        percentage += 1
        
        if (percentage > 100) { dismissHUD() }
    }
    
    // 更新進度 => "努力下載中…" -> "下載快一半…" -> "就快下載完成了…" -> "還差一點點…" -> "終於下載完成了…"
    /// - Parameter sender: CADisplayLink
    @objc private func updateProgressForGifHUD(_ sender: CADisplayLink) {
        
        var percentageText = "努力下載中…"
        var percentageTextColor: UIColor = .clear

        switch percentage {
        case ...30:
            percentageText = "努力下載中…"
            percentageTextColor = .red
        case 31...60:
            percentageText = "下載快一半…"
            percentageTextColor = .yellow
        case 61...90:
            percentageText = "就快下載完成了…"
            percentageTextColor = .green
        case 90...99:
            percentageText = "還差一點點…"
            percentageTextColor = .blue
        case 100...:
            percentageText = "終於下載完成了…"
            percentageTextColor = .white
            dismissHUD()
        default: percentageText = ""
        }
        
        percentage += 1
        WWHUD.shared.updateProgess(text: percentageText, textColor: percentageTextColor)
    }
}

// MARK: - 小工具
extension ViewController {
    
    /// 取消HUD
    private func dismissHUD() {
        percentage = 0
        timer?.invalidate()
        timer = nil
        WWHUD.shared.dismiss { _ in WWHUD.shared.updateProgess(text: nil) }
    }
    
    /// 更新進度文字Timer
    /// - Parameter selector: Selector
    private func updateProgressPercentage(selector: Selector) {
        timer?.invalidate()
        timer = nil
        timer = CADisplayLink(target: self, selector: selector)
        timer?.preferredFramesPerSecond = 24
        timer?._fire()
    }
}
