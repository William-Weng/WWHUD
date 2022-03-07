# WWHUD

[![Swift-5.5](https://img.shields.io/badge/Swift-5.5-orange.svg?style=flat)](https://developer.apple.com/swift/) [![iOS-13.0](https://img.shields.io/badge/iOS-13.0-pink.svg?style=flat)](https://developer.apple.com/swift/) [![Swift Package Manager-SUCCESS](https://img.shields.io/badge/Swift_Package_Manager-SUCCESS-blue.svg?style=flat)](https://developer.apple.com/swift/) [![LICENSE](https://img.shields.io/badge/LICENSE-MIT-yellow.svg?style=flat)](https://developer.apple.com/swift/)

Custom read animation, support custom pictures, GIF animation. => [HUD - Head Up Display](https://youtu.be/6XVxvRKoAHM)
自定義讀取動畫，支援自定義圖片、GIF動畫 => [HUD - Head Up Display](https://youtu.be/6XVxvRKoAHM)

![](./Example.gif)

### [Installation with Swift Package Manager](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/使用-spm-安裝第三方套件-xcode-11-新功能-2c4ffcf85b4b)

```
dependencies: [
    .package(url: "https://github.com/William-Weng/WWHUD.git", .upToNextMajor(from: "1.0.0"))
]
```

### Example
```swift
import UIKit
import WWHUD
import WWPrint

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func displayHUD(_ sender: UIBarButtonItem) {
        
        let image = #imageLiteral(resourceName: "Crab")
        
        WWHUD.shared.display(effect: .shake(image: image, angle: 10.0, duration: 1.0), height: 128.0, backgroundColor: .green.withAlphaComponent(0.3))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            WWHUD.shared.dismiss { postion in
                wwPrint(postion)
            }
        }
    }
    
    @IBAction func displayGifHUD(_ sender: UIBarButtonItem) {
        
        guard let gifUrl = Bundle.main.url(forResource: "SeeYou", withExtension: ".gif") else { return }
        
        WWHUD.shared.display(effect: .gif(url: gifUrl, options: nil), height: 256.0, backgroundColor: .red.withAlphaComponent(0.3))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            WWHUD.shared.dismiss { postion in
                wwPrint(postion)
            }
        }
    }
    
    @IBAction func flashHUD(_ sender: UIBarButtonItem) {
        
        let image = #imageLiteral(resourceName: "White")
        
        WWHUD.shared.flash(effect: .indicator(image: image, count: 12, size: CGSize(width: 2.0, height: 20), duration: 1.0, backgroundColor: .purple), height: 64, backgroundColor: .green.withAlphaComponent(0.3), animation: 10.0) { postion in
            wwPrint(postion)
        }
    }
}
```


