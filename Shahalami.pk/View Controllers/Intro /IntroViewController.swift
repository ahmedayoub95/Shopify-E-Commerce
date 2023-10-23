//
//  IntroViewController.swift
//  Shahalami.pk
//
//  Created by Ahmed on 02/12/2021.
//

import UIKit

class IntroViewController: UIViewController {

    var userToken = AppUtility.sharedInstance.getTokenSession(forKey: USER_TOKEN_KEY)
    @IBOutlet weak var blueView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        blueView.layer.cornerRadius = 18
        blueView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        if userToken != nil{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "contentViewController") as! TabBarViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    

    
    // MARK: - Login
    @IBAction func loginBtn(_ sender: Any) {
        DispatchQueue.main.async { [self] in
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    }
    
    
    @IBAction func signUpBtn(_ sender: Any) {
        DispatchQueue.main.async { [self] in
            let cv = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signupVC") as! SignUpViewController
             self.navigationController?.pushViewController(cv, animated: true)
        }
        //self.performSegue(withIdentifier: "signup", sender: self)
    }
    
    
    @IBAction func guestBtn(_ sender: Any) {


        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainTabBarController = storyboard.instantiateViewController(identifier: "contentViewController") as! TabBarViewController
                mainTabBarController.modalPresentationStyle = .fullScreen
                self.present(mainTabBarController, animated: true, completion: nil)
    }
}
