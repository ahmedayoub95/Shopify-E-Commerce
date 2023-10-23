//
//  ProfileViewController.swift
//  Shahalami.pk
//
//  Created by Ahmed on 29/10/2021.
//

import UIKit
import CDAlertView
import ViewAnimator
import Reachability
import Toast_Swift
import NVActivityIndicatorView
@available(iOS 13.0, *)
class ProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {
    
   
    //VARIABLES
    var userOrders: [Orders]! = []
    var reachability = try! Reachability()
    var userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
    var userToken = AppUtility.sharedInstance.getTokenSession(forKey: USER_TOKEN_KEY)

    // OUTLETS
    @IBOutlet weak var noOrderView: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var accountDetailsView: UIView!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var phoneTextFeild: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextView!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var orderHistoryTableView: UITableView!
    
    @IBOutlet weak var transparentView: UIView!
    
    @IBOutlet weak var animationView: UIImageView!

    @IBOutlet weak var segmentedControlButton: UISegmentedControl!
   
    @IBOutlet weak var guestView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
        orderHistoryTableView.register(UINib(nibName: "OrderHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "orderHistoryCell")
        addressTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        
        if userToken == nil{
            self.guestView.isHidden = false
            self.transparentView.isHidden  = true
          //  showMessage(message: "Please Login for Order History")
            self.noOrderView.isHidden = false
            self.orderHistoryTableView.isHidden = true
        }else{
            getOrderData()
            self.guestView.isHidden = true
            self.noOrderView.isHidden = true
            self.orderHistoryTableView.isHidden = false
        }
    }

    
   
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return userOrders.count
       }
       
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
       
        let cell:OrderHistoryTableViewCell = (self.orderHistoryTableView.dequeueReusableCell(withIdentifier: "orderHistoryCell") as! OrderHistoryTableViewCell?)!
           cell.cellView.addShadow(opacity: 0.4, cornerRadius: 6, shadowRadius: 4.0)
           let data = userOrders![indexPath.row]
           
           cell.orderNumberLbl.text = "#\(data.order_number ?? 0)"
           cell.paymentStatusLbl.text = data.financial_status
           var price = data.total_price
           if let dotRange = price!.range(of: ".") {
               price!.removeSubrange(dotRange.lowerBound..<price!.endIndex)
           }
           let amount = Int(price ?? "")
           cell.totalAmountLbl.text = "PKR \(amount?.withCommas() ?? "")"
           
