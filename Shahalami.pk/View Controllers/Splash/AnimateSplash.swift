//
//  AnimateSplash.swift
//  ezfresh.pk
//
//  Created by MAC on 18/08/2020.
//  Copyright © 2020 ExdNow. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import SwiftGifOrigin

@available(iOS 13.0, *)
class AnimateSplash: UIViewController {
    
    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet weak var imgGIF: UIImageView!
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(fire), userInfo: nil, repeats: true)
        //let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
      //  self.lblVersion.text = "version. \(String(describing: appVersion!))"
        DispatchQueue.main.async {
            // An animated UIImage
            self.imgGIF.image = UIImage.gif(name: "Shahalami_Splash")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        var userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
        if userInfo == nil {
            userInfo = UserModel()
            userInfo!.saveCurrentSession(forKey: USER_MODEL)
        }
        print(userInfo?.lineItems?.count ?? -1)
    }
    
    @objc func fire() {
        print("FIRE!!!")
        timer.invalidate()
        
        let userToken = AppUtility.sharedInstance.getTokenSession(forKey: USER_TOKEN_KEY)
        if userToken == nil{
            let cv=UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "introVC") as! IntroViewController
            //        cv.modalTransitionStyle = .crossDissolve
            //        self.present(cv, animated: true, completion: nil)
            self.navigationController?.pushViewController(cv, animated: true)
        }else{
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "contentViewController") as! TabBarViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
//            let cv=UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "introVC") as! IntroViewController
//            //        cv.modalTransitionStyle = .crossDissolve
//            //        self.present(cv, animated: true, completion: nil)
//            self.navigationController?.pushViewController(cv, animated: true)
        }
    }
}
