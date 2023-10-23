//
//  MoreViewController.swift
//  Shahalami.pk
//
//  Created by Ahmed on 23/11/2021.
//

import CDAlertView
import Toast_Swift
import UIKit

class MoreViewController: UIViewController {
    var userToken = AppUtility.sharedInstance.getTokenSession(forKey: USER_TOKEN_KEY)
    var userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
    var objHome: HomeViewController?
   
    @IBOutlet weak var loginLogoutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        if userToken == nil{
            loginLogoutBtn.setTitle("Login", for: .normal)
        }
        
    }

    
    
    
    @IBAction func deleteAccount(_ sender: Any) {
        if userToken == nil{
            self.message(message: "Login PLease!")
        }else{
            self.showAccountDeletionMessage(message: "Do you want to delete your account? Your all data will be deleted.")
        }
    }
    
    
    // MARK: - ABOUT US

    @IBAction func aboutUsBtn(_ sender: Any) {
        performSegue(withIdentifier: "aboutusVC", sender: self)
    }

    // MARK: - PRIVACY & POLICY

    @IBAction func privacyPolicyBtn(_ sender: Any) {
        performSegue(withIdentifier: "privacyPolicyVC", sender: self)
    }

    // MARK: - WISHLIST - 3

    @IBAction func wishListBtn(_ sender: Any) {
       // performSegue(withIdentifier: "wishVC", sender: self)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "wishVC") as! WishlistViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - ORDER IN BULK

    @IBAction func bulkBtn(_ sender: Any) {
        performSegue(withIdentifier: "orderInBulkVC", sender: self)
    }

    // MARK: - RETURN AND EXCHANGE

    @IBAction func returnExchangeBtn(_ sender: Any) {
        performSegue(withIdentifier: "returnExchangeVC", sender: self)
    }

    // MARK: - WHATSAPP

    @IBAction func whatsappBTn(_ sender: Any) {
        let myUrl = "https://api.whatsapp.com/send?phone=+923024055050"
        if let url = URL(string: "\(myUrl)"), !url.absoluteString.isEmpty {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    // MARK: - DAIL UP

    @IBAction func dialBtn(_ sender: Any) {
        if let url = URL(string: "tel://+923024055050"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }

    // MARK: - HELP CENTER

    @IBAction func helpBtn(_ sender: Any) {
        performSegue(withIdentifier: "helpVC", sender: self)
    }

    // MARK: - TERMS AND CONDITIONS

    @IBAction func termsConditionBtn(_ sender: Any) {
        performSegue(withIdentifier: "termsConditionVC", sender: self)
    }

    // MARK: - LOGOUT - 10

    @IBAction func logoutBtn(_ sender: Any) {
        if userToken != nil {
            showLoginMessage(message: "Are you sure you want to logout?")
        } else {
            self.login()
        }
    }
    
    //MARK: - Account Deletion
    
    func delete(){
        
        let userID = userInfo?.userID
        WebApi.deleteUser(urlString: "https://81bd8db741a1816a9382acf54c429ab3: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@onlineshahalmi.myshopify.com/admin/api/2021-10/customers/\(userID ?? 0).json"){ [self] resp in
            switch resp {
            case let .success(resp):
                self.deletionMessage(message: "Account Deleted")
                print(resp)
            case let .failure(error):
                self.message(message: error.localizedDescription)
                print(error)
               
            }
        }
    }
    
    func showAccountDeletionMessage(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            alert.dismiss(animated: true) {
            
                self.delete()
            }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (_: UIAlertAction) in
                print("cancel")

            }))

            present(alert, animated: true, completion: nil)
            
        }

    func deleteAccount(){
        let userID = userInfo?.userID
        ServerManager.sharedInstance.accountDeletion(url: "https://81bd8db741a1816a9382acf54c429ab3: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@onlineshahalmi.myshopify.com/admin/api/2021-10/customers/\(userID ?? 0).json", completion: {js in
            DispatchQueue.main.async {
            print(js)
                if js.count > 0{
                self.deletionMessage(message: "Account Deleted!")
                }else{
                    self.message(message: "Error. Account not be deleted")
                }
            }
           
           
        })
    }
    
 

    // MARK: - LOGOUT

    func showLoginMessage(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            alert.dismiss(animated: true) {
//                self.logoutAction()
//                if self.isYes {
                    DispatchQueue.main.async {
                        if self.userToken != nil {
                            AppUtility.sharedInstance.removeSession(forKey: USER_TOKEN_KEY)
                            AppUtility.sharedInstance.removeValueFromUserDefault(key: USER_MODEL)
                            var userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
                          // var userToken = AppUtility.sharedInstance.getTokenSession(forKey: USER_TOKEN_KEY)
                          
                            userInfo = UserModel()
                            userInfo!.saveCurrentSession(forKey: USER_MODEL)
                        }
                        self.objHome?.addBadgeCounter()
//                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                        let vc = storyboard.instantiateViewController(identifier: "LoginVC") as! LoginViewController
//                        vc.isFromIntro = false
//                        vc.modalPresentationStyle = .fullScreen
//                        self.present(vc, animated: true, completion: nil)
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(identifier: "contentViewController") as! TabBarViewController
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                        self.view.makeToast("Logged out successfully!")
                    }
                }
            //}
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (_: UIAlertAction) in
            print("cancel")

        }))
        present(alert, animated: true, completion: nil)
    }



    func login() {

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "LoginVC") as! LoginViewController
            vc.isFromIntro = false
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)

    }
    
    //MARK: - Message
    
    func message(message:String){
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            alert.dismiss(animated: true) {
            
               
            }
            }))
            
        self.present(alert, animated: true, completion: nil)
    }
    func deletionMessage(message:String){
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            alert.dismiss(animated: true) {
            
                if self.userToken != nil {
                    AppUtility.sharedInstance.removeSession(forKey: USER_TOKEN_KEY)
                    AppUtility.sharedInstance.removeValueFromUserDefault(key: USER_MODEL)
                    var userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
                  // var userToken = AppUtility.sharedInstance.getTokenSession(forKey: USER_TOKEN_KEY)
                  
                    userInfo = UserModel()
                    userInfo!.saveCurrentSession(forKey: USER_MODEL)
                }
                self.objHome?.addBadgeCounter()
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "contentViewController") as! TabBarViewController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
            }))
            
        self.present(alert, animated: true, completion: nil)
    }
}
