//
//  ResetPasswordViewController.swift
//  Shahalami.pk
//
//  Created by Ahmed on 01/11/2021.
//

import UIKit
import Toast_Swift
import CDAlertView
import NVActivityIndicatorView
import TransitionButton
class ResetPasswordViewController: UIViewController {

    
    @IBOutlet weak var currentnPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var activityView: NVActivityIndicatorView!
    @IBOutlet weak var resetButton: TransitionButton!
    
    let iconButtonFirst = UIButton()
    let iconButtonSecond = UIButton()
    let iconButtonThird = UIButton()
    var isShowCurrent = true
    var isShowNew = true
    var isShowConfirm = true
    var objProfile : ProfileViewController?
    
    var userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    //MARK: - RESET BUTTON PRESSED
    
    @IBAction func resetBtn(_ sender: Any) {
        
        if checkFiledEmpty(){
            let userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
            if currentnPasswordTextField.text == userInfo?.password{
                self.resetButton.startAnimation()
                if newPasswordTextField.text == confirmPasswordTextField.text{
                    resetPassAPI()
                }else{
                    DispatchQueue.main.async {
                        self.resetButton.stopAnimation()
                        self.view.makeToast("Password doesn't match")
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.view.makeToast("Wrong Passwrod. Try Again!")
                }
            }
        }
    }
    
    
    
    //MARK: - VALIDATIONS
   
    func checkFiledEmpty()->Bool{
        var valid=true
        
        if(currentnPasswordTextField.text==""){
            
            currentnPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Provied Current Password",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            valid=false
            
        }
        
        if(newPasswordTextField.text==""){
            newPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Provide New Password",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            valid=false
        }
        
        if(confirmPasswordTextField.text==""){
            confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Provide New Password",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            valid=false
        }
        return valid
    }
    
    
    
    //MARK: - API CALL
    
    func resetPassAPI(){
        
        let prm = ["id":(userInfo?.userID!)! as Int,
                   "password":self.newPasswordTextField.text! as String,
                   "password_confirmation":confirmPasswordTextField.text! as String] as [String:AnyObject]
        print(prm)
        let param = ["customer":prm]
        //        GIFHUD.shared.show()
       // activityView.startAnimating()
        ServerManager.sharedInstance.putRequest(param: param,url: ServerManager.sharedInstance.BASE_URL + "customers/\((userInfo?.userID!)!).json", completion: {js in
            print(js)
            self.getDataInfo(json: js)
        })
    }
    
    fileprivate func getDataInfo(json:AnyObject){
        
        if json is [String:Any]{
            
            let json = json as! [String: Any]
            if json.keys.contains("status"){
                let pass = json["message"] as! String
                let errorMessage = pass
                DispatchQueue.main.async {
                    self.resetButton.stopAnimation()
                    self.view.makeToast(errorMessage)
                }
            }else{
                DispatchQueue.main.async {
                    self.resetButton.stopAnimation()
                    self.userInfo?.password = self.newPasswordTextField.text!
                    self.userInfo?.saveCurrentSession(forKey: USER_MODEL)
                    self.view.makeToast("Password changed successfully")
                    self.currentnPasswordTextField.text = ""
                    self.newPasswordTextField.text = ""
                    self.confirmPasswordTextField.text = ""
                }
            }
        }else{
            DispatchQueue.main.async {
                // GIFHUD.shared.dismiss()
                self.resetButton.stopAnimation()
                let message = json.value(forKey: "message") as! String
                self.showErrorMessage(message: message)
            }
        }
    }
    
    
    //MARK: - ERROR/SUCCESS MESSAGE
    func showErrorMessage(message:String){
        
        let alert = CDAlertView(title: "", message: message, type: .warning)
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
    
    //MARK: - SETUP
    
    func setup(){
        AppUtility.bottomBorder(textfeild: currentnPasswordTextField)
        AppUtility.bottomBorder(textfeild: newPasswordTextField)
        AppUtility.bottomBorder(textfeild: confirmPasswordTextField)
        
        self.currentnPasswordTextField.textFieldwithImage(direction: .Right, image: UIImage(named: "ic_Show")!, iconBtn: iconButtonFirst)
        self.newPasswordTextField.textFieldwithImage(direction: .Right, image: UIImage(named: "ic_Show")!, iconBtn: iconButtonSecond)
        self.confirmPasswordTextField.textFieldwithImage(direction: .Right, image: UIImage(named: "ic_Show")!, iconBtn: iconButtonThird)
        
        iconButtonFirst.addTarget(self, action: #selector(self.showHideCurrentPassButton), for: .touchUpInside)
        iconButtonSecond.addTarget(self, action: #selector(self.showHideNewPassButton), for: .touchUpInside)
        iconButtonThird.addTarget(self, action: #selector(self.showHideConfirmPassButton), for: .touchUpInside)
        currentnPasswordTextField.isSecureTextEntry = true
        newPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true
    }
    
    //MARK: - HIDE / SHOW PASSWORD BUTTONS
    
    @objc func showHideCurrentPassButton(){
        
        if isShowCurrent{
            self.currentnPasswordTextField.textFieldwithImage(direction: .Right, image: UIImage(named: "ic_Hide")!, iconBtn:iconButtonFirst)
            isShowCurrent = false
            self.currentnPasswordTextField.isSecureTextEntry = false
        }else{
            self.currentnPasswordTextField.textFieldwithImage(direction: .Right, image: UIImage(named: "ic_Show")!,iconBtn:iconButtonFirst)
            isShowCurrent = true
            self.currentnPasswordTextField.isSecureTextEntry = true
        }
    }
  
    
    @objc func showHideNewPassButton(){
        
        if isShowNew{
            self.newPasswordTextField.textFieldwithImage(direction: .Right, image: UIImage(named: "ic_Hide")!, iconBtn:iconButtonSecond)
            isShowNew = false
            self.newPasswordTextField.isSecureTextEntry = false
        }else{
            self.newPasswordTextField.textFieldwithImage(direction: .Right, image: UIImage(named: "ic_Show")!,iconBtn:iconButtonSecond)
            isShowNew = true
            self.newPasswordTextField.isSecureTextEntry = true
        }
    }
  
    @objc func showHideConfirmPassButton(){
        
        if isShowConfirm{
            self.confirmPasswordTextField.textFieldwithImage(direction: .Right, image: UIImage(named: "ic_Hide")!, iconBtn:iconButtonThird)
            isShowConfirm = false
            self.confirmPasswordTextField.isSecureTextEntry = false
        }else{
            self.confirmPasswordTextField.textFieldwithImage(direction: .Right, image: UIImage(named: "ic_Show")!,iconBtn:iconButtonThird)
            isShowConfirm = true
            self.confirmPasswordTextField.isSecureTextEntry = true
        }
    }

}
