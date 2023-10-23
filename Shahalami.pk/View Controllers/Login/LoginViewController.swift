//
//  LoginViewController.swift
//  Shahalami.pk
//
//  Created by Ahmed on 01/11/2021.
//

import UIKit
import Toast_Swift
import CDAlertView
import MobileBuySDK
import iOSDropDown
import Reachability
import TransitionButton
import LocalAuthentication
import KeychainSwift

class LoginViewController: UIViewController {
    
   
    var userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
    @IBOutlet weak var loginButton: TransitionButton!
    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var emailTextFeild: UITextField!
    @IBOutlet weak var passwordTextFeild: UITextField!
    
    @IBOutlet weak var touchIDBtn: UIButton!
    let iconButtonFirst = UIButton()
    var isShow = true
    var isFromIntro: Bool = true
    private let biometricIDAuth = BiometricIDAuth()
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        setup()
        
        
        
    }
 

    
    @IBAction func loginBtn(_ sender: Any) {
        
        if self.checkFieldEmpty(){
            
            loginUser()
            
        }
    }
    
    
    //MARK: - LOGIN API
    
    func loginUser(){

        if Reachability.isConnectedToNetwork(){
        
                self.loginButton.startAnimation()
                let client = Graph.Client(
                    shopDomain: "onlineshahalmi.myshopify.com",
                    apiKey:     "9bbbc150b170f5ffa56d910da50dbbb7"
                )
                print(client)
                
                let input = Storefront.CustomerAccessTokenCreateInput.create(email: self.emailTextFeild.text!, password: self.passwordTextFeild.text!)
                
                let mutation = Storefront.buildMutation { $0
                        .customerAccessTokenCreate(input: input) { $0
                        .customerAccessToken { $0
                        .accessToken()
                        .expiresAt()
                        }
                        .customerUserErrors{ $0
                        .field()
                        .message()
                        }
                        }
                }
                
            let task = client.mutateGraphWith(mutation) { [self] result, error in
                    
                    if error == nil{
                        
                        if result?.customerAccessTokenCreate?.customerUserErrors == nil || result?.customerAccessTokenCreate?.customerUserErrors.count == 0{
                            
                            let accessToken = result?.customerAccessTokenCreate?.customerAccessToken?.accessToken
                            print(accessToken ?? "Token is nil")
                            guard let token = accessToken else{
                                print("Token is ampty")
                                return
                            }
                            print(token)
                            var userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
                            userInfo?.email = self.emailTextFeild.text!
                            userInfo?.password = self.passwordTextFeild.text!
                            userInfo?.saveCurrentSession(forKey: USER_MODEL)
                            var userSession = UserToken()
                            userSession.access_token = token
                            userSession.saveCurrentSession(forKey: USER_TOKEN_KEY)
                            
                            guard let userName = self.emailTextFeild.text,
                                  let password = self.passwordTextFeild.text else { return }
                            let keychain = KeychainSwift()
                            keychain.accessGroup = "6A43FQN32M.com.exdnow.Shahalami.pk"
                            keychain.set(userName, forKey: "userName")
                            keychain.set(password, forKey: "password")
                            
                            DispatchQueue.main.async {
                                //GIFHUD.shared.dismiss()
                                self.loginButton.stopAnimation()
                                self.getUserData()
                            }
                        }else{
                            //                    GIFHUD.shared.dismiss()
                            self.loginButton.stopAnimation()
                            if let error = result?.customerAccessTokenCreate?.customerUserErrors[0].message{
                                print(error)
                                showMessage(title: "", message: error)
                            }else{
                                print("Error is nil")
                            }
                        }
                    }else{
                        if let error = error, case .invalidQuery(let reasons) = error {
                            reasons.forEach {
                                showMessage(title: "", message: "Error on \(String(describing: $0.line)):\(String(describing: $0.column)) - \($0.message)")
                            }
                        }
                    }
                }
                task.resume()
            
        }else{
            CommonMethods.doSomething(view: self){
                
            }
        }

    }
    
    func getUserData(){
        
        //        GIFHUD.shared.show()
        //  activityView.startAnimating()
        ServerManager.sharedInstance.getRequest(url: ServerManager.sharedInstance.BASE_URL + "customers/search.json?query=email:\(self.emailTextFeild.text!)", completion: {js in
            print(js)
            self.getDataInfo(json: js)
        })
    }
    
    //MARK: - GET DATA INFO
    
    fileprivate func getDataInfo(json:AnyObject){
        
        if json is [String:Any]{
            
            let json = json as! [String: Any]
            if let customers = json["customers"] as? Array<Any> {
                if customers.count > 0{
                    let customerObject = customers[0] as! [String : Any]
                    print(customerObject)
                    userInfo?.userID = (customerObject["id"] as? Int)
                    userInfo?.name = (customerObject["first_name"] as? String)
                    userInfo?.last_name = (customerObject["last_name"] as? String)
                    userInfo?.email = (customerObject["email"] as? String)
                    userInfo?.phoneNumber = (customerObject["phone"] as? String)
                    userInfo?.state = (customerObject["state"] as? String ?? "")
                    DispatchQueue.main.async {
                        self.userInfo?.password = self.passwordTextFeild.text!
                    }
                    
                    
                    let address = customerObject["default_address"] as? [String : Any]
                    userInfo?.billingAddress?.last_name = address?["last_name"] as? String
                    userInfo?.billingAddress?.address1 = address?["address1"] as? String
                    userInfo?.billingAddress?.addressId = address?["id"] as? Int
                    userInfo?.billingAddress?.city = address?["city"] as? String
                    userInfo?.billingAddress?.zip = address?["zip"] as? String
                    userInfo?.billingAddress?.country = address?["country"] as? String
                    userInfo?.billingAddress?.province = address?["province"] as? String
                    userInfo?.billingAddress?.isDefault = address?["default"] as? Bool
                    
                    userInfo?.saveCurrentSession(forKey: USER_MODEL)
                    DispatchQueue.main.async {
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(identifier: "contentViewController") as! TabBarViewController
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                        
                    }
                }else{
                    DispatchQueue.main.async { [self] in
                    if customers.count < 0{
                        self.showMessage(title: "", message: "User doesn't exist!")
                    }else{
                        self.showMessage(title: "", message: "Something went wrong. Please try again!")
                    }
                    }
                }
            }
        }else{
            DispatchQueue.main.async { [self] in
                //                GIFHUD.shared.dismiss()
                //      self.activityView.stopAnimating()
                let message = json.value(forKey: "message") as! String
                self.showMessage(title: "", message: message)
            }
        }
    }
    
    
    //MARK: - POPUP MESSAGES
    
    func showMessage(title:String,message:String){
          
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true) {

                }
            }))
            self.present(alert, animated: true, completion: nil)
            
        }

    //MARK: - Buttons
    
    @IBAction func fogrgotPasswordBtn(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "forgotVC") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "signupVC") as! SignUpViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
 
    @IBAction func biometricLogin(_ sender: Any) {
        
        biometricIDAuth.canEvaluate { (canEvaluate, _, canEvaluateError) in
                   guard canEvaluate else {
                       self.showMessage(title: "Error", message: "Face ID/Touch ID may not be configured")
                       return
                   }
                   
                   biometricIDAuth.evaluate { [weak self] (success, error) in
                       guard success else {
                           self?.showMessage(title: "Error", message: error?.localizedDescription ?? "Face ID/Touch ID may not be configured")

                           return
                       }
                   //   self!.showErrorMessage(message: "ID Verified")
                       let keychain = KeychainSwift()
                           keychain.accessGroup = "6A43FQN32M.com.exdnow.Shahalami.pk"
                           if let userName = keychain.get("userName"),
                             let password = keychain.get("password") {
                               self?.emailTextFeild.text = userName
                               self?.passwordTextFeild.text = password
                          
                           }
                       
                       if ((self?.checkFieldEmpty()) != nil){
                           
                           self?.loginUser()
                           
                       }
                       
                       
                   }
               }
        
    }
    
    @IBAction func guestBtn(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "contentViewController") as! TabBarViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func showHideCurrentPassButton(){
        
        if isShow{
            self.passwordTextFeild.textFieldwithImage(direction: .Right, image: UIImage(named: "ic_Hide")!, iconBtn:iconButtonFirst)
            isShow = false
            self.passwordTextFeild.isSecureTextEntry = false
        }else{
            self.passwordTextFeild.textFieldwithImage(direction: .Right, image: UIImage(named: "ic_Show")!,iconBtn:iconButtonFirst)
            isShow = true
            self.passwordTextFeild.isSecureTextEntry = true
        }
    }
    
    
    
    @IBAction func backBtn(_ sender: Any) {
        
        if isFromIntro == false{
        self.dismiss(animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: - VALIDATE TEXTFIELDS
    func checkFieldEmpty()->Bool{
        var valid = true
        
        
        if(emailTextFeild.text==""){
            emailTextFeild.attributedPlaceholder = NSAttributedString(string: "Provied email",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            valid=false
            
        }else{
            if !AppUtility.isValidEmail(testStr: emailTextFeild.text!){
                emailTextFeild.text=""
                emailTextFeild.attributedPlaceholder = NSAttributedString(string: "Email should be valid",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
                valid=false
            }
        }
        if(passwordTextFeild.text==""){
            passwordTextFeild.attributedPlaceholder = NSAttributedString(string: "Provide confirm password",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            valid=false
            
        }
        
        return valid
        
    }
    
    //MARK: - SETUP
    func setup(){
        self.passwordTextFeild.isSecureTextEntry = true
        self.passwordTextFeild.textFieldwithImage(direction: .Right, image: UIImage(named: "ic_Show")!, iconBtn: iconButtonFirst)
        
        iconButtonFirst.addTarget(self, action: #selector(self.showHideCurrentPassButton), for: .touchUpInside)
        AppUtility.bottomBorder(textfeild: emailTextFeild)
        AppUtility.bottomBorder(textfeild: passwordTextFeild)
        
        blueView.layer.cornerRadius = 14
        blueView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
}
