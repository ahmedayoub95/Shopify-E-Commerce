//
//  CheckoutViewController.swift
//  Shahalami.pk
//
//  Created by Ahmed on 26/10/2021.
//

import UIKit
import CDAlertView
import Toast_Swift
import iOSDropDown

class CheckoutViewController: UIViewController {
    
    //variables
    
  
    
    var originalPrice = ""
    var quantity = ""
    var userPhone = ""
    var userEmail = ""
    var isUpdating: Bool = false
    var isUpdated: Bool = false
    var selectedAddress = 0
    var orderID : CLong = 0
    var orderObject: Orders!
    var userOrders: [Orders]! = []
    var userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
    var userToken = AppUtility.sharedInstance.getTokenSession(forKey: USER_TOKEN_KEY)
    var totalPrice:Double = 0
    var subTotal:Double = 0
    var deliveryCharges:Double = 0
    var shippingName = ""
    var discountCode = ""
    var discountType = ""
    var discountValue = "0"
    var isApply : Bool = false
    var isInvalidCode : Bool = false
    var isAlreadyUsed : Bool = false
    var isFirOrder : Bool = false
    // TextField Outlets
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
  
    @IBOutlet weak var phoneTextFeild: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var transparentView: UIView!
   
    
    @IBOutlet weak var animationView: UIImageView!
    //UIView Outlets
    @IBOutlet weak var paymentMethodFirst: UIView!
    @IBOutlet weak var paymentMethodSecond: UIView!
    @IBOutlet weak var paymentMethodThird: UIView!
    
    @IBOutlet weak var discountView: UIView!
    
