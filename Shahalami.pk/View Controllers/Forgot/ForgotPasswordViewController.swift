//
//  ForgotPasswordViewController.swift
//  Shahalami.pk
//
//  Created by Ahmed on 01/11/2021.
//

import UIKit
import CDAlertView
import MobileBuySDK
import Reachability
import TransitionButton

class ForgotPasswordViewController: UIViewController {
    
   
    @IBOutlet weak var emailTextFeild: UITextField!
    @IBOutlet weak var blueView: UIView!
    
    @IBOutlet weak var sendMailButton: TransitionButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        AppUtility.bottomBorder(textfeild: emailTextFeild)
        blueView.layer.cornerRadius = 14
        blueView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    @IBAction func sendBtn(_ sender: Any) {
        
        self.sendMailButton.startAnimation()
        if(Reachability.isConnectedToNetwork()){
                
                let client = Graph.Client(
                    shopDomain: "onlineshahalmi.myshopify.com",
                    apiKey:     "9bbbc150b170f5ffa56d910da50dbbb7"
                )
                print(client)
                
                let mutation = Storefront.buildMutation { $0
                        .customerRecover(email: self.emailTextFeild.text ?? "") { $0
                        .customerUserErrors() { $0
                        .field()
                        .message()
                        }
                        }
                }
                
                let task = client.mutateGraphWith(mutation) { result, error in
                    DispatchQueue.main.async {
                        self.sendMailButton.stopAnimation()
                    }
                    if error == nil{
                        if (result?.customerRecover?.customerUserErrors.count)! > 0{
                            let message = result?.customerRecover?.customerUserErrors[0].message ?? "Something went wrong"
                            self.sendMailButton.stopAnimation()
                            self.showErrorMessage(message: message)
                        }else{
                            self.emailTextFeild.text = ""
                            self.sendMailButton.stopAnimation()
                            self.showErrorMessage(message: "An email with reset password link has been sent to your email address")
                        }
                    }else{
                        self.sendMailButton.stopAnimation()
                        let message = error.debugDescription
                        self.showErrorMessage(message: message)
                    }
                }
                task.resume()
                
            
        
      
        
    }else{
        CommonMethods.doSomething(view: self) {
            //self.sendBtn()
        }
    }
            
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func showErrorMessage(message:String) {
        
        let alert = CDAlertView(title: "Customer Login", message: message, type: .warning)
        let action = CDAlertViewAction(title: "Okay")
        alert.add(action: action)
        alert.isTextFieldHidden = true
        alert.hideAnimations = { (center, transform, alpha) in
            transform = .identity
            alpha = 0
        }
        alert.show() { (alert) in
        }
    }
    
}
