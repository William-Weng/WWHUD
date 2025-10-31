# WWHUD

[![Swift-5.7](https://img.shields.io/badge/Swift-5.7-orange.svg?style=flat)](https://developer.apple.com/swift/) [![iOS-16.0](https://img.shields.io/badge/iOS-16.0-pink.svg?style=flat)](https://developer.apple.com/swift/) ![](https://img.shields.io/github/v/tag/William-Weng/WWHUD) [![Swift Package Manager-SUCCESS](https://img.shields.io/badge/Swift_Package_Manager-SUCCESS-blue.svg?style=flat)](https://developer.apple.com/swift/) [![LICENSE](https://img.shields.io/badge/LICENSE-MIT-yellow.svg?style=flat)](https://developer.apple.com/swift/)

## [Introduction - 簡介](https://swiftpackageindex.com/William-Weng)
- [Custom read animation, support custom pictures, GIF animation.](https://youtu.be/6XVxvRKoAHM)
- [自定義讀取動畫，支援自定義圖片、GIF動畫。](https://youtu.be/6XVxvRKoAHM)

https://github.com/user-attachments/assets/cb43fb99-fe08-4250-8b85-da14f5ff6b32

### [Installation with Swift Package Manager](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/使用-spm-安裝第三方套件-xcode-11-新功能-2c4ffcf85b4b)

```
dependencies: [
    .package(url: "https://github.com/William-Weng/WWHUD.git", .upToNextMajor(from: "1.5.0"))
]
```

### [Function - 可用函式](https://zh.pngtree.com/freebackground/pink-beautiful-ancient-spring-on-new-peach-flower-background_1127034.html)
|函式|功能|
|-|-|
|display(effect:height:backgroundColor:)|顯示HUD動畫|
|dismiss(animation:options:completion:)|移除HUD顯示|
|flash(effect:height:backgroundColor:animation:options:completion:)|顯示一段時間的HUD動畫，然後會移除|
|updateProgess(text:font:textColor:)|更新進度文字及字型|
|closeLabelSetting(title:isHidden:font:)|強制關閉Label的顯示相關設定|

### [WWHUD.Delegate](https://ezgif.com/video-to-webp)
|函式|功能|
|-|-|
|forceClose(hud:)|強制關閉HUD|

### Example
```swift
import UIKit
import WWHUD

final class ViewController: UIViewController {
    
    private var timer: CADisplayLink?
    private var percentage: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WWHUD.shared.delegate = self
    }
}

extension ViewController: WWHUD.Delegate {
    
    func forceClose(hud: WWHUD) {
        percentage = 0
        cleanTimer()
    }
}

private extension ViewController {
    
    @IBAction func displayHUD(_ sender: UIBarButtonItem) {
        WWHUD.shared.flash()
    }
    
    @IBAction func displayImageHUD(_ sender: UIBarButtonItem) {
        
        let image = #imageLiteral(resourceName: "Crab")
        
        updateProgressPercentage(selector: #selector(updateProgressForHUD))
        WWHUD.shared.display(effect: .shake(image: image, angle: 10.0, duration: 1.0), height: 128, backgroundColor: .green.withAlphaComponent(0.3))
    }
    
    @IBAction func displayGifHUD(_ sender: UIBarButtonItem) {
        
        guard let gifUrl = Bundle.main.url(forResource: "SeeYou", withExtension: ".gif") else { return }
        
        updateProgressPercentage(selector: #selector(updateProgressForGifHUD))
        WWHUD.shared.display(effect: .gif(url: gifUrl, options: nil), height: 256.0, backgroundColor: .black.withAlphaComponent(0.3))
    }
    
    @IBAction func flashHUD(_ sender: UIBarButtonItem) {
        
        let image = #imageLiteral(resourceName: "White")
        
        WWHUD.shared.flash(effect: .indicator(image: image, count: 8, size: CGSize(width: 20, height: 40), duration: 1.0, cornerRadius: 20, backgroundColor: .yellow), height: 200, backgroundColor: .black.withAlphaComponent(0.3), animation: 2.0) { postion in
            print(postion)
        }
    }
}

private extension ViewController {
    
    @objc func updateProgressForHUD(_ sender: CADisplayLink) {
        
        let percentageText = "\(percentage) %"
        
        WWHUD.shared.updateProgess(text: percentageText)
        percentage += 1
        
        if (percentage > 100) { dismissHUD() }
    }
    
    @objc func updateProgressForGifHUD(_ sender: CADisplayLink) {
        
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
            WWHUD.shared.closeLabelSetting(title: "關閉")
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
private extension ViewController {
    
    func cleanTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func dismissHUD() {
        cleanTimer()
        percentage = 0
        WWHUD.shared.dismiss { _ in WWHUD.shared.updateProgess(text: nil) }
    }
    
    func updateProgressPercentage(selector: Selector) {
        timer?.invalidate()
        timer = nil
        timer = CADisplayLink(target: self, selector: selector)
        timer?.preferredFramesPerSecond = 24
        timer?._fire()
    }
}
```