    @IBOutlet weak var discountTextField: UITextField!
    
    
   // var userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
    let citiesArray = ["Lahore", "Karachi", "Islamabad"]
    let citiesPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.phoneTextFeild.text = "+92"
        setup()
        setUserData()
        getTotalAmount()
//        if userToken != nil{
//        getOrderData()
//        }
        
    }

    
    //MARK: - SETUP
    
    func setup() {
        self.cityTextField.text = "Lahore"
        self.cityTextField.isEnabled = false
        AppUtility.bottomBorder(textfeild: firstNameTextField)
        AppUtility.bottomBorder(textfeild: lastNameTextField)
        AppUtility.bottomBorder(textfeild: phoneTextFeild)
        AppUtility.bottomBorder(textfeild: addressTextField)
        AppUtility.bottomBorder(textfeild: emailTextField)
        AppUtility.bottomBorder(textfeild: cityTextField)
        paymentMethodFirst.addShadow(opacity: 0.4, cornerRadius: 6, shadowRadius: 4.0)
        paymentMethodSecond.addShadow(opacity: 0.4, cornerRadius: 6, shadowRadius: 4.0)
        paymentMethodThird.addShadow(opacity: 0.4, cornerRadius: 6, shadowRadius: 4.0)
        
    }
    
  
    @IBAction func placeOrderBtn(_ sender: Any) {
        
      
        if checkFiledEmpty(){
          //  hideKeyboard()
            if !isUpdating{
                if userToken == nil{
                    userEmail = self.emailTextField.text!
                    self.getUserData(query: "email:\(self.emailTextField.text ?? "")")
                }else{
                    updateUserData()
                }
            }else{
                self.getUserData(query: "email:\(userEmail)")
            }
        }
        
      
    }
    
    
    //MARK: - UPATE USER DATA
    
    func updateUserData(){
        
        userInfo?.billingAddress?.last_name = self.lastNameTextField.text
        userInfo?.billingAddress?.first_name = self.firstNameTextField.text
        userInfo?.billingAddress?.email = self.emailTextField.text
        userInfo?.billingAddress?.phone = self.phoneTextFeild.text
        if selectedAddress == 0 {
            userInfo?.billingAddress?.address1 = self.addressTextField.text
        }
        else {
            userInfo?.billingAddress?.address2 = self.addressTextField.text
        }
        userInfo?.billingAddress?.country = "Pakistan"
        userInfo?.billingAddress?.province = "Punjab"
        userInfo?.billingAddress?.city = self.cityTextField.text
        userInfo?.billingAddress?.zip = "54000"
        userInfo?.saveCurrentSession(forKey: USER_MODEL)
        
        if userInfo?.state == "" || userInfo?.state == "disabled" || userInfo?.state == "declined"{
            userInfo?.name = self.firstNameTextField.text
            userInfo?.email = self.emailTextField.text
            transparentView.isHidden = true
           // activityIndicator.stopAnimating()
            self.showLoginMessage(title: "Alert!", message: "Register to avail discounts in our loyalty program.")
            
        }else if userInfo?.state == "invited"{
            transparentView.isHidden = true
           // activityIndicator.stopAnimating()
            self.showErrorMessage(message: "We have sent an email to you, please click the link included to verify your email address.")
            
        }else if userInfo?.state == "enabled" && userToken == nil{
            transparentView.isHidden = true
           // activityIndicator.stopAnimating()
            self.showLoginMessage(title: "Alert!", message: "Do you want to Login ?")
            
        }else{

            placeOrder()
                
        }
    }
    
    
    //MARK: - PLACE ORDER API
    func placeOrder(){
        
        transparentView.isHidden = false
        DispatchQueue.main.async {
            
            self.animationView.image = UIImage.gif(name: "Shahalami_cart_loader")
        }
        //activityIndicator.startAnimating()
            var address = ""
            if selectedAddress == 0 {
                address = userInfo?.billingAddress?.address1 ?? ""
            }
            else {
                address = userInfo?.billingAddress?.address2 ?? ""
            }
         
            let param = ["line_items":self.setLineItems(),
                         "customer":self.setCustomer(),
                         "phone":userInfo?.billingAddress?.phone! as Any,
                         "billing_address":["address1":address as AnyObject,
                                            "city":userInfo?.billingAddress?.city as AnyObject,
                                            "country":userInfo?.billingAddress?.country as AnyObject,
                                            "first_name":userInfo?.billingAddress?.first_name as AnyObject,
                                            "last_name":userInfo?.billingAddress?.last_name as AnyObject,
                                            "phone":userInfo?.billingAddress?.phone as AnyObject,
                                            "province":userInfo?.billingAddress?.province as AnyObject,
                                            "zip":userInfo?.billingAddress?.zip as AnyObject,
                                            "latitude": userInfo?.billingAddress?.latitude as Any,
                                            "longitude": userInfo?.billingAddress?.longitude as Any],
                         "shipping_address":["address1":address as AnyObject,
                                             "city":userInfo?.billingAddress?.city as AnyObject,
                                             "country":userInfo?.billingAddress?.country as AnyObject,
                                             "first_name":userInfo?.billingAddress?.first_name as AnyObject,
                                             "last_name":userInfo?.billingAddress?.last_name as AnyObject,
                                             "phone":userInfo?.billingAddress?.phone as AnyObject,
                                             "province":userInfo?.billingAddress?.province as AnyObject,
                                             "zip":userInfo?.billingAddress?.zip as AnyObject,
                                             "latitude": userInfo?.billingAddress?.latitude as Any,
                                             "longitude": userInfo?.billingAddress?.longitude as Any],
                         "financial_status":"pending" as AnyObject,
                         "gateway":"Cash on Delivery (COD) - Only for Pakistan",
                         "send_receipt":"true",
                         "note":"SENT FROM iOS MOBILE APP",
                         "shipping_lines":[
                            ["price":"\(deliveryCharges)",
                             "title":shippingName]],
                         "discount_codes":setDiscount()
            ] as [String:AnyObject]
        
        
            let orderParam =  ["order":param] as [String:AnyObject]
            print(orderParam)
            //let data = json(from: orderParam)
            
            //        GIFHUD.shared.show()
      //  activityIndicator.startAnimating()
            let url = "https://onlineshahalmi.myshopify.com/admin/api/2021-04/orders.json"
            ServerManager.sharedInstance.postRequest(param: orderParam, url: url,fnToken:"", completion: {js,token in
                print(js)
                self.userInfo?.lineItems = [Item()]
                self.userInfo?.lineItems?.removeAll()
                self.userInfo!.saveCurrentSession(forKey: USER_MODEL)
                let addressParams = ["address":["id":self.userInfo?.billingAddress?.addressId as Any,"default":true]]
                DispatchQueue.main.async { [self] in
                self.addBadgeCounter()
                }
                ServerManager.sharedInstance.putRequest(param: addressParams, url: ServerManager.sharedInstance.BASE_URL + "customers/\(self.userInfo!.userID)/addresses/\(self.userInfo?.billingAddress?.addressId ?? 0).json", completion: { [self] js in
                    print(js)
                    DispatchQueue.main.async {
                    self.transparentView.isHidden = true
                   // self.activityIndicator.stopAnimating()
                    }
                })
                self.getData(json: js)
                
            })
        }
    
   

    fileprivate func getData(json:AnyObject){
        
        if json is [String:Any]{
            
            
            let decoder = JSONDecoder()
            
            do {
                let json = json as! [String: Any]
                let orderData : Data = try JSONSerialization.data(withJSONObject: json as Any, options: [])
                let orderModel = try decoder.decode(OrderResponse.self, from: orderData)
             //   if let order = orderModel.order {
                orderObject = orderModel.order
               
                if let order = json["order"] as? [String:Any] {
                    orderID = (order["order_number"] as! CLong)
                }
              
                DispatchQueue.main.async { [self] in
                    let cv = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConfirmationVC") as! ConfirmationViewController
                    cv.userOrders = orderObject
                    cv.shippingCharges = deliveryCharges
                    cv.subTotal = subTotal
                    cv.totalAmount = totalPrice
                   // self.performSegue(withIdentifier: "ConfirmationVC", sender: self)
                        self.navigationController?.pushViewController(cv, animated: true)
                    }
              
            } catch let error {
                
                print(error)
                DispatchQueue.main.async {
                    //                    GIFHUD.shared.dismiss()
                 //   self.activityIndicator.stopAnimating()
                }
                let message = json.value(forKey: "message") as! String
                self.showErrorMessage(message: message)
            }

            
        }else{
            DispatchQueue.main.async {
                //                GIFHUD.shared.dismiss()
             //   self.activityView.stopAnimating()
                let message = json.value(forKey: "message") as! String
                self.showErrorMessage(message: message)
            }
        }
    }
    
    // MARK: - ADD BADGE COUNTER
    var badgeCount = UILabel(frame: CGRect(x: 22, y: -05, width: 20, height: 20))
    func addBadgeCounter() {
        let userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)

        badgeCount.layer.borderColor = UIColor.clear.cgColor
        badgeCount.layer.borderWidth = 2
        badgeCount.layer.cornerRadius = badgeCount.bounds.size.height / 2
        badgeCount.textAlignment = .center
        badgeCount.layer.masksToBounds = true
        badgeCount.textColor = .white
        badgeCount.font = badgeCount.font.withSize(12)
        badgeCount.backgroundColor = #colorLiteral(red: 0.06612512469, green: 0.4526025057, blue: 0.7391296029, alpha: 1)
        if userInfo?.lineItems?.count == 1 {
            if userInfo?.lineItems![0].title == "" || userInfo?.lineItems![0].title == nil {
                badgeCount.text = "0"
                badgeCount.isHidden = true
            } else {
                badgeCount.text = "\(userInfo!.lineItems!.count)"
                if let tabItems = tabBarController?.tabBar.items {
                    // In this case we want tomodify the badge number of the third tab:
                    let tabItem = tabItems[2]
                    tabItem.badgeValue = badgeCount.text
                }
                badgeCount.isHidden = false
            }
        } else if (userInfo?.lineItems!.count)! > 1 {
            badgeCount.text = "\(userInfo!.lineItems!.count)"
            if let tabItems = tabBarController?.tabBar.items {
                // In this case we want tomodify the badge number of the third tab:
                let tabItem = tabItems[2]
                tabItem.badgeColor = #colorLiteral(red: 0.06612512469, green: 0.4526025057, blue: 0.7391296029, alpha: 1)
                tabItem.badgeValue = badgeCount.text
            }
            badgeCount.isHidden = false
        } else {
            if let tabItems = tabBarController?.tabBar.items {
                // In this case we want tomodify the badge number of the third tab:
                let tabItem = tabItems[2]
                tabItem.badgeColor = #colorLiteral(red: 0.06612512469, green: 0.4526025057, blue: 0.7391296029, alpha: 1)
                tabItem.badgeValue = nil
            }
            badgeCount.isHidden = true
        }
    }
    
    
    
    
    //MARK: - GET ORDERS
    
    
    func getOrderData(){
       // self.transparentView.isHidden = false
//        DispatchQueue.main.async {
//
//            self.animationView.image = UIImage.gif(name: "Shahalami_cart_loader")
//        }
        //self.loadingView.startAnimating()
        ServerManager.sharedInstance.getRequest(url: ServerManager.sharedInstance.BASE_URL + "customers/\(userInfo!.userID!)/orders.json?financial_status=any&limit=250&status=any", completion: {js in
            print(js)
            self.getOrdesDataForDiscount(json: js)
        })
    }
    
    fileprivate func getOrdesDataForDiscount(json:AnyObject){
        
        if json is [String:Any]{
            
            let decoder = JSONDecoder()
            
            do {
                let json = json as! [String: Any]
                let orderData : Data = try JSONSerialization.data(withJSONObject: json as Any, options: [])
                let orderModel = try decoder.decode(OrdersResponse.self, from: orderData)
                userOrders = orderModel.orders
           
                DispatchQueue.main.async {
       
                }
            } catch let error {
                
                print(error)
         
                let message = json.value(forKey: "message") as! String
                self.showErrorMessage(message: message)
            }
            
        }else{
         
            let message = json.value(forKey: "message") as! String
            self.showErrorMessage(message: message)
        }
    }
    
    
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }

  //  print("\(json(from:array as Any))")
    
