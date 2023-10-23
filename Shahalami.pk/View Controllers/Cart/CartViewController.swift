//
//  CartViewController.swift
//  Easy Shopping
//
//  Created by Ahmed Ayub on 21/10/2021.
//

import UIKit
import SDWebImage
import CDAlertView
import Toast_Swift
import CoreLocation

import NVActivityIndicatorView

class CartViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    
    //MARK: - VARIABLES
    
    var userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
    var userToken = AppUtility.sharedInstance.getTokenSession(forKey: USER_TOKEN_KEY)
    let alert = CDAlertView(title: "Network Error", message: "Please connect to the internet", type: .warning)
    
    var collectionList:[Product]?
    var temp : Product?
    var locationManager = CLLocationManager()
    var isUpdating: Bool = false

    var isRelatedProducts : Bool = false
    var totalPriceAfterShipping:Double = 0
    var subTotal:Double = 0
    var deliveryCharges:Double = 0
    var shippingName = ""
    var product_id : String? = ""
    var variantIndex:Int = 0
    var wishlistIDs: [String] = []
    var wishlist_ids: String?
    //MARK: - OUTLETS
    
    
    @IBOutlet weak var proceedLeftConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var proceedRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var proceedButton: UIButton!
    
    @IBOutlet weak var loginbutton: UIButton!
    
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var cartItemTotalLbl: UILabel!
    @IBOutlet weak var deliveryChargesLbl: UILabel!
    @IBOutlet weak var totalAmountLbl: UILabel!
    @IBOutlet weak var buttonsUIView: UIView!
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewConstraints: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var animationView: UIImageView!
    @IBOutlet weak var activityView: NVActivityIndicatorView!
 
    
    @IBOutlet weak var relatedProductsCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if userToken != nil{
            self.loginbutton.isHidden = true
            proceedLeftConstraint.constant = 50
            proceedButton.frame.size.width = 350
            proceedRightConstraint.constant = 50
            
        }else{
            mainScrollView.isHidden = true
            emptyView.isHidden = false
            
        }
        userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
        if (userInfo?.lineItems!.count)! >= 1{
            
            DispatchQueue.main.async {
                self.animationView.isHidden = false
                self.animationView.image = UIImage.gif(name: "Shahalami_cart_loader")
            }
            subTotal = 0
            deliveryCharges = 0
            totalPriceAfterShipping = 0
            addBadgeCounter()
            setTotalAmount()
           // mainScrollView.isHidden = false
            emptyView.isHidden = true
            getCollections()
            
            if userToken != nil {
                self.loginbutton.isHidden = true
                proceedLeftConstraint.constant = 50
                proceedButton.frame.size.width = 350
                proceedRightConstraint.constant = 50
            }else{
                self.loginbutton.isHidden = false
                proceedLeftConstraint.constant = 19
                proceedButton.frame.size.width = 178
                proceedRightConstraint.constant = 217
            }
            
            
        }else{
            mainScrollView.isHidden = true
            emptyView.isHidden = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
    let usertoken = AppUtility.sharedInstance.getUserData(forKey: USER_TOKEN_KEY)
    if usertoken != nil {
        self.getWishlistIDs()
    }
    }
