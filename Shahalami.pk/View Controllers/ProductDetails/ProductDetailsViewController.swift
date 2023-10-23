//
//  ProductDetailsViewController.swift
//  Easy Shopping
//
//  Created by Ahmed on 22/10/2021.
//

import CDAlertView
import Toast_Swift
import UIKit

import ImageSlideshow
import NVActivityIndicatorView

@available(iOS 13.0, *)
class ProductDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
    @IBOutlet var viewSlider: UIView!
    @IBOutlet var slideShow: ImageSlideshow!
    @IBOutlet var relatedProductsCollectionView: UICollectionView!
    @IBOutlet var cartButtonview: UIView!
    @IBOutlet var productNameLbl: UILabel!
    @IBOutlet var productPriceLbl: UILabel!
    @IBOutlet var skuLbl: UILabel!
    @IBOutlet var vendorNameLbl: UILabel!
    @IBOutlet var addToCartbtn: UIButton!
    @IBOutlet var productInfoTextView: UITextView!

    @IBOutlet var activityView: NVActivityIndicatorView!
    var sliderImages = [UIImage]()
    var productDetails = Pro()
    var searchProductDetails = SearchedProduct()
    var searchDirectFromHome: Bool = false
    var isSearchedProduct: Bool = false
    var collectionList: [Product]?
    var temp: Product?
    var index: Int?
    var isRelatedProducts: Bool = false

    var localSource: [SDWebImageSource] = []
    let alert = CDAlertView(title: "Network Error", message: "Please connect to the internet", type: .warning)
    var product_id: Int = 0
    var variantIndex: Int = 0
    var wishlistIDs: [String] = []
    var wishlist_ids: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

        if searchDirectFromHome == true {
            // if isSearchedProduct == true {
            getProduct(productID: product_id)
            // }

        } else {
            setData()
            getCollections()
            setImageSlider()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        addBadgeCounter()
        print(userInfo as Any)
        userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
    }

    override func viewDidAppear(_ animated: Bool) {
        let usertoken = AppUtility.sharedInstance.getUserData(forKey: USER_TOKEN_KEY)
        if usertoken != nil {
            getWishlistIDs()
        }
    }

    // MARK: - GET PRODUCT FROM SEARCH

    func getProduct(productID: Int) {
        print("Reachable via WiFi")
        let id = productID
        ServerManager.sharedInstance.getRequest(url: ServerManager.sharedInstance.BASE_URL + "products/\(id).json", completion: { js in
            print(js)
            self.getProductData(jsson: js)
        })
    }

    fileprivate func getProductData(jsson: AnyObject) {
        if jsson is [String: Any] {
//            collectionList = []

            do {
                let json = jsson as! [String: Any]
//                let status = jsson.value(forKey: "status") as! String
//                if (status != "error") {
                let data = SearchedProduct(dictionary: json as NSDictionary)
                searchProductDetails = data
                print(searchProductDetails)
                DispatchQueue.main.async {
                    self.isSearchedProduct = true
                    self.setData()
                    self.setImageSlider()
                    self.getCollections()
                }

            } catch let error {
                print(error)
                DispatchQueue.main.async {
//                    GIFHUD.shared.dismiss()
                    // self.activityView.stopAnimating()
                    self.alert.hide(isPopupAnimated: true)

                    let message = jsson.value(forKey: "message") as! String
                    self.showMessage(message: message)
                }
            }

        } else {
            DispatchQueue.main.async {
//                GIFHUD.shared.dismiss()
                //     self.activityView.stopAnimating()
                self.alert.hide(isPopupAnimated: true)

                let message = jsson.value(forKey: "message") as! String
                self.showMessage(message: message)
            }
        }
    }

    // MARK: - ADD TO CART

    @IBAction func addToCartBtn(_ sender: Any) {
        setCartData()
    }

    func setCartData() {
        if isRelatedProducts == true {
            let myVarinats = temp?.variants!
            let objVariant = myVarinats![variantIndex]

            if userInfo?.lineItems?.count == 1 {
                if userInfo?.lineItems?[0].title == "" || userInfo?.lineItems![0].title == nil {
                    userInfo?.lineItems![0].variant_id = Int(productDetails.variants![0].id ?? "0")
                    userInfo?.lineItems![0].id = Int(productDetails.id ?? "0")
                    userInfo?.lineItems![0].quantity = 1
                    userInfo?.lineItems![0].title = productDetails.title
                    userInfo?.lineItems![0].image = productDetails.image?.src
                    let price = objVariant.price! / 100
                    userInfo?.lineItems![0].price = Double(price)
                    userInfo?.lineItems![0].size = productDetails.title
                    userInfo?.currencyCode = "PKR"
                    userInfo?.saveCurrentSession(forKey: USER_MODEL)
                    //                self.view.makeToast("Product added to cart")
                } else {
                    addToCart()
                }
            } else {
                addToCart()
            }
            badgeCount.text = "\((userInfo?.lineItems!.count)!)"
            badgeCount.isHidden = false

        } else if isSearchedProduct == true {
            let myVarinats = searchProductDetails.product?.variants
            let objVariant = myVarinats![variantIndex]

            if userInfo?.lineItems?.count == 1 {
                if userInfo?.lineItems?[0].title == "" || userInfo?.lineItems![0].title == nil {
                    userInfo?.lineItems![0].variant_id = Int(productDetails.variants![0].id ?? "0")
                    userInfo?.lineItems![0].id = Int(searchProductDetails.product?.id ?? "0")
                    userInfo?.lineItems![0].quantity = 1
                    userInfo?.lineItems![0].title = searchProductDetails.product?.title
                    userInfo?.lineItems![0].image = searchProductDetails.product?.image?.src
                    userInfo?.lineItems![0].price = (objVariant.price! as NSString).doubleValue
                    userInfo?.lineItems![0].size = searchProductDetails.product?.title
                    userInfo?.currencyCode = "PKR"
                    userInfo?.saveCurrentSession(forKey: USER_MODEL)
                    //                self.view.makeToast("Product added to cart")
                } else {
                    addToCart()
                }
            } else {
                addToCart()
            }
            badgeCount.text = "\((userInfo?.lineItems!.count)!)"
            badgeCount.isHidden = false
        } else {
            let myVarinats = productDetails.variants!
            let objVariant = myVarinats[variantIndex]

            if userInfo?.lineItems?.count == 1 {
                if userInfo?.lineItems?[0].title == "" || userInfo?.lineItems![0].title == nil {
                    userInfo?.lineItems![0].variant_id = Int(productDetails.variants![0].id ?? "0")
                    userInfo?.lineItems![0].id = Int(productDetails.id ?? "0")
                    userInfo?.lineItems![0].quantity = 1
                    userInfo?.lineItems![0].title = productDetails.title
                    userInfo?.lineItems![0].image = productDetails.image?.src
                    userInfo?.lineItems![0].price = (objVariant.price! as NSString).doubleValue
                    userInfo?.lineItems![0].size = productDetails.title
                    userInfo?.currencyCode = "PKR"
                    userInfo?.saveCurrentSession(forKey: USER_MODEL)
                    //                self.view.makeToast("Product added to cart")
                } else {
                    addToCart()
                }
            } else {
                addToCart()
            }
            badgeCount.text = "\((userInfo?.lineItems!.count)!)"
            badgeCount.isHidden = false
        }
    }

    func addToCart() {
        if isSearchedProduct == true {
            let myVarinats = searchProductDetails.product!.variants!
            let objVariant = myVarinats[variantIndex]
            for i in 0 ..< (userInfo?.lineItems!.count)! {
                let qty = 1
                let oldQty = (userInfo?.lineItems![i].quantity)!
                if userInfo?.lineItems![i].variant_id == Int(searchProductDetails.product!.variants![0].id ?? "0") {
                    userInfo?.lineItems![i].quantity = oldQty + qty
                    userInfo?.saveCurrentSession(forKey: USER_MODEL)
                    //                self.view.makeToast("Product added to cart")
                    return
                }
            }
            var product: Item = Item()
            product.variant_id = Int(searchProductDetails.product!.variants![0].id ?? "0")
            product.quantity = 1
            product.id = Int(searchProductDetails.product!.id ?? "0")
            product.title = searchProductDetails.product!.title
            product.image = searchProductDetails.product!.image?.src
            product.price = (objVariant.price! as NSString).doubleValue
            product.size = searchProductDetails.product!.title
            userInfo?.currencyCode = "PKR"
            userInfo?.lineItems?.append(product)
            userInfo?.currencyCode = "PKR"
            userInfo?.saveCurrentSession(forKey: USER_MODEL)
            addBadgeCounter()
            view.makeToast(AppTheme.sharedInstance.addToCart)

        } else if isRelatedProducts == true {
            let myVarinats = temp?.variants!
            let objVariant = myVarinats![variantIndex]
            for i in 0 ..< (userInfo?.lineItems!.count)! {
                let qty = 1
                let oldQty = (userInfo?.lineItems![i].quantity)!
                if userInfo?.lineItems![i].variant_id == Int((temp?.variants![0].id!)!) {
                    userInfo?.lineItems![i].quantity = oldQty + qty
                    userInfo?.saveCurrentSession(forKey: USER_MODEL)
                    //                self.view.makeToast("Product added to cart")
                    return
                }
            }
            var product: Item = Item()
            product.variant_id = Int((temp?.variants![0].id)!)
            product.quantity = 1
            product.id = Int((temp?.id)!)
            product.title = temp?.title
            product.image = temp?.media![0].preview_image?.src
            let price = objVariant.price! / 100
            product.price = Double(price)
            product.size = temp?.title
            userInfo?.currencyCode = "PKR"
            userInfo?.lineItems?.append(product)
            userInfo?.currencyCode = "PKR"
            userInfo?.saveCurrentSession(forKey: USER_MODEL)
            addBadgeCounter()
            view.makeToast(AppTheme.sharedInstance.addToCart)
        } else {
            let myVarinats = productDetails.variants!
            let objVariant = myVarinats[variantIndex]
            for i in 0 ..< (userInfo?.lineItems!.count)! {
                let qty = 1
                let oldQty = (userInfo?.lineItems![i].quantity)!
                if userInfo?.lineItems![i].variant_id == Int(productDetails.variants![0].id ?? "0") {
                    userInfo?.lineItems![i].quantity = oldQty + qty
                    userInfo?.saveCurrentSession(forKey: USER_MODEL)
                    view.makeToast(AppTheme.sharedInstance.addToCart)
                    return
                }
            }
            var product: Item = Item()
            product.variant_id = Int(productDetails.variants![0].id ?? "0")
            product.quantity = 1
            product.id = Int(productDetails.id ?? "0")
            product.title = productDetails.title
            product.image = productDetails.image?.src
            product.price = (objVariant.price! as NSString).doubleValue
            product.size = productDetails.title
            userInfo?.currencyCode = "PKR"
            userInfo?.lineItems?.append(product)
            userInfo?.currencyCode = "PKR"
            userInfo?.saveCurrentSession(forKey: USER_MODEL)
            addBadgeCounter()
            view.makeToast(AppTheme.sharedInstance.addToCart)
        }
    }

    // MARK: - ADD BADGE COUNTER

    var badgeCount = UILabel(frame: CGRect(x: 22, y: -05, width: 20, height: 20))
    func addBadgeCounter() {
        // let userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
//        let badgeCount = UILabel(frame: CGRect(x: 22, y: -05, width: 20, height: 20))
        badgeCount.layer.borderColor = UIColor.clear.cgColor
        badgeCount.layer.borderWidth = 2
        badgeCount.layer.cornerRadius = badgeCount.bounds.size.height / 2
        badgeCount.textAlignment = .center
        badgeCount.layer.masksToBounds = true
        badgeCount.textColor = .white
        badgeCount.font = badgeCount.font.withSize(12)
        badgeCount.backgroundColor = AppTheme.sharedInstance.LBL_Blue
        if userInfo?.lineItems?.count == 1 {
            if userInfo?.lineItems![0].title == "" || userInfo?.lineItems![0].title == nil {
                badgeCount.text = "0"
                badgeCount.isHidden = true
            } else {
                badgeCount.text = "\(userInfo!.lineItems!.count)"
                let tabItems = tabBarController?.tabBar.items
                // In this case we want tomodify the badge number of the third tab:
                let tabItem = tabItems![2]
                tabItem.badgeValue = badgeCount.text

                badgeCount.isHidden = false
            }
        } else if (userInfo?.lineItems!.count)! >= 1 {
            badgeCount.text = "\(userInfo!.lineItems!.count)"
            let tabItems = tabBarController?.tabBar.items
            // In this case we want tomodify the badge number of the third tab:
            let tabItem = tabItems![2]
            tabItem.badgeValue = badgeCount.text

            badgeCount.isHidden = false
        } else {
            if let tabItems = tabBarController?.tabBar.items {
                // In this case we want tomodify the badge number of the third tab:
                let tabItem = tabItems[2]
                tabItem.badgeValue = nil
            }
            badgeCount.isHidden = true
        }

//        let rightBarButton = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
//        rightBarButton.setBackgroundImage(UIImage(named: "ic_cart"), for: .normal)
//        rightBarButton.addTarget(self, action: #selector(self.onCart), for: .touchUpInside)
//        rightBarButton.addSubview(badgeCount)
//        let rightBarButtomItem = UIBarButtonItem(customView: rightBarButton)
//        navigationItem.rightBarButtonItem = rightBarButtomItem
    }

    // MARK: - GALLERY VIEW

    @objc func didTap() {
        let fullScreenController = slideShow.presentFullScreenController(from: self)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .medium, color: nil)
    }

    // MARK: - UICollectionViewDataSource protocol

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionList!.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RelatedProductsCell", for: indexPath as IndexPath) as! RelatedProductsCollectionViewCell

        let data = collectionList![indexPath.row]

        cell.productName.text = data.title
        let price = Int(data.price! / 100)
        cell.productPrice.text = "Rs. \(price.withCommas())"

        if data.media!.count > 0 {
            cell.productImage.sd_setImage(with: URL(string: data.media![0].preview_image!.src!), placeholderImage: UIImage(named: "ic_placeholder")) {
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
        cell.favouriteBtn.tag = indexPath.row
        cell.addToCartButton.tag = indexPath.row
        for id in wishlistIDs {
            if id == "\(data.id ?? 0)" {
                cell.favouriteBtn.isSelected = true
                cell.favouriteBtn.setImage(UIImage(named: "ic_favourite"), for: .normal)
                break
            } else {
                cell.favouriteBtn.isSelected = false
                cell.favouriteBtn.setImage(UIImage(named: "ic_unfavourite"), for: .normal)
            }
        }

        cell.favouriteBtn.addTarget(self, action: #selector(addFavourite(sender:)), for: .touchUpInside)

        cell.addToCartButton.addTarget(self, action: #selector(addToCartProducts(sender:)), for: .touchUpInside)

        cell.contentView.uiViewShadow()
        cell.cellView.layer.cornerRadius = 8

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailsViewController
        cv.modalTransitionStyle = .crossDissolve
        //  cv.title = "PRODUCTS"
        cv.isRelatedProducts = true
        cv.temp = collectionList![indexPath.row]
        print("You selected cell #\(indexPath.row)!")
        navigationController?.pushViewController(cv, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width * 0.45, height: view.frame.height * 0.35)
    }

    // MARK: - ADD TO CART

    @objc func addToCartProducts(sender: UIButton) {
        let buttonNumber = sender.tag
        setCartData(tagID: sender.tag)
        print(buttonNumber)
    }

    func setCartData(tagID: Int?) {
        var userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
        let myVarinats = collectionList?[tagID ?? 0].variants
        let objVariant = myVarinats?[variantIndex]

        if userInfo?.lineItems?.count == 1 {
            if userInfo?.lineItems?[0].title == "" || userInfo?.lineItems![0].title == nil {
                userInfo?.lineItems![0].variant_id = Int(collectionList?[tagID ?? 0].variants![0].id ?? 0)
                userInfo?.lineItems![0].id = Int(collectionList?[tagID ?? 0].id ?? 0)
                userInfo?.lineItems![0].quantity = 1
                userInfo?.lineItems![0].title = collectionList?[tagID ?? 0].title
                userInfo?.lineItems![0].image = collectionList?[tagID ?? 0].media![0].preview_image?.src
                let price = (objVariant?.price)! / 100
                userInfo?.lineItems![0].price = Double(price)
                userInfo?.lineItems![0].size = collectionList?[tagID ?? 0].title
                userInfo?.currencyCode = "PKR"
                userInfo?.saveCurrentSession(forKey: USER_MODEL)
                addBadgeCounter()
                view.makeToast(AppTheme.sharedInstance.addToCart)
            } else {
                addToCart(tagID: tagID ?? 0)
            }
        } else {
            addToCart(tagID: tagID ?? 0)
        }
        badgeCount.text = "\((userInfo?.lineItems!.count)!)"
        badgeCount.isHidden = false
    }

    func addToCart(tagID: Int) {
        var userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
        let myVarinats = collectionList?[tagID].variants!
        let objVariant = myVarinats?[variantIndex]
        for i in 0 ..< (userInfo?.lineItems!.count)! {
            let qty = 1
            let oldQty = (userInfo?.lineItems![i].quantity)!
            if userInfo?.lineItems![i].variant_id == Int(collectionList?[tagID].variants![0].id ?? 0) {
                userInfo?.lineItems![i].quantity = oldQty + qty
                userInfo?.saveCurrentSession(forKey: USER_MODEL)
                view.makeToast(AppTheme.sharedInstance.quantityAdded)
                return
            }
        }
        var product: Item = Item()
        product.variant_id = Int(collectionList?[tagID].variants![0].id ?? 0)
        product.quantity = 1
        product.id = Int(collectionList?[tagID].id ?? 0)
        product.title = collectionList?[tagID].title
        product.image = collectionList?[tagID].media![0].preview_image?.src
        let price = (objVariant?.price)! / 100
        product.price = Double(price)
        product.size = collectionList?[tagID].title
        userInfo?.currencyCode = "PKR"
        userInfo?.lineItems?.append(product)
        userInfo?.currencyCode = "PKR"
        userInfo?.saveCurrentSession(forKey: USER_MODEL)
        addBadgeCounter()
        view.makeToast(AppTheme.sharedInstance.addToCart)
        viewWillAppear(true)
    }

    // MARK: - SETUP

    func setup() {
        cartButtonview.layer.cornerRadius = 25
        cartButtonview.buttonUiViewShadow()
        cartButtonview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        // productInfoTextView.adjustUITextViewHeight()
        productNameLbl.numberOfLines = 0

        //
        sliderImages = [#imageLiteral(resourceName: "armchair-1"), #imageLiteral(resourceName: "sofa-1"), #imageLiteral(resourceName: "sofa-2")]
        viewSlider.layer.cornerRadius = 8
        viewSlider.uiViewShadow()
    }

    func setData() {
        if isRelatedProducts == true {
            productNameLbl.text = temp!.title
            vendorNameLbl.text = "VENDOR: \(temp!.vendor ?? "")"
            if temp!.variants![0].sku == nil {
                skuLbl.isHidden = true
            } else {
                skuLbl.isHidden = false
                skuLbl.text = "SKU: \(temp!.variants![0].sku!)"
            }
            productInfoTextView.text = temp!.description!.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)

            let p = Int(temp!.price! / 100)
            productPriceLbl.text = "Rs. \(p.withCommas())"
            if temp!.media!.count > 0 {
                for item in temp!.media! {
                    print("item: \(item.src ?? "")")
                    localSource.append(SDWebImageSource(urlString: item.src!)!)
                }
            }

        } else if isSearchedProduct == true {
            productNameLbl.text = searchProductDetails.product?.title!
            vendorNameLbl.text = "VENDOR: \(searchProductDetails.product?.vendor! ?? "")"
            if searchProductDetails.product!.variants![0].sku == nil {
                skuLbl.isHidden = true
            } else {
                skuLbl.isHidden = false
                skuLbl.text = "SKU: \(searchProductDetails.product!.variants![0].sku!)"
            }
            let info = searchProductDetails.product!.body_html!.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            productInfoTextView.text = info
            var price = searchProductDetails.product!.variants![0].price!
            if let dotRange = price.range(of: ".") {
                price.removeSubrange(dotRange.lowerBound ..< price.endIndex)
            }
            let p = Int(price)
            productPriceLbl.text = "Rs. \(p?.withCommas() ?? "")"
            if searchProductDetails.product?.image?.src != nil {
                //   for item in searchProductDetails.product?.images {
                // print( "item: \(item.src!)")
                localSource.append(SDWebImageSource(urlString: (searchProductDetails.product?.image?.src!)!)!)
                // }
            }

        } else {
            productNameLbl.text = productDetails.title!
            vendorNameLbl.text = "VENDOR: \(productDetails.vendor!)"
            if productDetails.variants![0].sku == nil {
                skuLbl.isHidden = true
            } else {
                skuLbl.isHidden = false
                skuLbl.text = "SKU: \(productDetails.variants![0].sku!)"
            }
            let info = productDetails.body_html!.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            productInfoTextView.text = info
            var price = productDetails.variants![0].price!
            if let dotRange = price.range(of: ".") {
                price.removeSubrange(dotRange.lowerBound ..< price.endIndex)
            }
            let p = Int(price)
            productPriceLbl.text = "Rs. \(p?.withCommas() ?? "")"

            if productDetails.images != nil {
                for item in productDetails.images! {
                    print("item: \(item.src!)")
                    localSource.append(SDWebImageSource(urlString: item.src!)!)
                }
            }
        }
    }

    // MARK: - SET IMAGE SLIDER

    func setImageSlider() {
        slideShow.slideshowInterval = .zero
        slideShow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        slideShow.contentScaleMode = UIView.ContentMode.scaleAspectFit

        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        pageControl.pageIndicatorTintColor = UIColor.black
        pageControl.numberOfPages = sliderImages.count

        slideShow.pageIndicator = pageControl
        slideShow.activityIndicator = DefaultActivityIndicator()
        slideShow.setImageInputs(localSource)

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(ProductDetailsViewController.didTap))
        slideShow.addGestureRecognizer(recognizer)
    }

    // MARK: - CALL RELATED PRODUCTS API

    func getCollections() {
//        GIFHUD.shared.setGif(named: AppConstatns.sharedInstance.apiGif)
        if isRelatedProducts == true {
            product_id = temp!.id!
        } else if isSearchedProduct == true {
            product_id = Int((searchProductDetails.product?.id!)!)!
        } else {
            product_id = (productDetails.id! as String).integerValue()
        }
        if Reachability.isConnectedToNetwork() {
            print("Reachable via WiFi")

            activityView.startAnimating()
            ServerManager.sharedInstance.getRequest(url: ServerManager.sharedInstance.related_products_url + "recommendations/products.json?product_id=\(product_id )&published_status=published&limit=10", completion: { js in
                print(js)
                self.getCollectionData(json: js)
            })

        } else {
            CommonMethods.doSomething(view: self) {
                self.getCollections()
            }
        }
    }

    fileprivate func getCollectionData(json: AnyObject) {
        if json is [String: Any] {
            let decoder = JSONDecoder()
            collectionList = []

            do {
                let json = json as! [String: Any]
                let collectionData: Data = try JSONSerialization.data(withJSONObject: json as Any, options: [])
                let collectionModel = try decoder.decode(RecommendedProducts.self, from: collectionData)

                for i in 0 ..< (collectionModel.products?.count ?? 0) {
                    let objCollection = collectionModel.products![i]
                    collectionList?.append(objCollection)
                }

                print(collectionList?.count ?? 0)
                DispatchQueue.main.async {
//                    GIFHUD.shared.dismiss()
                    self.activityView.stopAnimating()
                    self.alert.hide(isPopupAnimated: true)
                    self.relatedProductsCollectionView.delegate = self
                    self.relatedProductsCollectionView.dataSource = self
                    self.relatedProductsCollectionView.reloadData()
                }
            } catch let error {
                print(error)
                DispatchQueue.main.async {
//                    GIFHUD.shared.dismiss()
                    self.activityView.stopAnimating()
                    self.alert.hide(isPopupAnimated: true)
                    //  self.showMessage(message: message)
                }
            }
        } else {
            DispatchQueue.main.async {
//                GIFHUD.shared.dismiss()
                self.activityView.stopAnimating()
                self.alert.hide(isPopupAnimated: true)
            }
            let message = json.value(forKey: "message") as! String
            showMessage(message: message)
        }
    }

    func showErrorMessage() {
        let action = CDAlertViewAction(title: "Okay")
        alert.add(action: action)
        alert.isTextFieldHidden = true
        alert.hideAnimations = { _, transform, alpha in
            transform = .identity
            alpha = 0
        }
        alert.show { _ in
        }
    }

    // MARK: - WISHLIST

    @objc func addFavourite(sender: UIButton) {
        let usertoken = AppUtility.sharedInstance.getUserData(forKey: USER_TOKEN_KEY)
        if usertoken != nil {
            let section = sender.tag / 100
            let item = sender.tag % 100
            let indexPath = IndexPath(item: item, section: section)

            let cell = relatedProductsCollectionView?.cellForItem(at: indexPath) as! RelatedProductsCollectionViewCell
            let id = collectionList?[sender.tag].id

            if cell.favouriteBtn.isSelected {
                cell.favouriteBtn.isSelected = false
                cell.favouriteBtn.setImage(UIImage(named: "ic_unfavourite"), for: .normal)
                removeWishlistIDs(productID: "\(id!)")
            } else {
                cell.favouriteBtn.isSelected = true
                cell.favouriteBtn.setImage(UIImage(named: "ic_favourite"), for: .normal)
                addToWishlist(productID: "\(id ?? 0)")
            }
        } else {
            showMessage(message: "Please Login to add to wishlist.")
        }
    }

    func addToWishlist(productID: String?) {
        let userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
        let param = [
            "user_id": "\(userInfo!.userID ?? 0)" as Any,
            "product_id": productID as Any,
        ] as [String: AnyObject]

        if Reachability.isConnectedToNetwork() {
            ServerManager.sharedInstance.postRequestNew(param: param, url: ServerManager.sharedInstance.exdURL + "addUserProduct", fnToken: "") { _, _ in
                DispatchQueue.main.async { [self] in
                    self.view.makeToast(AppTheme.sharedInstance.productAddedToWishlist)
                    self.getWishlistIDs()
                }
            }

        } else {
            CommonMethods.doSomething(view: self) {
                // self.getWishlistIDs()
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

    func getWishlistIDs() {
        if Reachability.isConnectedToNetwork() {
            let userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
            let param = [
                "user_id": "\(userInfo!.userID ?? 0)" as Any,
            ] as [String: AnyObject]

            WebApi.manager.fetchWishlist(params: param) { [self] resp in
                switch resp {
                case let .success(resp):
                    print(resp)

                    DispatchQueue.main.async { [self] in
                        wishlist_ids = resp.product_ids!
                        wishlistIDs = wishlist_ids!.components(separatedBy: ",")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            if collectionList != nil {
                                self.relatedProductsCollectionView.delegate = self
                                self.relatedProductsCollectionView.dataSource = self
                                self.relatedProductsCollectionView.reloadData()

                                print("Wishlist")
                                print(wishlistIDs)
                            }
                        }
                    }

                case let .failure(error):
                    print(error)
                    showMessage(message: error.localizedDescription)
                }
            }
        } else {
            CommonMethods.doSomething(view: self) {
                self.getWishlistIDs()
            }
        }
    }


    func showMessage(message: String?) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            alert.dismiss(animated: true) {
            }
        }))
        present(alert, animated: true, completion: nil)
    }
}
