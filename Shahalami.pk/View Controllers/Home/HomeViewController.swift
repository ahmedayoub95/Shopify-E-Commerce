//
//  HomeViewController.swift
//  Easy Shopping
//
//  Created by Ahmed Ayub on 02/08/2021.
//

import CDAlertView
import ImageSlideshow
import NVActivityIndicatorView
import Reachability
import Toast_Swift
import UIKit
import UIView_Shimmer
import ViewAnimator

enum ApiError: Error {
    case invalidResponse
}

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ImageSlideshowDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    // @IBOutlet weak var dummyView: UIView!
    @IBOutlet var imgSlideShow: ImageSlideshow!
    
    // CollectionView Outlets
    
    @IBOutlet var categoryCollectionView: UICollectionView!
    @IBOutlet var shopByBrandcollectionView: UICollectionView!
    @IBOutlet var topSellingCollectionView: UICollectionView!
    @IBOutlet var newArrivalsCollectionView: UICollectionView!
    @IBOutlet var exploreMoreCollectionview: UICollectionView!
    
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var loaderView: UIView!
    
    @IBOutlet var searchUIView: UIView!
    
    @IBOutlet var searchTableview: UITableView!
    
    @IBOutlet var scrollview: UIScrollView!
    private let animations = [AnimationType.vector(CGVector(dx: 0, dy: 30))]
    private let animate = [AnimationType.from(direction: .bottom, offset: 300)]
    var variantIndex:Int = 0
    let alert = CDAlertView(title: "Network Error", message: "Please connect to the internet", type: .warning)
    
    var brandsData : Brands?
    var topProducts = Products()
    var newArrivals = Products()
    var banners = Banners()
    var categoryList = Categories()
    var favouritesArray: [Any?] = []
    var wishlistIDs: [String] = []
    var wishlist_ids: String?
    var retreive: [Any?] = []
    var fav = Pro()
    var shouldAnimate = true
    var localSource: [String]?
    var bannersList = [SDWebImageSource]()
   
    @IBOutlet var arrivalsActivityView: NVActivityIndicatorView!
    @IBOutlet var sellingAnimationView: NVActivityIndicatorView!
    
    var autoCompletePossibilities: [String] = []
    var autoComplete: [String] = []
    var productList : [SearchProducts]?

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollview.isScrollEnabled = false
        
        
        
       // searchUIView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(HomeViewController.handleDismiss)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setup()
        addBadgeCounter()
        getBrands()
        getBanners()
        topSellingsApi()
        newArrivalsApi()
        let usertoken = AppUtility.sharedInstance.getUserData(forKey: USER_TOKEN_KEY)
        if usertoken != nil {
            getWishlistIDs()
        }
        
    }
    
   
