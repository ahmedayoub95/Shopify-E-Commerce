//
//  AnimateSplashViewController.swift
//  Shahalami.pk
//
//  Created by Ahmed on 29/11/2021.
//

import UIKit
import SwiftGifOrigin
class AnimateSplashViewController: UIViewController {

    @IBOutlet weak var gifImageView: UIImageView!
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(fire), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
        DispatchQueue.main.async {
            // An animated UIImage
            self.gifImageView.image = UIImage.gif(name: "Shahalami_Splash_Screen_PNG")
        }
    }
    
    @objc func fire() {
        print("FIRE!!!")
        timer.invalidate()
        
    }
}