           return cell
       }
       
     
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
        DispatchQueue.main.async {
           let cv = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "orderHistoryDetailsVC") as! OrderHistoryDetailsViewController
               cv.userOrders = self.userOrders![indexPath.row]
           print("You selected cell #\(indexPath.row)!")
          
         self.navigationController?.pushViewController(cv, animated: true)
           }
           
           print("You tapped cell number \(indexPath.row).")

       }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 146
    }

    @IBAction func segementControlBtn(_ sender: Any) {
        
        segmentedControlButton.changeUnderlinePosition()
        
        if( segmentedControlButton.selectedSegmentIndex == 0){
            accountDetailsView.isHidden = true
            orderHistoryTableView.isHidden = false
        }else{
            if userInfo?.name != ""{
            emailTextField.text = userInfo?.email
            firstNameTextField.text = userInfo?.name
            phoneTextFeild.text = userInfo?.phoneNumber
            lastNameTextField.text = userInfo?.last_name
            cityTextField.text = userInfo?.billingAddress?.city
            addressTextField.text = userInfo?.billingAddress?.address1
            }else{
                phoneTextFeild.text = "+92"
                cityTextField.text = "Lahore"
            }

            accountDetailsView.isHidden = false
            orderHistoryTableView.isHidden = true
        }
    }

    
    func setup() {
      
        
        segmentedControlButton.tintColor = .clear
        segmentedControlButton.backgroundColor = .clear
        segmentedControlButton.addUnderlineForSelectedSegment()

        AppUtility.bottomBorder(textfeild: cityTextField)
        AppUtility.bottomBorder(textfeild: phoneTextFeild)
        AppUtility.bottomBorder(textfeild: emailTextField)
        AppUtility.bottomBorder(textfeild: lastNameTextField)
        AppUtility.bottomBorder(textfeild: firstNameTextField)
        
        addressTextField.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        addressTextField.layer.borderWidth = 0.5
        addressTextField.layer.cornerRadius = 5.0

    
        cityTextField.isEnabled = false
        phoneTextFeild.isEnabled = false
        emailTextField.isEnabled = false
        lastNameTextField.isEnabled = false
        addressTextField.isEditable = false
        firstNameTextField.isEnabled = false
     
    }
    
    @IBAction func resetPasswordBtn(_ sender: Any) {
        
        self.performSegue(withIdentifier: "resetVC", sender: self)
    }
    
    //MARK: - EDIT TEXTFIELDS BUTTON
    @IBAction func editBtn(_ sender: Any) {
        
        editButton.isHidden = true
        saveButton.isHidden = false
        cancelButton.isHidden = false
        phoneTextFeild.isEnabled = true
        emailTextField.isEnabled = true
        lastNameTextField.isEnabled = true
        addressTextField.isEditable = true
        firstNameTextField.isEnabled = true
      
        
    }
    
    //MARK: - SAVE DETAILS BUTTON
    @IBAction func saveBtn(_ sender: Any) {
     
        
        if (userToken != nil){
            if checkFieldEmpty(){

                let params = [
                        "customer_id": userInfo?.userID as Any,
                        "zip": "54000",
                        "country": "Pakistan",
                        "province": "Punjab",
                        "city": "Lahore",
                        "address1": "\(self.addressTextField.text!)" as Any,
                        "first_name": "\(self.firstNameTextField.text!)" as Any,
                        "last_name": "\(self.lastNameTextField.text!)" as Any,
                        "company": "null",
                        "phone": "\(self.phoneTextFeild.text ?? "")" as Any,
                        "id": "\(userInfo?.billingAddress?.addressId ?? 0)" as Any,
                        "name": "\(userInfo?.name ?? "")" as Any,
                        "province_code": "PK",
                        "country_code": "PK",
                        "country_name": "Pakistan",
                        "default": true
                    ]as [String : Any]

                let addressData =  ["customer_address":params] as [String:AnyObject]
                print(addressData)

                ServerManager.sharedInstance.putRequest(param: addressData, url: ServerManager.sharedInstance.BASE_URL + "customers/\(userInfo!.userID!)/addresses/\(userInfo?.billingAddress?.addressId ?? 0).json?") { JSON in
                     print(JSON)
                    
                self.setUserAddress(json: JSON)
                    
                }
            }
                
        }else{
        
//
//        if checkFieldEmpty(){
//
//            let address1 = self.addressTextField.text!
//            let firstName = self.firstNameTextField.text!
//            let lastName = self.lastNameTextField.text!
//            let phone = self.phoneTextFeild.text!
//
//            ServerManager.sharedInstance.getRequest(url: "https://onlineshahalmi.myshopify.com/admin/api/2021-10/customers/5973314207957/addresses.json?address1=\(address1)&address2=&city=Lahore&first_name=\(firstName)&last_name=\(lastName)&phone=\(phone)&province=Punjab&country=Pakistan&zip=54000&province_code=PK&country_code=PK&country_name=Pakistan", completion: {js in
//                print(js)
//
//                self.getUserData(json: js)
//            })
//        }
            
        }

        
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "LoginVC") as! LoginViewController
        vc.isFromIntro = false
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func signupBtn(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "signupVC") as! SignUpViewController
        vc.isFromIntro = false
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    //MARK: - CANCEL BUTTON
    
    @IBAction func cancelBtn(_ sender: Any) {
        editButton.isHidden = false
        saveButton.isHidden = true
        cancelButton.isHidden = true
        phoneTextFeild.isEnabled = false
        emailTextField.isEnabled = false
        lastNameTextField.isEnabled = false
        addressTextField.isEditable = false
        firstNameTextField.isEnabled = false
      
    }
    
    
    //MARK: - SET USER ADDRESS
    fileprivate func setUserAddress(json:AnyObject){
        
        if json is [String:Any]{
            
            let json = json as! [String: Any]
            if let customers = json["customer_address"] {
                if (customers as AnyObject).count > 0{
                    let address = customers as! [String : Any]
                    print(address)
                    DispatchQueue.main.async { [self] in
                        self.userInfo?.email = self.emailTextField.text
                        self.userInfo?.billingAddress?.last_name = address["last_name"] as? String
                        self.userInfo?.billingAddress?.address1 = address["address1"] as? String
                        self.userInfo?.billingAddress?.address2 = address["address2"] as? String
                        self.userInfo?.billingAddress?.addressId = address["id"] as? Int
                        self.userInfo?.billingAddress?.city = address["city"] as? String
                        self.userInfo?.billingAddress?.zip = address["zip"] as? String
                        self.userInfo?.billingAddress?.country = address["country"] as? String
                        self.userInfo?.billingAddress?.province = address["province"] as? String
                        self.userInfo?.billingAddress?.isDefault = address["default"] as? Bool
                    
                        self.userInfo?.saveCurrentSession(forKey: USER_MODEL)
                    }
                    
                    DispatchQueue.main.async { [self] in
                        cancelButton.isHidden = true
                    saveButton.isHidden = true
                    editButton.isHidden = false
                    cityTextField.isEnabled = false
                    phoneTextFeild.isEnabled = false
                    emailTextField.isEnabled = false
                    lastNameTextField.isEnabled = false
                    addressTextField.isEditable = false
                    firstNameTextField.isEnabled = false

                
                    var style = ToastStyle()

                    // this is just one of many style options
                    style.messageColor = .blue
                    self.view.makeToast("User Details Updated successfully.")
                    }
                    

                }else{
                    DispatchQueue.main.async {
                        self.showErrorMessage(message: "Server is updating user! Please wait!")
                    }
                }
            }
        }else{
            DispatchQueue.main.async {
                let message = json.value(forKey: "message") as! String
                self.showErrorMessage(message: message)
            }
        }
    }
    
    //MARK: - GET USER ADDRESS
    
    fileprivate func getUserData(json:AnyObject){
        
        if json is [String:Any]{
            
            let json = json as! [String: Any]
            if let customers = json["addresses"] as? Array<Any> {
                if customers.count > 0{
                    let address = customers[0] as! [String : Any]
                    print(address)
                   
                    userInfo?.email = emailTextField.text
                    userInfo?.billingAddress?.last_name = address["last_name"] as? String
                    userInfo?.billingAddress?.address1 = address["address1"] as? String
                    userInfo?.billingAddress?.address2 = address["address2"] as? String
                    userInfo?.billingAddress?.addressId = address["id"] as? Int
                    userInfo?.billingAddress?.city = address["city"] as? String
                    userInfo?.billingAddress?.zip = address["zip"] as? String
                    userInfo?.billingAddress?.country = address["country"] as? String
                    userInfo?.billingAddress?.province = address["province"] as? String
                    userInfo?.billingAddress?.isDefault = address["default"] as? Bool
                    
                    userInfo?.saveCurrentSession(forKey: USER_MODEL)
                    DispatchQueue.main.async { [self] in
                    saveButton.isHidden = true
                    editButton.isHidden = false
                    cityTextField.isEnabled = false
                    phoneTextFeild.isEnabled = false
                    emailTextField.isEnabled = false
                    lastNameTextField.isEnabled = false
                    addressTextField.isEditable = false
                    firstNameTextField.isEnabled = false
                  
                
                    }
                    var style = ToastStyle()

                    // this is just one of many style options
                    style.messageColor = .blue
                    self.view.makeToast("User Details Updated successfully.")

                }else{
                    DispatchQueue.main.async {
                        self.showErrorMessage(message: "Server is updating user! Please wait!")
                    }
                }
            }
        }else{
            DispatchQueue.main.async {
                let message = json.value(forKey: "message") as! String
                self.showErrorMessage(message: message)
            }
        }
    }
    
    //MARK: - VALIDATE TEXTFIELDS
    func checkFieldEmpty()->Bool{
        var valid = true
        
     
        if(emailTextField.text==""){
            emailTextField.attributedPlaceholder = NSAttributedString(string: "Provide email",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            valid=false
            
        }else{
            if !AppUtility.isValidEmail(testStr: emailTextField.text!){
                emailTextField.text=""
                emailTextField.attributedPlaceholder = NSAttributedString(string: "Email should be valid",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
                valid=false
            }
        }
        if(firstNameTextField.text==""){
            firstNameTextField.attributedPlaceholder = NSAttributedString(string: "Provide First Name",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            valid=false
            
        }
        if(lastNameTextField.text==""){
            lastNameTextField.attributedPlaceholder = NSAttributedString(string: "Provide Last Name",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            valid=false
            
        }
        if(phoneTextFeild.text==""){
            phoneTextFeild.attributedPlaceholder = NSAttributedString(string: "Provide Phone Number",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            valid=false
            
        }
        if(cityTextField.text==""){
            cityTextField.attributedPlaceholder = NSAttributedString(string: "Provide City Name",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            valid=false
        }
        if(addressTextField.text==""){
            addressTextField.text = "Provide Address"
            addressTextField.textColor = UIColor.red
            valid=false
            
        }
        
        return valid
        
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        //if textView.textColor == UIColor.red {
         //   textView.text = ""
            textView.textColor = UIColor.black
       // }
    }
    
    //MARK: - GET ORDERS
    
    
    func getOrderData(){
        self.transparentView.isHidden = false
        DispatchQueue.main.async {
            
            self.animationView.image = UIImage.gif(name: "Shahalami_cart_loader")
        }
        //self.loadingView.startAnimating()
        ServerManager.sharedInstance.getRequest(url: ServerManager.sharedInstance.BASE_URL + "customers/\(userInfo?.userID! ?? 0 )/orders.json?financial_status=any&limit=250&status=any", completion: {js in
            print(js)
            self.getData(json: js)
        })
    }
    
    fileprivate func getData(json:AnyObject){
        
        if json is [String:Any]{
            
            let decoder = JSONDecoder()
            
            do {
                let json = json as! [String: Any]
                let orderData : Data = try JSONSerialization.data(withJSONObject: json as Any, options: [])
                let orderModel = try decoder.decode(OrdersResponse.self, from: orderData)
                userOrders = orderModel.orders
           
                DispatchQueue.main.async {
                    self.transparentView.isHidden = true
                    if self.userOrders.count > 0{
                        self.noOrderView.isHidden = true
                        self.orderHistoryTableView.isHidden = false
                        self.orderHistoryTableView.reloadData()
                        let animation = AnimationType.from(direction: .left , offset: 300)
                        UIView.animate(views: self.orderHistoryTableView.visibleCells, animations: [animation])
                    }else{
                        self.noOrderView.isHidden = false
                        self.orderHistoryTableView.isHidden = true
                    }
                }
            } catch let error {
                
                print(error)
                DispatchQueue.main.async {
                    self.transparentView.isHidden = true
                    self.showErrorMessage(message: error.localizedDescription)
                }
//                let message = json.value(forKey: "message") as! String
             
            }
            
        }else{
            DispatchQueue.main.async {
                self.transparentView.isHidden = true
            }
            let message = json.value(forKey: "message") as! String
            self.showErrorMessage(message: message)
        }
    }
    
    
    //MARK: - ERROR MESSAGE
    
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
    
    func showMessage(message:String){
        
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            alert.dismiss(animated: true) {
                
            }
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    //MARK: - GET USER DATA
    
    func getUserData(){
        ServerManager.sharedInstance.getRequest(url: ServerManager.sharedInstance.BASE_URL + "customers/search.json?query=email:\(userInfo!.email!)", completion: {js in
            print(js)
            self.getDataInfo(json: js)
        })
    }
    
    fileprivate func getDataInfo(json:AnyObject){
        
        if json is [String:Any]{
            
            let json = json as! [String: Any]
            if let customers = json["customers"] as? Array<Any> {
                if customers.count > 0{
                    let customerObject = customers[0] as! [String : Any]
                    print(customerObject)
                    userInfo?.userID = (customerObject["id"] as? Int)
                    userInfo?.name = (customerObject["first_name"] as? String)
                    userInfo?.email = (customerObject["email"] as? String)
                    userInfo?.phoneNumber = (customerObject["phone"] as? String)
                    userInfo?.state = (customerObject["state"] as? String ?? "")
                    userInfo!.saveCurrentSession(forKey: USER_MODEL)
                    
                    DispatchQueue.main.async {
                        self.getOrderData()
                    }
                }else{
                    self.showErrorMessage(message: "Server is updating user! Please wait!")
                }
            }
        }else{
            DispatchQueue.main.async {
                let message = json.value(forKey: "message") as! String
                self.showErrorMessage(message: message)
            }
        }
    }

}