//MARK: - TABLEVIEW FOR CART
    // number of rows in table view
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return userInfo?.lineItems?.count ?? 0
       }
       
       // create a cell for each table view row
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
           // create a new cell if needed or reuse an old onec
           let cell:CartTableViewCell = (self.cartTableView.dequeueReusableCell(withIdentifier: "cartCell") as! CartTableViewCell?)!
 
           cell.selectionStyle = .none
           DispatchQueue.main.async {
               cell.productTitleLbl.text = self.userInfo?.lineItems![indexPath.row].title?.uppercased()
               cell.quantityLbl.text = "\(self.userInfo?.lineItems![indexPath.row].quantity ?? 1)"
               let total = Int(self.userInfo!.lineItems![indexPath.row].price!)
               cell.productPriceLbl.text = "\(self.userInfo?.lineItems![indexPath.row].quantity ?? 1) x \(String(describing: total.withCommas()))"
               cell.productImage.sd_setImage(with: URL(string: (self.userInfo?.lineItems![indexPath.row].image)!), placeholderImage:UIImage(named: "ic_placeholder")){
                   (image, error, cacheType, url) in
                   // your code
                   print(image ?? "")
                   
               }
               cell.quantityLbl.text = "\(self.userInfo?.lineItems![indexPath.row].quantity ?? 0)"
               cell.btndelete.tag = indexPath.row
               cell.btndelete.addTarget(self, action:#selector(self.whichButtonPressed(sender:)), for: .touchUpInside)
               cell.addQuantityBtn.tag = indexPath.row
               cell.addQuantityBtn.addTarget(self, action: #selector(self.add(sender:)), for: .touchUpInside)
               cell.minusQuantityBtn.tag = indexPath.row
               cell.minusQuantityBtn.addTarget(self, action: #selector(self.minus(sender:)), for: .touchUpInside)
           }
     
           return cell
       }
       
       // method to run when table view cell is tapped
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           print("You tapped cell number \(indexPath.row).")
       }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 143
    }
   
    
    //MARK: - REMOVE FROM CART
    @objc func whichButtonPressed(sender: UIButton) {
        print("Removed Item Index: \(sender.tag)")
        
        userInfo?.lineItems?.remove(at: sender.tag)
        userInfo?.saveCurrentSession(forKey: USER_MODEL)
       
       
        if (userInfo?.lineItems!.count)! == 0{
            addBadgeCounter()
            showMessage(message: "You cart is empty.")
        }else{
            cartTableView.reloadData()
            setTotalAmount()
            addBadgeCounter()
        }

    }
    
    
    //MARK: - INCREASE QUANTITY
    
    @objc func add(sender: UIButton) {
        print("Removed Item Index: \(sender.tag)")
        
        DispatchQueue.main.async {
            self.animationView.isHidden = false
            self.animationView.image = UIImage.gif(name: "Shahalami_cart_loader")
        }
        var quantity =  userInfo?.lineItems![sender.tag].quantity
        
        quantity = quantity! + 1
        userInfo?.lineItems![sender.tag].quantity = quantity
        userInfo?.saveCurrentSession(forKey: USER_MODEL)
        setTotalAmount()
        self.view.makeToast("Quantity added to cart")
        cartTableView.reloadData()
        if (userInfo?.lineItems!.count)! == 0{
            addBadgeCounter()
            showMessage(message: "Your cart is empty.")
        }

    }
    
    
    //MARK: - DECREASE QUANTITY
    
    @objc func minus(sender: UIButton) {
        print("Removed Item Index: \(sender.tag)")
        
        var quantity =  userInfo?.lineItems![sender.tag].quantity
        quantity = quantity! - 1
        if quantity! >= 1 {
     
        
    
        userInfo?.lineItems![sender.tag].quantity = quantity
        userInfo?.saveCurrentSession(forKey: USER_MODEL)
        setTotalAmount()
        self.view.makeToast("Quantity deducted from cart")
        cartTableView.reloadData()
        if (userInfo?.lineItems!.count)! == 0{
            addBadgeCounter()
            showMessage(message: "Your cart is empty.")
        }
        }

    }
    // MARK: - UICollectionViewDataSource protocol
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return collectionList!.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
      
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! RelatedProductForCartCollectionViewCell
        
        cell.contentView.uiViewShadow()
        cell.cellView.layer.cornerRadius = 8
        
        let data  = collectionList![indexPath.row]
        cell.productTitle.text = data.title
        let price = Int(data.price!/100)
        cell.productPrice.text = "Rs. \(price.withCommas())"
        
        if (data.media!.count > 0) {
            cell.productImage.sd_setImage(with: URL(string: (data.media![0].preview_image!.src!) ), placeholderImage:UIImage(named: "ic_placeholder")){
                (image, error, cacheType, url) in
                // your code
                if error == nil{
                    cell.productImage.contentMode = .scaleAspectFit
                }else{
                    cell.productImage.contentMode = .scaleAspectFit
                }
                print(image ?? "")
            }
        }
        cell.favoutiteBtn.tag = indexPath.row
        for id in wishlistIDs {
            if id == "\(data.id ?? 0)" {
                cell.favoutiteBtn.isSelected = true
                cell.favoutiteBtn.setImage(UIImage(named: "ic_favourite"), for: .normal)
                break
            }else{
                cell.favoutiteBtn.isSelected = false
                cell.favoutiteBtn.setImage(UIImage(named: "ic_unfavourite"), for: .normal)
            }
        }
        
       
        cell.favoutiteBtn.addTarget(self, action: #selector(addFavourite(sender:)), for: .touchUpInside)
        cell.addToCart.tag = indexPath.row
        cell.addToCart.addTarget(self, action: #selector(addToCartProducts(sender:)), for: .touchUpInside)

            return cell
   
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        DispatchQueue.main.async { [self] in
            let cv = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailsViewController
            cv.modalTransitionStyle = .crossDissolve
            cv.isRelatedProducts = true
            cv.temp = collectionList![indexPath.row]
            print("You selected cell #\(indexPath.row)!")
            self.navigationController?.pushViewController(cv, animated: true)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
//        if(layoutChanged == false){
//            //width:self.view.frame.width * 0.45
//            //self.view.frame.height * 0.3
            return CGSize(width: 188 ,height:267)
//        }else{
//
//            return CGSize(width:self.view.frame.width * 0.95,height:self.view.frame.height * 0.2)
//        }
//
    }
    
    //MARK: - WISHLIST
    
    @objc func addFavourite(sender: UIButton) {
        let usertoken = AppUtility.sharedInstance.getUserData(forKey: USER_TOKEN_KEY)
        if usertoken != nil {
        let section = sender.tag / 100
        let item = sender.tag % 100
        let indexPath = IndexPath(item: item, section: section)
        
        let cell = relatedProductsCollectionView?.cellForItem(at: indexPath) as! RelatedProductForCartCollectionViewCell
            let id = collectionList?[sender.tag].id
        
        if cell.favoutiteBtn.isSelected {
            cell.favoutiteBtn.isSelected = false
            cell.favoutiteBtn.setImage(UIImage(named: "ic_unfavourite"), for: .normal)
            removeWishlistIDs(productID: "\(id!)")
        }else{
            cell.favoutiteBtn.isSelected = true
            cell.favoutiteBtn.setImage(UIImage(named: "ic_favourite"), for: .normal)
            addToWishlist(productID: "\(id ?? 0)")
        }
        }else{
            showMessages(message: "Please login to add to wishlist.")
        }
        
    }
    
    
    
    func addToWishlist(productID: String?) {
        //  activityView.startAnimating()
        let userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
        let param = [
            "user_id": "\(userInfo!.userID ?? 0)" as Any,
            "product_id": productID as Any,
        ] as [String: AnyObject]
        
        if Reachability.isConnectedToNetwork() {
            
            self.addToWishlistNew(params: param)

        } else {
            CommonMethods.doSomething(view: self) {

            }
        }
    }
    
    func removeWishlistIDs(productID: String) {
        // activityView.startAnimating()
        let userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
        let param = [
            "user_id": "\(userInfo!.userID ?? 0)" as Any,
            "product_id": productID,
        ] as [String: Any]
        
        ServerManager.sharedInstance.postRequestNew(param: param, url: ServerManager.sharedInstance.exdURL + "removeUserProduct", fnToken: "") { js, _ in
            self.removeWishlist(json: js)
        }
    }
    
    fileprivate func removeWishlist(json: AnyObject) {
        if json is [String: Any] {
            do {
                let json = json as! [String: Any]
              
                DispatchQueue.main.async { [self] in
                    // self.activityView.stopAnimating()
                    if json["product_ids"]! as! String != "" {
                        self.view.makeToast(AppTheme.sharedInstance.productRemovedFromWishlist)
                        self.getWishlistIDs()
                    } else {
                        self.view.makeToast(json["message"]! as? String)
                    }
                }
                
            } catch let error {
                print(error)
                DispatchQueue.main.async {
                    // self.alert.hide(isPopupAnimated: true)
                }
            }
            
        } else {
            DispatchQueue.main.async {
                //  self.activityView.stopAnimating()
                // self.alert.hide(isPopupAnimated: true)
            }
        }
    }
    
    
    
    func addToWishlistNew(params: [String: Any]) {
        
        WebApi.manager.addtoWishlistNew(params: params as [String: Any]) { resp in
            switch resp {
            case let .success(resp):
                print(resp)

                if resp.isSuccessfull == true {
                self.view.makeToast(AppTheme.sharedInstance.productAddedToWishlist)
                    self.getWishlistIDs()
                }else{
                    self.view.makeToast(AppTheme.sharedInstance.errorMessage)
                }

            case let .failure(error):
                print(error)

                self.view.makeToast(AppTheme.sharedInstance.errorMessage)
            }
        }
    }
    
    
    func getWishlistIDs()
    {
        if(Reachability.isConnectedToNetwork()){
            let userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
            let param = [
                "user_id": "\(userInfo!.userID ?? 0)" as Any,
            ] as [String: AnyObject]
            
            WebApi.manager.fetchWishlist(params: param) { [self] resp in
                switch resp {
                case let .success(resp):
                    print(resp)
                    DispatchQueue.main.async { [self] in
                        wishlist_ids = resp.product_ids
                        wishlistIDs = wishlist_ids!.components(separatedBy: ",")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                            if collectionList != nil{
                                self.relatedProductsCollectionView.delegate = self
                                self.relatedProductsCollectionView.dataSource = self
                                self.relatedProductsCollectionView.reloadData()
                              
                            }
                        }
                        
                    }
                case let .failure(error):
                    print(error)
                    showMessage(message: error.localizedDescription)
                }
            }
        }else{
            CommonMethods.doSomething(view: self){
                self.getWishlistIDs()
            }
        
    }
    }
    func showMessages(message: String) {
       

        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            alert.dismiss(animated: true) {
            }
        }))
        present(alert, animated: true, completion: nil)
    }

    // MARK: - BUTTONS
    
    @IBAction func proceedAnywayBtn(_ sender: Any) {
        
        self.performSegue(withIdentifier: "checkoutVC", sender: self)
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "LoginVC") as! LoginViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
       // self.performSegue(withIdentifier: "LoginVC", sender: self)
        
    }
    
  //MARK: - SETUP
    
    func setup(){
        cartTableView.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "cartCell")