//
//    @objc func handleDismiss() {
//        // Dismisses the calendar with fade animation
//        UIView.animate(withDuration: 0.3, animations: {
//            self.searchUIView.alpha = 0.0
//
//        }) { [self] ( finished ) in
//            self.searchUIView.isHidden = true
//            self.productList.products?.removeAll()
//            self.searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingDidBegin)
//
//        }
//    }
    
    
    
    // MARK: - SEARCH METHODS
    
    @objc func textFieldDidChange(textfield: UITextField) {
    
        if textfield.text!.length > 1 {
            // searchTableview.isHidden = false
           

            searchUIView.isHidden = false
        } else {
            // productList?.removeAll()
            // searchTableview.isHidden = true
            searchUIView.isHidden = true
            self.searchTextField.rightView = nil
            searchTextField.withImage(direction: .Right, image: UIImage(named: "searchIcon")!)
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
        
        searchUIView.isHidden = true
        self.searchTextField.text = ""
        self.searchTextField.rightView = nil
        searchTextField.withImage(direction: .Right, image: UIImage(named: "searchIcon")!)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let substring = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        searchAutocompleteEntriesWithSubstring(substring)
        return true
    }
    
    func searchAutocompleteEntriesWithSubstring(_ substring: String) {
        //   autoComplete.removeAll(keepingCapacity: false)
        if substring.length > 1 {
            let myString: NSString! = substring as NSString
            let substringRange: NSRange! = myString.range(of: substring)
            if substringRange.location == 0 {
                // api call
                getProducts(searchTxt: substring)
            }
        } else {
            //   productList?.removeAll()
            //  self.searchTableview.isHidden = true
            searchUIView.isHidden = true
        }
    }
    
//    func getProducts(searchTxt: String) {
//
//
//        if Reachability.isConnectedToNetwork(){
//            ServerManager.sharedInstance.getRequest(url: ServerManager.sharedInstance.searchProductUrl + "q=\(searchTxt.trimmingCharacters(in: .whitespaces))&resources[type]=product".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!, completion: { js in
//                print(js)
//                self.getProductsData(json: js)
//            })
//        }else{
//            CommonMethods.doSomething(view: self){
//
//            }
//        }
//    }
    func getProducts(searchTxt: String) {
    
        if Reachability.isConnectedToNetwork(){
            
            WebApi.dashboard(params: searchTxt) { [self] resp in
                switch resp {
                case let .success(resp):
                    print(resp)
                    productList = resp.resources?.results?.products
                    print(productList?.count ?? 0)
                    DispatchQueue.main.async { [self] in
                        
                        
                        if productList?.count ?? 0 > 0 {
                            self.searchTextField.rightView = nil
                            searchTextField.rightViewMode = .always
                            
                            let mainView = UIView(frame: CGRect(x: 0, y: 60, width: 80, height: 35))
                            mainView.layer.cornerRadius = 5
                          
                            
                            let view = UIButton()
                            view.frame =  CGRect(x: 0, y: 0, width: 70, height: 35)
                            view.setTitle("cancel", for: .normal)
                            view.setTitleColor(UIColor.cancelButton, for: .normal)
                            view.clipsToBounds = true
                            view.layer.cornerRadius = 5
                            
                            view.addTarget(self, action: #selector(self.refresh), for: .touchUpInside)
                            mainView.addSubview(view)
                            searchTextField.rightView = mainView
                            searchTextField.rightViewMode = .always
                            self.searchTableview.delegate = self
                            self.searchTableview.dataSource = self
                            self.searchUIView.isHidden = false
                            self.searchTableview.reloadData()
                            
                        } else {
                            self.searchTableview.delegate = self
                            self.searchTableview.dataSource = self
                            self.searchUIView.isHidden = false
                            self.searchTableview.reloadData()
                        }
                    }
                    
    
                case let .failure(error):
                    print(error)
                    showMessage(message: error.localizedDescription)
                }
            }
 
        }else{
            CommonMethods.doSomething(view: self){
                
            }
        }
    }
 
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if productList?.count ?? 0 > 0 {
            if productList?.count ?? 0 < 4{
                return productList!.count
            }else{
            return 5
            }
        } else {
            return 1
        }
    }
    
    // create a cell for each table view row
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old onec
        let cell = searchTableview.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchCell
        cell.selectionStyle = .none
        searchTableview.separatorStyle = .none
        cell.cellView.addShadow(opacity: 0.4, cornerRadius: 8, shadowRadius: 4.0)
        if productList?.count ?? 0 > 0 {
            
            if indexPath.row == 4 {
                cell.productImage.isHidden = true
                cell.titleLbl.text = "View All"
                cell.titleLbl.font = UIFont.boldSystemFont(ofSize: 17)
                cell.lblWidthConstraint.constant = 8
                cell.titleTopConstraint.constant = 40
                cell.titleBottomConstraint.constant = 40
                cell.priceLbl.isHidden = true
                cell.titleLbl.textAlignment = .center
            } else {
                let data = productList?[indexPath.row]
                cell.titleLbl.text = data?.title
                if data?.image != nil {
                    cell.productImage.sd_setImage(with: URL(string: data?.image ?? ""), placeholderImage: UIImage(named: "ic_placeholder ")) {
                        image, error, _, _ in
                        // your code
                        if error == nil {
                            cell.productImage.contentMode = .scaleAspectFit
                        } else {
                            cell.productImage.contentMode = .scaleAspectFit
                        }
                        print(image ?? "")
                    }
                }
                var price = data?.price
                if let dotRange = price!.range(of: ".") {
                    price!.removeSubrange(dotRange.lowerBound ..< price!.endIndex)
                }
                let p = Int(price ?? "")

                cell.priceLbl.text = "Rs. \(p?.withCommas() ?? "")"
                cell.priceLbl.isHidden = false
                cell.productImage.isHidden = false
                cell.lblWidthConstraint.constant = 104
                cell.titleTopConstraint.constant = 18
                cell.titleBottomConstraint.constant = 48
                //  cell.titleLbl.backgroundColor = UIColor.white
                cell.titleLbl.font = UIFont.systemFont(ofSize: 14)
                searchTableview.frame = CGRect(x: 14, y: 0, width: searchTableview.frame.size.width, height: 390)
            }
            
        } else {
            cell.productImage.isHidden = true
            cell.titleLbl.text = "Sorry no results"
            cell.lblWidthConstraint.constant = 8
            cell.titleTopConstraint.constant = 25
            cell.titleBottomConstraint.constant = 40
            cell.priceLbl.isHidden = true
           cell.titleLbl.textAlignment = .center
            // cell.titleLbl.backgroundColor = UIColor.lightGray
            searchTableview.frame = CGRect(x: 14, y: 0, width: searchTableview.frame.size.width, height: 200)
        }
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
        if productList?.count ?? 0 > 0 {
            if indexPath.row == 4 {
                DispatchQueue.main.async { [self] in
                    let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "viewAllVC") as! ViewAllProductsViewController
                    cv.searchProducts = productList
                    cv.searchResults = true
                    cv.navigationItem.title = "Search Results"
                    self.navigationController?.pushViewController(cv, animated: true)
                }
                
            } else {
                DispatchQueue.main.async { [self] in
                    let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailsViewController
                    // cv.productDetails = productDetails.products![indexPath.row]
                    cv.searchDirectFromHome = true
                    // cv.isSearchedProduct = true
                    cv.product_id = (productList?[indexPath.row].id!)!
                    print("You selected cell #\(indexPath.row)!")
                    self.navigationController?.pushViewController(cv, animated: true)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return categoryList.data!.count
        } else if collectionView == shopByBrandcollectionView {
            return 16
        } else if collectionView == topSellingCollectionView {
            return 10
        } else { // if(collectionView == newArrivalsCollectionView)
            return 10
        }
    }
    
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        
        if collectionView == categoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath as IndexPath) as! CategoryCollectionViewCell
            
            for i in 0 ..< (categoryList.data![indexPath.row].attributes?.images!.count)! {
                let imageName = categoryList.data![indexPath.row].attributes?.images![i].src
                if imageName != nil {
                    cell.categoryImageView.sd_setImage(with: URL(string: imageName ?? ""), placeholderImage: UIImage(named: "ic_placeholder-1")) {
                        image, error, _, _ in
                        // your code
                        if error == nil {
                            cell.categoryImageView.contentMode = .scaleAspectFill
                        } else {
                            cell.categoryImageView.contentMode = .scaleAspectFit
                        }
                        print(image ?? "")
                    }
                }
            }
            
            cell.categoryImageView.layer.cornerRadius = 8
            return cell
            
        } else
        if collectionView == shopByBrandcollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shopByBrandCell", for: indexPath as IndexPath) as! ShopByBrandCollectionViewCell
            
            cell.cellView.addShadow(opacity: 0.4, cornerRadius: 6, shadowRadius: 4.0)
            
            let data = brandsData?.data?[indexPath.row]
            let image_url = data?.image
            
            if  image_url != nil {
                cell.brandImageView.sd_setImage(with: URL(string: image_url ?? ""), placeholderImage: UIImage(named: "ic_placeholder")) {
                    image, error, _, _ in
                    // your code
                    if error == nil {
                        cell.brandImageView.contentMode = .scaleAspectFill
                    } else {
                        cell.brandImageView.contentMode = .scaleAspectFit
                    }
                    print(image ?? "")
                }
            }
            
            return cell
        } else if collectionView == topSellingCollectionView {
            // topSellingCell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topSellingCell", for: indexPath as IndexPath) as! TopSellingCollectionViewCell
            
            cell.cellView.addShadow(opacity: 0.4, cornerRadius: 6, shadowRadius: 4.0)
            
            let data_top = topProducts.products![indexPath.row]
            
            if data_top.image != nil {
                cell.productImages.sd_setImage(with: URL(string: data_top.image!.src ?? ""), placeholderImage: UIImage(named: "ic_placeholder")) {
                    image, error, _, _ in
                    // your code
                    if error == nil {
                        cell.productImages.contentMode = .scaleAspectFill
                    } else {
                        cell.productImages.contentMode = .scaleAspectFit
                    }
                    print(image ?? "")
                }
            }
            
            cell.productNameLbl.text = data_top.title!
            var price = data_top.variants![0].price
            if let dotRange = price!.range(of: ".") {
                price!.removeSubrange(dotRange.lowerBound ..< price!.endIndex)
            }
            let p = Int(price ?? "")

            cell.productPriceLbl.text = "Rs. \(p!.withCommas())"
            cell.unFavButton.tag = indexPath.row
            
            for id in wishlistIDs {
                if id == data_top.id {
                    print(data_top.id as Any," If Wishlist ID:\(id)")
                    cell.unFavButton.isSelected = true
                    cell.unFavButton.setImage(UIImage(named: "ic_favourite"), for: .normal)
                    break
                }else{
                    // cell.favButton.isHidden = true
                    print(data_top.id as Any," else Wishlist ID:\(id)")
                    cell.unFavButton.isSelected = false
                    cell.unFavButton.setImage(UIImage(named: "ic_unfavourite"), for: .normal)
                }
            }
              cell.addToCartButton.tag = indexPath.row
              cell.addToCartButton.addTarget(self, action:#selector(addToCartTopSellings(sender:)), for: .touchUpInside)
            // cell.removeBtn.addTarget(self, action:#selector(removeFromCart(sender:)), for: .touchUpInside)
            
            //  cell.removeBtn.tag = indexPath.row
            
            // FOR FVOURITE
            
            cell.unFavButton.addTarget(self, action: #selector(unfavouritePressed(sender:)), for: .touchUpInside)
            
            return cell
            
        } else { // if(collectionView == newArrivalsCollectionView)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newArrivalCell", for: indexPath as IndexPath) as! NewArrivalsCollectionViewCell
            
            cell.cellView.addShadow(opacity: 0.4, cornerRadius: 6, shadowRadius: 4.0)
            
            let data = newArrivals.products![indexPath.row]
            
            if data.image != nil {
                cell.productImages.sd_setImage(with: URL(string: data.image!.src ?? ""), placeholderImage: UIImage(named: "ic_placeholder")) {
                    image, error, _, _ in
                    // your code
                    if error == nil {
                        cell.productImages.contentMode = .scaleAspectFill
                    } else {
                        cell.productImages.contentMode = .scaleAspectFit
                    }
                    print(image ?? "")
                }
            }
            
            cell.productNameLbl.text = data.title!
            var price = data.variants![0].price
            if let dotRange = price!.range(of: ".") {
                price!.removeSubrange(dotRange.lowerBound ..< price!.endIndex)
            }
            //     print("Did dismiss dismiss by \(String(describing: action))"
            let p = Int(price ?? "")
            cell.productPriceLbl.text = "Rs.\(p?.withCommas() ?? "")"
            cell.addToCartButton.addTarget(self, action: #selector(addToCartNewArrivals(sender:)), for: .touchUpInside)
            cell.addToCartButton.tag = indexPath.row
            
            // FOR FAVOURITE
            cell.favouriteButton.tag = indexPath.row
            for id in wishlistIDs {
                if id == data.id {
                    print(data.id as Any," If Wishlist ID:\(id)")
                    cell.favouriteButton.isSelected = true
                    cell.favouriteButton.setImage(UIImage(named: "ic_favourite"), for: .normal)
                    break
                }else{
                    // cell.favButton.isHidden = true
                    print(data.id as Any," else Wishlist ID:\(id)")
                    cell.favouriteButton.isSelected = false
                    cell.favouriteButton.setImage(UIImage(named: "ic_unfavourite"), for: .normal)
                }
            }
            cell.favouriteButton.addTarget(self, action: #selector(unfavouriteNewArrivals(sender:)), for: .touchUpInside)
            // cell.unfavouriteButton.addTarget(self, action: #selector(unfavouriteNewArrivals(sender:)), for: .touchUpInside)
            
            // cell.unfavouriteButton.tag = indexPath.row
            return cell
        }
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        if collectionView == categoryCollectionView {
            DispatchQueue.main.async { [self] in
                let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "viewAllVC") as! ViewAllProductsViewController
                cv.collectionID = categoryList.data![indexPath.row].id
                cv.isProductByCategory = true
                cv.navigationItem.title = categoryList.data![indexPath.row].title
                self.navigationController?.pushViewController(cv, animated: true)
            }
        } else
        if collectionView == topSellingCollectionView {
            DispatchQueue.main.async { [self] in
                let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailsViewController
                cv.productDetails = topProducts.products![indexPath.row]
                
                print("You selected cell #\(indexPath.row)!")
                
                self.navigationController?.pushViewController(cv, animated: true)
            }
        } else if collectionView == newArrivalsCollectionView {
            DispatchQueue.main.async { [self] in
                let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailsViewController
                cv.productDetails = newArrivals.products![indexPath.row]
                
                print("You selected cell #\(indexPath.row)!")
                
                self.navigationController?.pushViewController(cv, animated: true)
            }
        } else if collectionView == shopByBrandcollectionView{
            let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "viewAllBrandsVC") as! AllBrandsProductsViewController
            cv.brandName = brandsData?.data?[indexPath.row].title ?? ""
            cv.navigationItem.title = brandsData?.data?[indexPath.row].title ?? ""
            self.navigationController?.pushViewController(cv, animated: true)
        }
        print("You selected cell #\(indexPath.count)!")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCollectionView {
            return CGSize(width: 185, height: 122)
        } else if collectionView == shopByBrandcollectionView {
            return CGSize(width: view.frame.width * 0.25, height: view.frame.height * 0.15)
        } else if collectionView == topSellingCollectionView {
            return CGSize(width: 150, height: 274)
        } else { // if(collectionView == newArrivalsCollectionView)
            return CGSize(width: 150, height: 274)
        }
    }
    // MARK: - Collection View Data Source

    fileprivate func layoutSetting(_ collection: UICollectionView) {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        // layout.itemSize = CGSize(width: view.frame.width * 0.45, height: view.frame.height * 0.35)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        // layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collection.collectionViewLayout = layout
    }

    
    // MARK: - TOP SELLING
    
    
    @objc func unfavouritePressed(sender: UIButton) {
        let usertoken = AppUtility.sharedInstance.getUserData(forKey: USER_TOKEN_KEY)
        if usertoken != nil {
        let section = sender.tag / 100
        let item = sender.tag % 100
        let indexPath = IndexPath(item: item, section: section)
        
        let cell = topSellingCollectionView?.cellForItem(at: indexPath) as! TopSellingCollectionViewCell
        
        let id = topProducts.products?[sender.tag].id
        
        if cell.unFavButton.isSelected {
            cell.unFavButton.isSelected = false
            cell.unFavButton.setImage(UIImage(named: "ic_unfavourite"), for: .normal)
            removeWishlistIDs(productID: id!)
        }else{
            cell.unFavButton.isSelected = true
            cell.unFavButton.setImage(UIImage(named: "ic_favourite"), for: .normal)
            addToWishlist(productID: id)
        }
        }else{
           showMessages(message: "Please Login to add to wishlist.")
        }
        
        let buttonNumber = sender.tag
        print(buttonNumber)
        //  print(myarray)
    }
    
    // MARK: - FOR NEW ARRIVALS
    
    
    @objc func unfavouriteNewArrivals(sender: UIButton) {
        let usertoken = AppUtility.sharedInstance.getUserData(forKey: USER_TOKEN_KEY)
        if usertoken != nil {
        let section = sender.tag / 100
        let item = sender.tag % 100
        let indexPath = IndexPath(item: item, section: section)
        
        let cell = newArrivalsCollectionView?.cellForItem(at: indexPath) as! NewArrivalsCollectionViewCell
        let id = newArrivals.products?[sender.tag].id
        
        if cell.favouriteButton.isSelected {
            cell.favouriteButton.isSelected = false
            cell.favouriteButton.setImage(UIImage(named: "ic_unfavourite"), for: .normal)
            removeWishlistIDs(productID: id!)
        }else{
            cell.favouriteButton.isSelected = true
            cell.favouriteButton.setImage(UIImage(named: "ic_favourite"), for: .normal)
            addToWishlist(productID: id)
        }
        }else{
            showMessages(message: "Please Login to add to wishlist.")
        }
        
    }
    
    // MARK: - ADD TO CART
    
    @objc func addToCartNewArrivals(sender: UIButton) {
        let buttonNumber = sender.tag
        setCartData(tagID: sender.tag)
        print(buttonNumber)
    }
    
    func setCartData(tagID:Int?){
        var userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
        let myVarinats = newArrivals.products?[tagID ?? 0].variants!
        let objVariant = myVarinats?[variantIndex]
        
        if userInfo?.lineItems?.count == 1{
            
            if userInfo?.lineItems?[0].title == "" || userInfo?.lineItems![0].title == nil{
                userInfo?.lineItems![0].variant_id = Int(newArrivals.products?[tagID ?? 0].variants![0].id ?? "0")
                userInfo?.lineItems![0].id = Int(newArrivals.products?[tagID ?? 0].id ?? "0")
                userInfo?.lineItems![0].quantity = 1
                userInfo?.lineItems![0].title = newArrivals.products?[tagID ?? 0].title
                userInfo?.lineItems![0].image = newArrivals.products?[tagID ?? 0].image?.src
                userInfo?.lineItems![0].price = Double(objVariant?.price ?? "0")
                userInfo?.lineItems![0].size = newArrivals.products?[tagID ?? 0].title
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
        let  myVarinats = newArrivals.products?[tagID].variants!
        let objVariant = myVarinats?[variantIndex]
        for i in 0..<(userInfo?.lineItems!.count)! {
           let qty = 1
            let oldQty = (userInfo?.lineItems![i].quantity)!
            if userInfo?.lineItems![i].variant_id == Int(newArrivals.products?[tagID ].variants![0].id ?? "0"){
                userInfo?.lineItems![i].quantity = oldQty + qty
                userInfo?.saveCurrentSession(forKey: USER_MODEL)
                self.view.makeToast(AppTheme.sharedInstance.quantityAdded)
                return
            }
        }
        var product:Item = Item()
        product.variant_id = Int(newArrivals.products?[tagID ].variants![0].id ?? "0")
        product.quantity = 1
        product.id = Int(newArrivals.products?[tagID].id ?? "0")
        product.title = newArrivals.products?[tagID].title
        product.image = newArrivals.products?[tagID].image?.src
        product.price = Double(objVariant?.price! ?? "0")
        product.size = newArrivals.products?[tagID].title
        userInfo?.currencyCode = "PKR"
        userInfo?.lineItems?.append(product)
        userInfo?.currencyCode = "PKR"
        userInfo?.saveCurrentSession(forKey: USER_MODEL)
        addBadgeCounter()
       self.view.makeToast("Product added to cart")
    }
    
    
    
    @objc func addToCartTopSellings(sender: UIButton) {
        let buttonNumber = sender.tag
        setTopSellingsCartData(tagID: sender.tag)
        print(buttonNumber)
    }
    
    func setTopSellingsCartData(tagID:Int?){
        var userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
        let myVarinats = topProducts.products?[tagID ?? 0].variants!
        let objVariant = myVarinats?[variantIndex]
        
        if userInfo?.lineItems?.count == 1{
            
            if userInfo?.lineItems?[0].title == "" || userInfo?.lineItems![0].title == nil{
                userInfo?.lineItems![0].variant_id = Int(topProducts.products?[tagID ?? 0].variants![0].id ?? "0")
                userInfo?.lineItems![0].id = Int(topProducts.products?[tagID ?? 0].id ?? "0")
                userInfo?.lineItems![0].quantity = 1
                userInfo?.lineItems![0].title = topProducts.products?[tagID ?? 0].title
                userInfo?.lineItems![0].image = topProducts.products?[tagID ?? 0].image?.src
                userInfo?.lineItems![0].price = Double(objVariant?.price ?? "0")
                userInfo?.lineItems![0].size = topProducts.products?[tagID ?? 0].title
                userInfo?.currencyCode = "PKR"
                userInfo?.saveCurrentSession(forKey: USER_MODEL)
                addBadgeCounter()
                self.view.makeToast("Product added to cart")
            }else{
                addToCartTopSellings(tagID:tagID ?? 0)
            }
        }else{
            addToCartTopSellings(tagID:tagID ?? 0)
        }
        badgeCount.text = "\((userInfo?.lineItems!.count)!)"
        badgeCount.isHidden = false
    }
    
    func addToCartTopSellings(tagID:Int){
        var userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
        let  myVarinats = topProducts.products?[tagID].variants!
        let objVariant = myVarinats?[variantIndex]
        for i in 0..<(userInfo?.lineItems!.count)! {
           let qty = 1
            let oldQty = (userInfo?.lineItems![i].quantity)!
            if userInfo?.lineItems![i].variant_id == Int(topProducts.products?[tagID ].variants![0].id ?? "0"){
                userInfo?.lineItems![i].quantity = oldQty + qty
                userInfo?.saveCurrentSession(forKey: USER_MODEL)
                self.view.makeToast(AppTheme.sharedInstance.quantityAdded)
                return
            }
        }
        var product:Item = Item()
        product.variant_id = Int(topProducts.products?[tagID ].variants![0].id ?? "0")
        product.quantity = 1
        product.id = Int(topProducts.products?[tagID].id ?? "0")
        product.title = topProducts.products?[tagID].title
        product.image = topProducts.products?[tagID].image?.src
        product.price = Double(objVariant?.price! ?? "0")
        product.size = topProducts.products?[tagID].title
        userInfo?.currencyCode = "PKR"
        userInfo?.lineItems?.append(product)
        userInfo?.currencyCode = "PKR"
        userInfo?.saveCurrentSession(forKey: USER_MODEL)
        addBadgeCounter()
       self.view.makeToast("Product added to cart")
    }
    
    
    @objc func removeFromCart(sender: UIButton) {
        let section = sender.tag / 100
        let item = sender.tag % 100
      //  let indexPath = IndexPath(item: item, section: section)
        //let cell = topSellingCollectionView?.cellForItem(at: indexPath) as! TopSellingCollectionViewCell
        //  cell.addToCartButton.isHidden = false
        let buttonNumber = sender.tag
        print(buttonNumber)
    }
    
    @IBAction func cartVcBtn(_ sender: Any) {
        tabBarController?.selectedIndex = 2
        // self.performSegue(withIdentifier: "cartVC", sender: self)
    }
    
    
    @IBAction func viewAllBrands(_ sender: Any) {
        let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "allbrandsVC") as! AllBrandsViewController
        cv.brandsData = brandsData
        cv.navigationItem.title = "All Brands"
        self.navigationController?.pushViewController(cv, animated: true)
    }
    
    @IBAction func viewAllTopBtn(_ sender: Any) {
        
            let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "viewAllVC") as! ViewAllProductsViewController
        cv.productDetails = topProducts
            cv.topSellingVC = true
            cv.navigationItem.title = "Top Sellings"
            self.navigationController?.pushViewController(cv, animated: true)
        
    }
    
    @IBAction func viewNewArrivalsBtn(_ sender: Any) {
        DispatchQueue.main.async { [self] in
            let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "viewAllVC") as! ViewAllProductsViewController
            cv.productDetails = newArrivals
            cv.topSellingVC = true
            cv.navigationItem.title = "New Arrivals"
            self.navigationController?.pushViewController(cv, animated: true)
        }
    }
    
    @IBAction func b2bBtn(_ sender: Any) {
        DispatchQueue.main.async { [self] in
            let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "B2BVC") as! B2BViewController
            self.navigationController?.pushViewController(cv, animated: true)
        }
    }
    
    @IBAction func viewAllCategoryBtn(_ sender: Any) {
        tabBarController!.selectedIndex = 1
    }
    
    func setup() {
        // self.setImagesSlideshow()
      //  layoutSetting(shopByBrandcollectionView)
        imgSlideShow.addShadow(opacity: 0.4, cornerRadius: 6, shadowRadius: 4.0)
        // Search Bar TextField
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        searchTextField.placeholder = "  Search"
        searchTextField.withImage(direction: .Right, image: UIImage(named: "searchIcon")!)
        searchTextField.addEmptyView(direction: .Left)
        searchTextField.layer.masksToBounds = true
        searchTextField.borderStyle = .none
        searchTextField.layer.cornerRadius = 14
        
        searchTableview.register(UINib(nibName: "SearchCell", bundle: nil), forCellReuseIdentifier: "searchCell")
        searchTextField.delegate = self
        
        searchTableview.addShadow(opacity: 0.2, cornerRadius: 0, shadowRadius: 0.5, borderColor: UIColor.lightGray.cgColor, borderWith: 1)
        searchTableview.layer.cornerRadius = 6
        searchTableview.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingDidBegin)
        searchTableview.layer.cornerRadius = 14
        searchTableview.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        //        self.getTopSelling()
        getAllCategories()
        
    }
    
    // MARK: - Custom Methods
    
    func setImagesSlideshow() {
        imgSlideShow.slideshowInterval = 2.0
        imgSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFill
//        imgSlideShow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
//
//        let pageIndicator = UIPageControl()
//        pageIndicator.pageIndicatorTintColor = UIColor.black
//        pageIndicator.currentPageIndicatorTintColor = UIColor.gray
//        pageIndicator.backgroundColor = UIColor.clear
//
//        imgSlideShow.delegate = self
//        imgSlideShow.pageIndicator = pageIndicator
//        imgSlideShow.activityIndicator = DefaultActivityIndicator()
        
        imgSlideShow.setImageInputs(bannersList)
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
                self.tabBarController?.tabBar.items![0].badgeColor = .black
                // In this case we want tomodify the badge number of the third tab:
                let tabItem = tabItems[2]
//                tabItem.badgeColor = #colorLiteral(red: 0.06612512469, green: 0.4526025057, blue: 0.7391296029, alpha: 1)
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
    
    
    
    //MARK: - GET BRANDS API
    
    func getBrands() {
        
        if Reachability.isConnectedToNetwork() {
            WebApi.manager.getBrands() { [self] resp in
                switch resp {
                case let .success(resp):
                    print(resp)
                    brandsData = resp
                    shopByBrandcollectionView.delegate = self
                    shopByBrandcollectionView.dataSource = self
                    shopByBrandcollectionView.reloadData()
                case let .failure(error):
                    print(error)
                    showMessage(message: error.localizedDescription)
                }
            }

        }else{
            CommonMethods.doSomething(view: self){
                self.getBrands()
            }
        }
    }
    
    
    // MARK: - GET BANNERS API
    
    func getBanners() {
        if Reachability.isConnectedToNetwork() {
            ServerManager.sharedInstance.getRequest(url: ServerManager.sharedInstance.BASE_URL + "products/7484120989909/images.json", completion: { js in
                // print(js)
                self.getBannersData(json: js)
                
            })
        }else{
            CommonMethods.doSomething(view: self){
                self.getBanners()
                self.getAllCategories()
                self.newArrivalsApi()
                self.topSellingsApi()
                self.getBrands()
                
            }
        }
    }
    
    fileprivate func getBannersData(json: AnyObject) {
        if json is [String: Any] {
            bannersList = []
            
            do {
                // let json = try json as! [String: Any]

                let data = Banners(dictionary: json as! NSDictionary)
                banners = data
                if let bannerImages = banners.images{
                    for i in 0 ..< bannerImages.count {
                        let bannerData = bannerImages[i]
                        bannersList.append(SDWebImageSource(urlString: bannerData.src!)!)
                        print(bannerData.src!)
                    }
                    DispatchQueue.main.async {
                        self.imgSlideShow.stopShimmerAnimation()
                        self.setImagesSlideshow()
                        print("Banners")
                    }
                    
                }
                
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.alert.hide(isPopupAnimated: true)
                }
                let message = json.value(forKey: "message") as! String
                self.showMessage(message: message)
            }
            
        } else {
            DispatchQueue.main.async {
                self.alert.hide(isPopupAnimated: true)
            }
            let message = json.value(forKey: "message") as! String
            self.showMessage(message: message)
        }
    }
    
    // MARK: - NEW ARRIVALS
    
    func topSellingsApi() {
        if Reachability.isConnectedToNetwork() {
            ServerManager.sharedInstance.getRequest(url: ServerManager.sharedInstance.BASE_URL + "products.json?collection_id=270685864119&published_status=published&limit=50", completion: { js in
                //  print(js)
                self.getTopProductsCollection(json: js)
            })
        }else{
            CommonMethods.doSomething(view: self){
                //self.getBanners()
              //  self.getCollections()
                //self.newArrivalsApi()
                self.topSellingsApi()
                //self.getBrands()
            }
        }
    }
    
    func newArrivalsApi() {
      //  arrivalsActivityView.startAnimating()
        if Reachability.isConnectedToNetwork() {
            ServerManager.sharedInstance.getRequest(url: ServerManager.sharedInstance.BASE_URL + "products.json?collection_id=287323095253&published_status=published&limit=50&sort_order=Newest", completion: { js in
                //   print(js)
                self.getNewArrivassCollection(json: js)
            })
        } else {
            CommonMethods.doSomething(view: self) {
//                self.getBanners()
//                self.getCollections()
                self.newArrivalsApi()
//                self.topSellingsApi()
//                self.getBrands()
            }
        }
    }
    
    fileprivate func getNewArrivassCollection(json: AnyObject) {
        if json is [String: Any] {
            do {
                let json = json as! [String: Any]
                let dataString = Products(dictionary: json as NSDictionary)
                newArrivals = dataString
                guard newArrivals.products != nil else {
                    return
                }
                DispatchQueue.main.async { [self] in
                    self.alert.hide(isPopupAnimated: true)
                    self.newArrivalsCollectionView.delegate = self
                    self.newArrivalsCollectionView.dataSource = self
                    self.newArrivalsCollectionView.reloadData()
//                    self.newArrivalsCollectionView?.performBatchUpdates({
//                        UIView.animate(views: self.newArrivalsCollectionView!.orderedVisibleCells,
//                                       animations: self.animate, completion: {
//                        })
//                    }, completion: nil)
                    print("New Arrivals")
                   // self.arrivalsActivityView.stopAnimating()
                    self.scrollview.isScrollEnabled = true
                }
            } catch let error {
                print(error)
                DispatchQueue.main.async {
                    self.alert.hide(isPopupAnimated: true)
                }
            }
            
        } else {
            DispatchQueue.main.async {
                //  self.activityView.stopAnimating()
                self.alert.hide(isPopupAnimated: true)
            }
        }
    }
    
    // MARK: - TOP SELING API
    
    fileprivate func getTopProductsCollection(json: AnyObject) {
        if json is [String: Any] {
            do {
                let json = json as! [String: Any]
                let dataString = Products(dictionary: json as NSDictionary)
                topProducts = dataString
                guard topProducts.products != nil else {
                    return
                }
                DispatchQueue.main.async { [self] in
                    self.alert.hide(isPopupAnimated: true)
                    shouldAnimate = false
                    self.topSellingCollectionView.delegate = self
                    self.topSellingCollectionView.dataSource = self
                    self.topSellingCollectionView.reloadData()
//                    self.topSellingCollectionView?.performBatchUpdates({
//                        UIView.animate(views: self.topSellingCollectionView!.orderedVisibleCells,
//                                       animations: self.animate, completion: {
//                        })
//                    }, completion: nil)
                    print("Top Sellings")
                    
                }
            } catch let error {
                print(error)
                DispatchQueue.main.async {
                    self.alert.hide(isPopupAnimated: true)
                }
            }
            
        } else {
            DispatchQueue.main.async {
                //  self.activityView.stopAnimating()
                self.alert.hide(isPopupAnimated: true)
            }
        }
    }
    
    // MARK: - MESSAGES
    
    func showErrorMessage() {
        //        let action = CDAlertViewAction(title: "Okay")
        //        alert.add(action: action)
        alert.isTextFieldHidden = true
        alert.hideAnimations = { _, transform, alpha in
            transform = .identity
            alpha = 0
        }
        alert.show { _ in
        }
    }
    
    func showMessage(message: String) {
        let alert = CDAlertView(title: "", message: message, type: .warning)
        let action = CDAlertViewAction(title: "Retry")
        alert.add(action: action)
        alert.isTextFieldHidden = true
        alert.hideAnimations = { _, transform, alpha in
            transform = .identity
            alpha = 0
        }
        alert.show { _ in
            self.setup()
        }
    }
    
    // MARK: - POPUP MESSAGES


    // MARK: - Collections API
    
