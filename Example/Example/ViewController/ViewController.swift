//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2021/9/15.
//  ~/Library/Caches/org.swift.swiftpm/
//  file:///Users/william/Desktop/WWHUD

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

