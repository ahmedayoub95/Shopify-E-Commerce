//
//  B2BViewController.swift
//  Shahalami.pk
//
//  Created by Ahmed on 19/11/2021.
//

import UIKit
import WebKit
class B2BViewController: UIViewController,WKUIDelegate {

    
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let myURL = URL(string:"https://shahalami.pk/pages/mobile-app-b2b")
             let myRequest = URLRequest(url: myURL!)
             webView.load(myRequest)
    }
    


}
