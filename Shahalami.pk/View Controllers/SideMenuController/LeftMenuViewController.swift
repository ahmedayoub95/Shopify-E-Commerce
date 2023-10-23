//
//  LeftMenuViewController.swift
//  Easy Shopping
//
//  Created by XintMac on 29/07/2021.
//
import AKSideMenu
import UIKit

@available(iOS 13.0, *)
class LeftMenuViewController: UIViewController {

    @IBOutlet weak var sideMenuUIView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let gradient = CAGradientLayer()

        gradient.frame = sideMenuUIView.bounds
        gradient.colors = [UIColor.systemIndigo.cgColor , UIColor.black.cgColor]

        sideMenuUIView.layer.insertSublayer(gradient, at: 0)
    }
    

    @IBAction func homeBtn(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "contentViewController") {
            sideMenuViewController?.setContentViewController(vc, animated: true)
            sideMenuViewController?.hideMenuViewController()
        }
  
    }
    
    @IBAction func settingsBtn(_ sender: Any) {
        if let vc2 = storyboard?.instantiateViewController(withIdentifier: "settingsSBID") {
            let contentViewController = UINavigationController(rootViewController: vc2)
            sideMenuViewController?.setContentViewController(contentViewController, animated: true)
            sideMenuViewController?.hideMenuViewController()
        }
        
    }
    
}