//MARK: - GET TOTAL AMOUNT
    
    func getTotalAmount(){
        
        for i in 0..<(userInfo?.lineItems!.count)!{
            let item = userInfo?.lineItems![i]
            subTotal = subTotal + ((item?.price)! * Double((item?.quantity)!))
        }
        
        for i in 0..<(userInfo?.billingAddress?.shipping_rates?.count)!{
            let rate = userInfo?.billingAddress?.shipping_rates![i]
            let price = rate?.price?.toDouble()
            
            if(subTotal >= (rate?.min_order_subtotal?.toDouble() ?? 0.0)){
                if(rate?.max_order_subtotal?.toDouble() != nil){
                    if(subTotal <= (rate?.max_order_subtotal?.toDouble() ?? 0.0)){
                        
                        deliveryCharges = price!
                        shippingName = (rate?.name)! as String
                    }
                }else{
                    deliveryCharges = price!
                    shippingName = (rate?.name)! as String
                }
            }
            
        }
        totalPrice = subTotal + deliveryCharges
    }
 
    
    //MARK: -SET  LINE ITEMS
    
    func setLineItems() -> [[String:AnyObject]]{
        
        var param:[[String:AnyObject]] = []
        for i in 0..<(userInfo?.lineItems?.count ?? 0)!{
            
            let variantID = userInfo?.lineItems![i].variant_id
            let price = userInfo?.lineItems![i].price
            _ = userInfo?.lineItems![i].title
            //"Name":name as Any,
            let prm = ["variant_id":variantID!,"price":price!,"quantity":userInfo?.lineItems![i].quantity as Any] as [String:AnyObject]
           
            param.append(prm)
        }
        return param
    }
    
    //MARK: - SET CUSTOMER DETAILS
    func setCustomer() -> [String:AnyObject]{
        var param:[String:AnyObject]
     //   if userInfo?.userID == 0{
            let prm = ["first_name":userInfo?.billingAddress?.first_name!,
                       "last_name":userInfo?.billingAddress?.last_name!,
                       "email":userInfo?.billingAddress?.email!
            ] as [String:AnyObject]
            param = prm
//        }else{
//            let prm = ["id":userInfo?.userID] as [String:AnyObject]
//            param = prm
//        }
        return param
    }
    
    
    //MARK: - DISCOUNT
    
    @IBAction func discountBtn(_ sender: Any) {
        if userToken != nil{
        AppUtility.bottomBorder(textfeild: discountTextField)
        self.discountTextField.text = ""
        self.discountView.isHidden = false
        }else{
            let alert = UIAlertController(title: "", message: "Login to avail discounts", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
               
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func applyDiscountBtn(_ sender: Any) {
        self.discountCode = discountTextField.text ?? ""
            self.getDiscountData()
    }
    
    
    @IBAction func cancelDiscountBtn(_ sender: Any) {
        
        self.discountView.isHidden = true
    }
    
    
    func getDiscountData(){
        
        self.transparentView.isHidden = false
        DispatchQueue.main.async {
            
            self.animationView.image = UIImage.gif(name: "Shahalami_cart_loader")
        }
        // self.activityIndicator.startAnimating()
        ServerManager.sharedInstance.getRequest(url: ServerManager.sharedInstance.BASE_URL + "price_rules.json", completion: {js in
            print(js)
            self.discountData(json: js)
        })
    }
    
    fileprivate func discountData(json:AnyObject){
        
        if json is [String:Any]{
            
            isAlreadyUsed = false
            let json = json as! [String: Any]
            if let discountCodes = json["price_rules"] as? Array<Any> {
                for i in 0..<discountCodes.count{
                    let codeObj = discountCodes[i] as! [String:Any]
                    let codeString = codeObj["title"] as! String
                    
                    if discountCode.uppercased() == codeString.uppercased(){
                        discountType = codeObj["value_type"] as! String
                        discountValue = codeObj["value"] as! String
                        if let endDate = codeObj["ends_at"] as? String {
                            let dateFormatter = DateFormatter()
                            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                            let date = dateFormatter.date(from:endDate)!
                            let currentDateTime = Date()
                            if currentDateTime > date  {
                                DispatchQueue.main.async {
                                    //self.activityIndicator.stopAnimating()
                                    let alert = UIAlertController(title: "Shahalami.pk", message: "Discount code has been expired!", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                        self.isInvalidCode = true
                                        self.isApply = false
                                        self.transparentView.isHidden = true
                                 //       self.activityIndicator.stopAnimating()
                                    }))
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }
                                return
                            }
                        }
                        discountValue = discountValue.components(separatedBy: "-")[1]
                    }
                }
                if discountValue == "0"{
                    DispatchQueue.main.async {
                        self.invalidCodeAlert()
                    }

                }else{
                    for i in 0..<userOrders.count{
                        for j in 0..<userOrders[i].discount_codes!.count{
                            let discountTitle = userOrders[i].discount_codes![j].code
                            if discountCode.uppercased() == discountTitle?.uppercased(){
                                    self.discountValue  = "0"
                                    self.isInvalidCode = true
                                    self.isAlreadyUsed = true
                                    self.isApply = false
                                DispatchQueue.main.async {
                                    self.view.makeToast("The \(self.discountCode.uppercased()) code has already been used!")
                                    self.transparentView.isHidden = true
                                   // self.activityIndicator.stopAnimating()
                                }
                            }
                        }
                    }
                    
                    if isAlreadyUsed == false {
                        DispatchQueue.main.async {
                            self.view.makeToast("The discount has been applied. Place Your Order")
                            self.isInvalidCode = false
                            self.isApply = true
                            self.transparentView.isHidden = true
                           // self.activityIndicator.stopAnimating()
                            self.discountView.isHidden = true
                        }
                    }
                }
            }
        }else{
            DispatchQueue.main.async {
                //                GIFHUD.shared.dismiss()
                self.transparentView.isHidden = true
              //  self.activityIndicator.stopAnimating()
                let message = json.value(forKey: "message") as! String
                self.showErrorMessage(message: message)
            }
        }
    }
    
    func setDiscount() -> [[String:AnyObject]]{
        
        var param:[[String:AnyObject]] = []
        if isApply{
            let prm = ["code":discountCode.uppercased(),
                       "amount":discountValue,
                       "type":discountType] as [String:AnyObject]
            param.append(prm)
            return param
        }else{
            return param
        }
    }
    
    
    //MARK: - MESSAGES
    
    func invalidCodeAlert()  {
        let alert = UIAlertController(title: "Shahalami.pk", message: "Invalid Discount Code!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.isInvalidCode = true
           self.isApply = false
//            self.tblSummary.reloadData()
            //self.view.makeToast("Invalid Discount Code!")
            self.transparentView.isHidden = true
         //   self.activityIndicator.stopAnimating()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func showLoginMessage(title: String, message: String){
        
        let alert = CDAlertView(title: title, message: message, type: .warning)
        let yesBtn = CDAlertViewAction(title: "Register") { (action) -> Bool in
            self.loginAction()
        }
        if userInfo?.state == "enabled"{
            yesBtn.buttonTitle = "Login"
        }else{
            yesBtn.buttonTitle = "Sign Up"
        }
        alert.add(action: yesBtn)
        
        let noBtn = CDAlertViewAction(title: "Checkout")
        alert.add(action: noBtn)
        alert.isTextFieldHidden = true
        alert.hideAnimations = { (center, transform, alpha) in
            transform = .identity
            alpha = 0
        }
        alert.show() {[self] (alert) in
            
            if self.isLogin{
                self.isLogin = false
                if self.userInfo?.state == "enabled"{
                    DispatchQueue.main.async {
                        let cv=UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInVC") as! LoginViewController
                      //  cv.modalTransitionStyle = .crossDissolve
                        //cv.objAddress = self
                        self.present(cv, animated: true, completion: nil)
                    }
                }else{
                    DispatchQueue.main.async {
                        let cv=UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUp") as! SignUpViewController
                        cv.modalTransitionStyle = .crossDissolve
                       // cv.objAddress = self
                        self.present(cv, animated: true, completion: nil)
                    }
                }
            }else{
                placeOrder()
            }
        }
    }
    
    
    //MARK: - GET USER DATA FROM API
    var isLogin = false
    func loginAction() -> Bool{
        isLogin = true
        return true
    }
    
    var isEmail:Bool = false
    func getUserData(query:String){
        
        //        GIFHUD.shared.show()
    //    activityView.startAnimating()
        ServerManager.sharedInstance.getRequest(url: ServerManager.sharedInstance.BASE_URL + "customers/search.json?query=\(query)", completion: {js in
            print(js)
            self.getResponseData(json: js)
        })
    }
    
    fileprivate func getResponseData(json:AnyObject){
        
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
                    let addresses = customerObject["addresses"] as? [[String : Any]]
                    if addresses!.count > 0{
                        let count = addresses!.count
                        let address = addresses![count-1]
                        userInfo?.billingAddress?.last_name = address["last_name"] as? String
                        userInfo?.billingAddress?.address1 = address["address1"] as? String
                        userInfo?.billingAddress?.city = address["city"] as? String
                        userInfo?.billingAddress?.zip = address["zip"] as? String
                        userInfo?.billingAddress?.country = address["country"] as? String
                        userInfo?.billingAddress?.province = address["province"] as? String
                    }
                    userInfo!.saveCurrentSession(forKey: USER_MODEL)
                    DispatchQueue.main.async {
                        //                GIFHUD.shared.dismiss()
                    //    self.activityView.stopAnimating()
//                        if !self.getUserLocation().isEmpty {
//                            self.userInfo?.billingAddress?.latitude = self.getUserLocation()[0]
//                            self.userInfo?.billingAddress?.longitude = self.getUserLocation()[1]
                            self.userInfo?.saveCurrentSession(forKey: USER_MODEL)
//                        }
                        if self.isUpdating{
                            self.isUpdating = false
                            self.updateUserData()
                        }else{
                            self.updateUserData()
                        }
                    }
                }else{
                    if !isUpdating{
                        DispatchQueue.main.async {
                         //   self.activityView.stopAnimating()
                            if !self.isEmail{
                                self.isEmail = true
                                self.getUserData(query: "email:\(self.userEmail)")
                            }else{
                                self.updateUserData()
                            }
                        }
                    }else{
                        DispatchQueue.main.async {
                          //  self.activityView.stopAnimating()
                            self.isUpdating = true
    //                        self.isUpdated = false
                            self.view.makeToast("Server is updating user! Please wait!")
                        }
                    }
                }
            }
        }else{
            DispatchQueue.main.async {
                //                GIFHUD.shared.dismiss()
              //  self.activityView.stopAnimating()
                let message = json.value(forKey: "message") as! String
                self.showErrorMessage(message: message)
            }
        }
    }
    
    func showErrorMessage(message:String){
        
        let alert = CDAlertView(title: "Alert!", message: message, type: .warning)
        let action = CDAlertViewAction(title: "Okay")
        alert.add(action: action)
        alert.isTextFieldHidden = true
        alert.hideAnimations = { (center, transform, alpha) in
            transform = .identity
            alpha = 0
        }
        alert.show() { (alert) in
            
         //   DispatchQueue.main.async {
              //  let cv=UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SummaryVC") as! SummaryVC
                //            cv.modalTransitionStyle = .crossDissolve
                //        self.present(cv, animated: true, completion: nil)
         //       self.navigationController?.pushViewController(cv, animated: true)
         //   }
        }
    }
    
    
    
    //MARK: - SET USER DATA IN FIELDS
    
    func setUserData(){
        
        if userInfo?.name != ""{
            self.firstNameTextField.text = userInfo?.name ?? userInfo?.billingAddress?.first_name
        }
        
        if userInfo?.billingAddress?.last_name != ""{
            self.lastNameTextField.text = userInfo?.billingAddress?.last_name
        }
        if userInfo?.email != ""{
            self.emailTextField.text = userInfo?.email ?? userInfo?.billingAddress?.email
        }
        if userInfo?.billingAddress?.phone != ""{
            self.phoneTextFeild.text = userInfo?.billingAddress?.phone
        }else{
            if userInfo?.phoneNumber != ""{
                self.phoneTextFeild.text = userInfo?.phoneNumber ?? userInfo?.billingAddress?.phone
            }
        }
        if userInfo?.billingAddress?.address1 != ""{
            self.addressTextField.text = userInfo?.billingAddress?.address1
            self.addressTextField.textColor = UIColor.darkGray
        }
        if userInfo?.billingAddress?.city != ""{
            self.cityTextField.text = userInfo?.billingAddress?.city
        }else{
            self.cityTextField.text = "Lahore"
        }
       
    }
    
    //MARK: - VALIDATIONS
    func checkFiledEmpty()->Bool{
        var valid=true
        
        if(firstNameTextField.text==""){
            firstNameTextField.attributedPlaceholder = NSAttributedString(string: "Provide First Name",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            valid=false
        }
        
        if(lastNameTextField.text==""){
            lastNameTextField.attributedPlaceholder = NSAttributedString(string: "Provide Last Name",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            valid=false
        }
        
        if(phoneTextFeild.text==""){
            phoneTextFeild.attributedPlaceholder = NSAttributedString(string: "Provide Mobile",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            valid=false
        }else{
            
            let str = phoneTextFeild.text
            if str?.hasPrefix("+92") == true{
                if phoneTextFeild.text?.length == 13{
                    
                }else{
                    phoneTextFeild.text = ""
                    phoneTextFeild.attributedPlaceholder = NSAttributedString(string: "Phone Number can't  exceed limit ",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
                    valid=false
                }
            }else  if str?.hasPrefix("03") == true {
                if phoneTextFeild.text?.length == 11{
                    
                }else{
                    phoneTextFeild.text = ""
                    phoneTextFeild.attributedPlaceholder = NSAttributedString(string: "Phone Number can't  exceed limit ",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
                    valid=false
                }
            }else{
                phoneTextFeild.text = ""
                phoneTextFeild.attributedPlaceholder = NSAttributedString(string: "Wrong number format",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
                valid=false
            }
            
            
//            do {
//                let phoneNumberKit = PhoneNumberKit()
//                let phoneNumber = try phoneNumberKit.parse(txtMobile.text!, withRegion: "PK", ignoreType: true)//try phoneNumberKit.parse(txtMobile.text!)
//                print(phoneNumberKit.format(phoneNumber, toType: .e164))
//                userPhone = phoneNumberKit.format(phoneNumber, toType: .e164)
//            }
//            catch {
//                print("Invalid Phone Number")
//                phoneTextFeild.text = ""
//                phoneTextFeild.attributedPlaceholder = NSAttributedString(string: "Invalid Phone Number",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
//                valid=false
           // }
        }
        
        if(emailTextField.text==""){
            emailTextField.attributedPlaceholder = NSAttributedString(string: "Provide email",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            valid=false
        }else{
            if !(emailTextField.text!.isValidEmail(regex: emailTextField.text!)){
                emailTextField.text=""
                emailTextField.attributedPlaceholder = NSAttributedString(string: "Email should be valid",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
                valid=false
            }
        }
        
        if(addressTextField.text=="" || addressTextField.text=="Address*"){
            addressTextField.text = "Provide Address"
            addressTextField.textColor = .red
            valid=false
        }
        
        if(cityTextField.text==""){
            cityTextField.attributedPlaceholder = NSAttributedString(string: "Provide City",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            valid=false
        }
   
        return valid
    }

}