//    func getCollections() {
//        // self.loaderView.isHidden = false
//        //  self.animateLoading.startAnimating()
//        if Reachability.isConnectedToNetwork() {
//            ServerManager.sharedInstance.getCollectionRequest(url: ServerManager.sharedInstance.exdURL + "categories", completion: { js in
//                // print(js)
//                self.getCollections(json: js)
//            })
//        }else{
//            CommonMethods.doSomething(view: self){
//                self.getCollections()
//            }
//        }
//    }
//
    
    //MARK:-API For get Categories
    func getAllCategories()
    {
        if(Reachability.isConnectedToNetwork()){

            WebApi.getAllCategories(withCompletionHandler: { [self] (list)  in
                
                print(list as Any)

                categoryList = list!
                self.categoryCollectionView.delegate = self
                self.categoryCollectionView.dataSource = self
                self.categoryCollectionView.reloadData()

            }) { (title, message) in

                self.showMessage(message:message!)
            }
        }else{
            CommonMethods.doSomething(view: self) {
                self.getAllCategories()
            }
        }
    }
    
   
    // MARK: - WISHLIST API
    
    

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
                            if newArrivals.products != nil{
                                self.topSellingCollectionView.delegate = self
                                self.topSellingCollectionView.dataSource = self
                                self.topSellingCollectionView.reloadData()
                                self.newArrivalsCollectionView.delegate = self
                                self.newArrivalsCollectionView.dataSource = self
                                self.newArrivalsCollectionView.reloadData()

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
    
    func addToWishlist(productID: String?) {
        //  activityView.startAnimating()
        let userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
        let param = [
            "user_id": "\(userInfo!.userID ?? 0)" as Any,
            "product_id": productID as Any,
        ] as [String: AnyObject]
        
        if Reachability.isConnectedToNetwork() {
            ServerManager.sharedInstance.postRequestNew(param: param, url: "http://shahalamiportal.com/api/v1/addUserProduct", fnToken: "") { js, _ in
                print(js)
                DispatchQueue.main.async { [self] in
                    
                  //  if (js["isSuccessfull"] != nil) == true{
                        
                    self.view.makeToast(AppTheme.sharedInstance.productAddedToWishlist)
                    self.getWishlistIDs()
                   // }
                }
            }
            
        } else {
            CommonMethods.doSomething(view: self) {
                 self.getWishlistIDs()
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
                guard json != nil else {
                    return
                }
                DispatchQueue.main.async { [self] in
                    // self.activityView.stopAnimating()
                    if json["product_ids"]! as! String != "" {
                        self.view.makeToast(AppTheme.sharedInstance.productRemovedFromWishlist)
                        self.getWishlistIDs()
                    } else {
                        self.view.makeToast(AppTheme.sharedInstance.productRemovedFromWishlist)
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
    
    
    func showMessages(message: String) {
       

        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            alert.dismiss(animated: true) {
            }
        }))
        present(alert, animated: true, completion: nil)
    }
}
