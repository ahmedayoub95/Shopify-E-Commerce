//
//  OrderInBulkViewController.swift
//  Shahalami.pk
//
//  Created by Ahmed on 16/12/2021.
//

import UIKit
import WebKit
import NVActivityIndicatorView
class OrderInBulkViewController: UIViewController {

    @IBOutlet weak var myWebView: WKWebView!
    
    @IBOutlet weak var animateView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        DispatchQueue.main.async {
            self.animateView.isHidden = false
            self.animateView.image = UIImage.gif(name: "Shahalami_cart_loader")
        }

        perform(#selector(authenticate), with: nil, afterDelay: 4)
 
      
        let url = NSURL (string: "https://shahalami.pk/pages/mobile-app-b2b")
        let requestObj = NSURLRequest(url: url! as URL)
        myWebView.load(requestObj as URLRequest)
     
    }
    @objc func authenticate(){
        self.animateView.isHidden = true
    }
    
}