//        buttonsUIView.layer.cornerRadius = 25
//        buttonsUIView.buttonUiViewShadow()
//        buttonsUIView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    //MARK: - TOTAL AMOUNT
    
    func setTotalAmount(){
        resetTableHeight()
    }
    
    //MARK: - BADGE COUNT
    
    
    var badgeCount = UILabel(frame: CGRect(x: 22, y: -05, width: 20, height: 20))
    func addBadgeCounter(){
        
        let userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
        badgeCount.layer.borderColor = UIColor.clear.cgColor
        badgeCount.layer.borderWidth = 2
        badgeCount.layer.cornerRadius = badgeCount.bounds.size.height / 2
        badgeCount.textAlignment = .center
        badgeCount.layer.masksToBounds = true
        badgeCount.textColor = .white
        badgeCount.font = badgeCount.font.withSize(12)
        badgeCount.backgroundColor =  AppTheme.sharedInstance.LBL_Blue
        if (userInfo?.lineItems?.count == 1){
            if userInfo?.lineItems![0].title == "" || userInfo?.lineItems![0].title == nil{
                badgeCount.text = "0"
                badgeCount.isHidden = true
            }else{
                badgeCount.text = "\(userInfo!.lineItems!.count)"
                if let tabItems = tabBarController?.tabBar.items {
                    // In this case we want to modify the badge number of the third tab:
                    let tabItem = tabItems[2]
                    tabItem.badgeValue = badgeCount.text
                }
                badgeCount.isHidden = false
            }
        }else if (userInfo?.lineItems?.count ?? 0) > 1{
            badgeCount.text = "\(userInfo!.lineItems!.count)"
            if let tabItems = tabBarController?.tabBar.items {
                // In this case we want to modify the badge number of the third tab:
                let tabItem = tabItems[2]
                tabItem.badgeValue = badgeCount.text
            }
            badgeCount.isHidden = false
        }else{
            if let tabItems = tabBarController?.tabBar.items {
                // In this case we want to modify the badge number of the third tab:
                let tabItem = tabItems[2]
                tabItem.badgeValue = nil
            }
            badgeCount.isHidden = true
        }
        
       
    }
    
    
    
    
    //MARK: -RESET TABLE VIEW HEIGHT
    
    func resetTableHeight(){
        bottomViewConstraints.constant = 85
        tableViewHeightConstraints.constant = tableViewHeightConstraints.constant - 130
        tableViewHeightConstraints.constant = CGFloat(146 * (userInfo?.lineItems!.count)!)
        scrollViewHeightConstraint.constant = 689 + tableViewHeightConstraints.constant
        print("ScrollView Height: ",scrollViewHeightConstraint.constant)
        cartTableView.dataSource = self
        cartTableView.delegate = self
        cartTableView.reloadData()
        getShippingRates()
    }
    
    
    // MARK: - ADD TO CART
    
    @objc func addToCartProducts(sender: UIButton) {
        let buttonNumber = sender.tag
        setCartData(tagID: sender.tag)
        print(buttonNumber)
    }
    
    func setCartData(tagID:Int?){
        var userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
        let myVarinats = collectionList?[tagID ?? 0].variants
        let objVariant = myVarinats?[variantIndex]
        
        if userInfo?.lineItems?.count == 1{
            
            if userInfo?.lineItems?[0].title == "" || userInfo?.lineItems![0].title == nil{
                userInfo?.lineItems![0].variant_id = Int(collectionList?[tagID ?? 0].variants![0].id ?? 0)
                userInfo?.lineItems![0].id = Int(collectionList?[tagID ?? 0].id ?? 0)
                userInfo?.lineItems![0].quantity = 1
                userInfo?.lineItems![0].title = collectionList?[tagID ?? 0].title
                userInfo?.lineItems![0].image = collectionList?[tagID ?? 0].media![0].preview_image?.src
                let price = (objVariant?.price)!/100
                userInfo?.lineItems![0].price = Double(price)
                userInfo?.lineItems![0].size = collectionList?[tagID ?? 0].title
                userInfo?.currencyCode = "PKR"
                userInfo?.saveCurrentSession(forKey: USER_MODEL)
                addBadgeCounter()
                self.view.makeToast("Product added to cart")
            }else{
                addToCart(tagID:tagID ?? 0)
            }
        }else{
            addToCart(tagID:tagID ?? 0)
        }
        badgeCount.text = "\((userInfo?.lineItems!.count)!)"
        badgeCount.isHidden = false
    }
    
    func addToCart(tagID:Int){
        var userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
        let  myVarinats = collectionList?[tagID].variants!
        let objVariant = myVarinats?[variantIndex]
        for i in 0..<(userInfo?.lineItems!.count)! {
           let qty = 1
            let oldQty = (userInfo?.lineItems![i].quantity)!
            if userInfo?.lineItems![i].variant_id == Int(collectionList?[tagID ].variants![0].id ?? 0){
                userInfo?.lineItems![i].quantity = oldQty + qty
                userInfo?.saveCurrentSession(forKey: USER_MODEL)
                self.view.makeToast(AppTheme.sharedInstance.quantityAdded)
                return
            }
        }
        var product:Item = Item()
        product.variant_id = Int(collectionList?[tagID].variants![0].id ?? 0)
        product.quantity = 1
        product.id = Int(collectionList?[tagID].id ?? 0)
        product.title = collectionList?[tagID].title
        product.image = collectionList?[tagID].media![0].preview_image?.src
        let price = (objVariant?.price)!/100
        product.price = Double(price)
        product.size = collectionList?[tagID].title
        userInfo?.currencyCode = "PKR"
        userInfo?.lineItems?.append(product)
        userInfo?.currencyCode = "PKR"
        userInfo?.saveCurrentSession(forKey: USER_MODEL)
        addBadgeCounter()
       self.view.makeToast(AppTheme.sharedInstance.addToCart)
        self.viewWillAppear(true)
    }
    
    
    
    
    //MARK: - SHIPPING CHARGES
    
    
    func getShippingRates(){

        subTotal = 0
        deliveryCharges = 0
        totalPriceAfterShipping = 0
        
        ServerManager.sharedInstance.getRequest(url: ServerManager.sharedInstance.BASE_URL + "shipping_zones.json", completion: {js in
            print(js)
            self.getData(json: js)
        })
    }
    
    fileprivate func getData(json:AnyObject){
        
        if json is [String:Any]{
            
            let json = json as! [String: Any]
            if let zones = json["shipping_zones"] as? Array<Any> {
                let rateObject = zones[0] as? [String:Any]
                let rates = rateObject!["price_based_shipping_rates"] as? Array<Any>
                userInfo?.billingAddress?.shipping_rates = [Rate()]
                for i in 0..<rates!.count{
                    let rate = rates![i] as? [String:Any]
                    var rateObject:Rate = Rate()
                    rateObject.name = rate!["name"] as? String
                    rateObject.price = rate!["price"] as? String
                    rateObject.min_order_subtotal = rate!["min_order_subtotal"] as? String
                    rateObject.max_order_subtotal = rate!["max_order_subtotal"] as? String
                    if i == 0{
                        userInfo?.billingAddress?.shipping_rates![i] = rateObject
                    }else{
                        userInfo?.billingAddress?.shipping_rates?.append(rateObject)
                    }
                }
                userInfo?.saveCurrentSession(forKey: USER_MODEL)
            }

            DispatchQueue.main.async {
                self.getTotalAmount()
            }
        }else{
            DispatchQueue.main.async {
                let message = json.value(forKey: "message") as! String
                self.showErrorMessage(message: message)
            }
        }
    }
    
    
    //MARK: - GET TOTAL AFTER SHIPPING
    
    func getTotalAmount(){
        
        var counter = 0
        
        while (counter<1){
            for i in 0..<((userInfo?.lineItems!.count)!){
            let item = userInfo?.lineItems![i]
            subTotal = subTotal + ((item?.price)! * Double((item?.quantity)!))
        }
        
        for i in 0..<(userInfo?.billingAddress?.shipping_rates?.count)!{
            let rate = userInfo?.billingAddress?.shipping_rates![i]
            let price = rate?.price?.toDouble()
            if (subTotal >= (rate?.min_order_subtotal?.toDouble() ?? 0.0)) && (subTotal <= (rate?.max_order_subtotal?.toDouble()) ?? 0.0){
                deliveryCharges = price!
                shippingName = (rate?.name)! as String
            }
        }
        self.totalPriceAfterShipping = self.subTotal + self.deliveryCharges
        DispatchQueue.main.async {
            self.cartItemTotalLbl.text = " Cart Items: \((self.userInfo?.lineItems!.count)!)"
            if self.deliveryCharges == 0{
                self.deliveryChargesLbl.text = "Free"
            }else{
                let p = Int(self.deliveryCharges)
                self.deliveryChargesLbl.text = "Rs. \(p.withCommas())"
            }
            
            let total = Int(self.totalPriceAfterShipping)
            self.totalAmountLbl.text = "Total: Rs. \(total.withCommas())"
            DispatchQueue.main.async {
                self.animationView.isHidden = true
            }
        }
            counter = counter + 1
        }
        
        DispatchQueue.main.async {
            
            self.animationView.isHidden = true
        }
        mainScrollView.isHidden = false
    }
    //MARK: - POPUP MESSAGES
    
        func showMessage(message:String){
            mainScrollView.isHidden = true
            emptyView.isHidden = false
            let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true) {
                    self.cartItemTotalLbl.text = "Rs. 0"
                    self.totalAmountLbl.text = "Rs. 0"
                    self.deliveryChargesLbl.text = "Rs. 0"
                }
            }))
            self.present(alert, animated: true, completion: nil)
            
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
        }
    }
    
    
    //MARK: - CALL RELATED PRODUCTS API
    
    
    func getCollections(){

        product_id = "\(userInfo?.lineItems![0].id ?? 0)"
    
        if(Reachability.isConnectedToNetwork()){
                
                print("Reachable via WiFi")


                self.activityView.startAnimating()
                ServerManager.sharedInstance.getRequest(url: ServerManager.sharedInstance.related_products_url + "recommendations/products.json?product_id=\(product_id ?? "")&published_status=published&limit=10", completion: {js in
                    print(js)
                    self.getCollectionData(json: js)
                })

        }else{
            CommonMethods.doSomething(view: self) {
                self.getCollections()
            }
        }
        
    
    }
    
    fileprivate func getCollectionData(json:AnyObject){
        
        if json is [String:Any]{
            
            let decoder = JSONDecoder()
            collectionList = []
            
            do {
                let json = json as! [String: Any]
                let collectionData : Data = try JSONSerialization.data(withJSONObject: json as Any, options: [])
                let collectionModel = try decoder.decode(RecommendedProducts.self, from: collectionData)
                
                for i in 0..<(collectionModel.products?.count ?? 0){
                    let objCollection = collectionModel.products![i]
                    collectionList?.append(objCollection)

                }

                print(collectionList?.count ?? 0)
                DispatchQueue.main.async {
                    self.activityView.stopAnimating()
                    self.alert.hide(isPopupAnimated: true)
                    self.relatedProductsCollectionView.delegate = self
                    self.relatedProductsCollectionView.dataSource = self
                    self.relatedProductsCollectionView.reloadData()
                }
            } catch let error {
                
                print(error)
                DispatchQueue.main.async {
                    self.activityView.stopAnimating()
                    self.alert.hide(isPopupAnimated: true)
                }
                let message = json.value(forKey: "message") as! String
            showMessage(message: message)
            }
            
        }else{
            DispatchQueue.main.async {
                self.activityView.stopAnimating()
                self.alert.hide(isPopupAnimated: true)
            }
            let message = json.value(forKey: "message") as! String
            showMessage(message: message)
        }
    }
    
}
