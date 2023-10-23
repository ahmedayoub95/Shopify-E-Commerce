//
//  SignUpViewController.swift
//  Shahalami.pk
//
//  Created by Ahmed on 01/11/2021.
//

import UIKit
import Toast_Swift
import CDAlertView
import MobileBuySDK
import iOSDropDown
import TransitionButton
class SignUpViewController: UIViewController {

    
    
    @IBOutlet weak var signUpButtonView: UIView!
    @IBOutlet weak var signUpButton: TransitionButton!
    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var firstNameTextfield: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneTetField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var codeDropDown: DropDown!
    @IBOutlet weak var phoneCodeTextField: UITextField!
    
    
    let iconButtonFirst = UIButton()
    let iconButtonSecond = UIButton()
    var isShow = true
    var isShowConfirm = true
    var isFromIntro: Bool = true
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
       setup()
    }


    
    @IBAction func signUpBtn(_ sender: Any) {
       
        if self.checkFieldEmpty(){
            if passwordTextField.text == confirmPasswordTextField.text{
               signUpButton.startAnimation()
               createUser()
            }else{
                self.view.makeToast("Password & Confirm Password does not match! Try again")
            }
        }
    }
    
    
    @IBAction func loginBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func guestLoginBtn(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainTabBarController = storyboard.instantiateViewController(identifier: "contentViewController") as! TabBarViewController
                mainTabBarController.modalPresentationStyle = .fullScreen
                
                self.present(mainTabBarController, animated: true, completion: nil)
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        
        
        if isFromIntro == false{
        self.dismiss(animated: true)
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "LoginVC") as! LoginViewController
            vc.isFromIntro = true
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    
    //MARK: - CREATE USER
    func createUser(){
        
//        GIFHUD.shared.setGif(named: AppConstatns.sharedInstance.apiGif)
//        GIFHUD.shared.show()
     //   activityView.startAnimating()
        let client = Graph.Client(
            shopDomain: "onlineshahalmi.myshopify.com",//graphql.myshopify.com
            apiKey:     "9bbbc150b170f5ffa56d910da50dbbb7"//8e2fef6daed4b93cf4e731f580799dd1
        )
        print(client)
        
        let input = Storefront.CustomerCreateInput.create(email: emailTextField.text!, password: passwordTextField.text!, firstName: Input<String>.value(firstNameTextfield.text!),lastName: Input<String>.value(lastNameTextField.text!), phone: Input<String>.value(phoneTetField.text!), acceptsMarketing: Input<Bool>.value(true))
        
        let mutation = Storefront.buildMutation { $0
            .customerCreate(input: input) { $0
                .customer { $0
                    .id()
                    .email()
                    .firstName()
                    .lastName()
            }
            .customerUserErrors{ $0
            .field()
            .message()
                }
            }
        }
        
        let task = client.mutateGraphWith(mutation) { [self] result, error in
            
//            GIFHUD.shared.dismiss()
            print(result)
            if (error == nil) {
                if result?.customerCreate?.customerUserErrors == nil || result?.customerCreate?.customerUserErrors.count == 0{
                    let checkoutID = (result?.customerCreate?.customer?.id).map { $0.rawValue }
                    print(checkoutID ?? "ID is nil")
                    self.showSuccessMessage()
                    self.emailTextField.text = ""
                    self.firstNameTextfield.text = ""
                    self.lastNameTextField.text = ""
                    self.phoneTetField.text = ""
                    self.passwordTextField.text = ""
                    self.confirmPasswordTextField.text = ""
                    self.signUpButton.stopAnimation()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(identifier: "LoginVC") as! LoginViewController
                    self.navigationController?.popViewController(animated: true)
                }else{
                    
                    if let error = result?.customerCreate?.customerUserErrors[0].message{
                        print(error)
                        self.showErrorMessage(message: error)
                        self.signUpButton.stopAnimation()
                        //                    Utilities.sharedInstance.showStandardDialog(alertTitle: "Error", alertMessage: error as String, okButtonTitle: "Ok", cancelButtonTitle: "", sender: self, completionHandler: nil)
                    }else{
                        print("Error is nil")
                    }
                }
            }else{
                if let error = error, case .invalidQuery(let reasons) = error {
                    reasons.forEach {
                        self.showErrorMessage(message: "Error on \(String(describing: $0.line)):\(String(describing: $0.column)) - \($0.message)")
                    }
                }
            }
        }
        task.resume()
    }
    
    
    //MARK: - SETUP
    
      func setup()  {
          
          AppUtility.bottomBorder(textfeild: firstNameTextfield)
          AppUtility.bottomBorder(textfeild: lastNameTextField)
          AppUtility.bottomBorder(textfeild: phoneTetField)
          AppUtility.bottomBorder(textfeild: emailTextField)
          AppUtility.bottomBorder(textfeild: passwordTextField)
          AppUtility.bottomBorder(textfeild: confirmPasswordTextField)

          self.passwordTextField.isSecureTextEntry = true
          self.confirmPasswordTextField.isSecureTextEntry = true
          
          
          self.passwordTextField.textFieldwithImage(direction: .Right, image: UIImage(named: "ic_Show")!, iconBtn: iconButtonFirst)
          self.confirmPasswordTextField.textFieldwithImage(direction: .Right, image: UIImage(named: "ic_Show")!, iconBtn: iconButtonSecond)
          
          
          iconButtonFirst.addTarget(self, action: #selector(self.showHideCurrentPassButton), for: .touchUpInside)
          iconButtonSecond.addTarget(self, action: #selector(self.showHideNewPassButton), for: .touchUpInside)
          
          blueView.layer.cornerRadius = 14
          blueView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

      }

      
      
      @objc func showHideCurrentPassButton(){
          
          if isShow{
              self.passwordTextField.textFieldwithImage(direction: .Right, image: UIImage(named: "ic_Hide")!, iconBtn:iconButtonFirst)
              isShow = false
              self.passwordTextField.isSecureTextEntry = false
          }else{
              self.passwordTextField.textFieldwithImage(direction: .Right, image: UIImage(named: "ic_Show")!,iconBtn:iconButtonFirst)
              isShow = true
              self.passwordTextField.isSecureTextEntry = true
          }
      }
    
      
      @objc func showHideNewPassButton(){
          
          if isShowConfirm{
              self.confirmPasswordTextField.textFieldwithImage(direction: .Right, image: UIImage(named: "ic_Hide")!, iconBtn:iconButtonSecond)
              isShowConfirm = false
              self.confirmPasswordTextField.isSecureTextEntry = false
          }else{
              self.confirmPasswordTextField.textFieldwithImage(direction: .Right, image: UIImage(named: "ic_Show")!,iconBtn:iconButtonSecond)
              isShowConfirm = true
              self.confirmPasswordTextField.isSecureTextEntry = true
          }
      }
//MARK: - MESSAGES
    
    func showErrorMessage(message:String){
        
        let alert = CDAlertView(title: "Customer Signup", message: message, type: .warning)
        let action = CDAlertViewAction(title: "Okay")
        alert.add(action: action)
        alert.isTextFieldHidden = true
        alert.hideAnimations = { (center, transform, alpha) in
            transform = .identity
            alpha = 0
        }
        alert.show() { (alert) in
            
            if message == "We have sent an email to \(self.emailTextField.text!), please click the link included to verify your email address."{
//                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func showSuccessMessage(){
        
        let alert = CDAlertView(title: "Customer SignUp", message: "User created successfully", type: .success)
        let action = CDAlertViewAction(title: "Okay")
        alert.add(action: action)
        alert.isTextFieldHidden = true
        alert.hideAnimations = { (center, transform, alpha) in
            transform = .identity
            alpha = 0
        }
        alert.show() { (alert) in
            //self.loginUser()
        }
    }
      
    
    
    //MARK: - VALIDATE TEXTFIELDS
    func checkFieldEmpty()->Bool{
        var valid=true
        
        if(firstNameTextfield.text==""){
            
            firstNameTextfield.attributedPlaceholder = NSAttributedString(string: "Provide name",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            valid=false
        }
        if(lastNameTextField.text==""){
            
            lastNameTextField.attributedPlaceholder = NSAttributedString(string: "Provide name",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            valid=false
        }
        if(emailTextField.text==""){
            
            emailTextField.attributedPlaceholder = NSAttributedString(string: "Provied email",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            valid=false
            
        }else{
            if !AppUtility.isValidEmail(testStr: emailTextField.text!){
                emailTextField.text=""
                emailTextField.attributedPlaceholder = NSAttributedString(string: "Email should be valid",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
                valid=false
            }
        }
        if(passwordTextField.text==""){
            passwordTextField.attributedPlaceholder = NSAttributedString(string: "Provide confirm password",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            valid=false
            
        }
        if(confirmPasswordTextField.text==""){
            confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Provide password",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            valid=false
        }
        if(phoneTetField.text==""){
            phoneTetField.attributedPlaceholder = NSAttributedString(string: "Provide phone",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            valid=false
        }else{  
//                print("Invalid Phone Number")
//                phoneTetField.text = ""
//                phoneTetField.attributedPlaceholder = NSAttributedString(string: "Invalid Phone Number",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
//                valid=false

        }
        return valid
    }
    
    //MARK: - PHONE NUMBER LENGTH
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.isEqual(phoneTetField){
            let maxLength = 15
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }else{
            return true
        }
    }
}
