//
//  AllBrandsProductsViewController.swift
//  Shahalami.pk
//
//  Created by Ahmed on 10/01/2022.
//

import NVActivityIndicatorView
import SDWebImage
import Toast_Swift
import UIKit
import SwiftGifOrigin
import TagListView
class AllBrandsProductsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TagListViewDelegate {
    

    var vendor:String = ""
    var variantIndex:Int = 0
    var wishlist_ids: String?
    var brandName: String? = ""
    var wishlistIDs: [String] = []
    var filterArray: [String] = []

    var filteredArray = [Pro]()
    var brandsProducts = Products()
    var priceFilteredArray = [Pro]()
    var filteredProductDetails = [Pro]()
    
    var layoutChanged: Bool = false
    var isSearchFilter:Bool = false
    var isPriceFilter:Bool = false

    var parentNavController: UINavigationController!

    @IBOutlet weak var minimumPriceFilterLabel: UILabel!
    @IBOutlet var viewButton: UIButton!
    @IBOutlet var totalProductCount: UILabel!
    @IBOutlet var filterView: UIView!
    
    @IBOutlet weak var animationView: UIImageView!
    
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet var productsCollectionView: UICollectionView!

    @IBOutlet weak var noProductsLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        tagListView.textColor = #colorLiteral(red: 0.1686044633, green: 0.1686406434, blue: 0.1686021686, alpha: 1)
        
        
        let str = brandName
        let replaced = str?.replacingOccurrences(of: " ", with: "%20")
        getBrands(name: replaced ?? "")
        layoutSetting(productsCollectionView)
        let nibName = UINib(nibName: "ProdoctsNewCollectionViewCell", bundle: nil)
        productsCollectionView.register(nibName, forCellWithReuseIdentifier: "cell")
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        let usertoken = AppUtility.sharedInstance.getUserData(forKey: USER_TOKEN_KEY)
        if usertoken != nil {
            getWishlistIDs()
        }
        // addBadgeCounter()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isPriceFilter == true{
            return priceFilteredArray.count
        }else
        if isSearchFilter == true {
            return filteredProductDetails.count
        } else {
            return brandsProducts.products?.count ?? 0
        }
       
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if layoutChanged == false {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemsCell", for: indexPath as IndexPath) as! ItemsCollectionViewCell

            cell.contentView.uiViewShadow()
            cell.cellView.layer.cornerRadius = 8
            
            if isPriceFilter == true{
                let data = priceFilteredArray[indexPath.row]

                cell.productNameLbl.text = data.title

                let image = data.images![0].src
                if image != nil {
                    cell.productImageView.sd_setImage(with: URL(string: image ?? ""), placeholderImage: UIImage(named: "ic_placeholder")) {
                        image, error, _, _ in
                        // your code
                        if error == nil {
                            cell.productImageView.contentMode = .scaleAspectFit
                        } else {
                            cell.productImageView.contentMode = .scaleAspectFit
                        }
                        print(image ?? "")
                    }
                }
                var price = data.variants![0].price
                if let dotRange = price!.range(of: ".") {
                    price!.removeSubrange(dotRange.lowerBound ..< price!.endIndex)
                }
                let p = Int(price ?? "")
                cell.productPriceLbl.text = "Rs. \(p?.withCommas() ?? "")"
               
                cell.favouriteBtn.tag = indexPath.row
                for id in wishlistIDs {
                    if id == data.id {
                        cell.favouriteBtn.isSelected = true
                        cell.favouriteBtn.setImage(UIImage(named: "ic_favourite"), for: .normal)
                        break
                    } else {
                        cell.favouriteBtn.isSelected = false
                        cell.favouriteBtn.setImage(UIImage(named: "ic_unfavourite"), for: .normal)
                    }
                }
                cell.addToCartButton.tag = indexPath.row
                cell.addToCartButton.addTarget(self, action: #selector(addToCartProducts(sender:)), for: .touchUpInside)
                cell.favouriteBtn.addTarget(self, action: #selector(unfavouritePressed(sender:)), for: .touchUpInside)

            }else
            if isSearchFilter == true{
                let data = filteredProductDetails[indexPath.row]

                cell.productNameLbl.text = data.title

                let image = data.images![0].src
                if image != nil {
                    cell.productImageView.sd_setImage(with: URL(string: image ?? ""), placeholderImage: UIImage(named: "ic_placeholder")) {
                        image, error, _, _ in
                        // your code
                        if error == nil {
                            cell.productImageView.contentMode = .scaleAspectFit
                        } else {
                            cell.productImageView.contentMode = .scaleAspectFit
                        }
                        print(image ?? "")
                    }
                }
                var price = data.variants![0].price
                if let dotRange = price!.range(of: ".") {
                    price!.removeSubrange(dotRange.lowerBound ..< price!.endIndex)
                }
                let p = Int(price ?? "")
                cell.productPriceLbl.text = "Rs. \(p?.withCommas() ?? "")"
               
                cell.favouriteBtn.tag = indexPath.row
                for id in wishlistIDs {
                    if id == data.id {
                        cell.favouriteBtn.isSelected = true
                        cell.favouriteBtn.setImage(UIImage(named: "ic_favourite"), for: .normal)
                        break
                    } else {
                        cell.favouriteBtn.isSelected = false
                        cell.favouriteBtn.setImage(UIImage(named: "ic_unfavourite"), for: .normal)
                    }
                }
                cell.addToCartButton.tag = indexPath.row
                cell.addToCartButton.addTarget(self, action: #selector(addToCartProducts(sender:)), for: .touchUpInside)
                cell.favouriteBtn.addTarget(self, action: #selector(unfavouritePressed(sender:)), for: .touchUpInside)

            }else
            {
            
            let data = brandsProducts.products![indexPath.row]

            cell.productNameLbl.text = data.title

            let image = data.images![0].src
            if image != nil {
                cell.productImageView.sd_setImage(with: URL(string: image ?? ""), placeholderImage: UIImage(named: "ic_placeholder")) {
                    image, error, _, _ in
                    // your code
                    if error == nil {
                        cell.productImageView.contentMode = .scaleAspectFit
                    } else {
                        cell.productImageView.contentMode = .scaleAspectFit
                    }
                    print(image ?? "")
                }
            }
            var price = data.variants![0].price
            if let dotRange = price!.range(of: ".") {
                price!.removeSubrange(dotRange.lowerBound ..< price!.endIndex)
            }
            let p = Int(price ?? "")
            cell.productPriceLbl.text = "Rs. \(p?.withCommas() ?? "")"
           
            cell.favouriteBtn.tag = indexPath.row
            for id in wishlistIDs {
                if id == data.id {
                    cell.favouriteBtn.isSelected = true
                    cell.favouriteBtn.setImage(UIImage(named: "ic_favourite"), for: .normal)
                    break
                } else {
                    cell.favouriteBtn.isSelected = false
                    cell.favouriteBtn.setImage(UIImage(named: "ic_unfavourite"), for: .normal)
                }
            }
            cell.addToCartButton.tag = indexPath.row
            cell.addToCartButton.addTarget(self, action: #selector(addToCartProducts(sender:)), for: .touchUpInside)
            cell.favouriteBtn.addTarget(self, action: #selector(unfavouritePressed(sender:)), for: .touchUpInside)
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! ProdoctsNewCollectionViewCell

            cell.cellView.addShadow(opacity: 0.4, cornerRadius: 8, shadowRadius: 4.0)
            
            if isPriceFilter == true{
                let data = priceFilteredArray[indexPath.row]

                if data.image != nil {
                    cell.productIamgeView.sd_setImage(with: URL(string: data.image!.src ?? ""), placeholderImage: UIImage(named: "ic_placeholder")) {
                        image, error, _, _ in
                        // your code
                        if error == nil {
                            cell.productIamgeView.contentMode = .scaleAspectFit
                        } else {
                            cell.productIamgeView.contentMode = .scaleAspectFit
                        }
                        print(image ?? "")
                    }
                }
                cell.productNameLbl.text = data.title!
                var price = data.variants![0].price
                if let dotRange = price!.range(of: ".") {
                    price!.removeSubrange(dotRange.lowerBound ..< price!.endIndex)
                }
                let p = Int(price ?? "")
                cell.productPriceLbl.text = "Rs. \(p?.withCommas() ?? "")"
                cell.favouriteBtn.tag = indexPath.row
                for id in wishlistIDs {
                    if id == data.id {
                        cell.favouriteBtn.isSelected = true
                        cell.favouriteBtn.setImage(UIImage(named: "ic_favourite"), for: .normal)
                        break
                    } else {
                        cell.favouriteBtn.isSelected = false
                        cell.favouriteBtn.setImage(UIImage(named: "ic_unfavourite"), for: .normal)
                    }
                }
                cell.addToCartBtn.tag = indexPath.row
                cell.addToCartBtn.addTarget(self, action: #selector(addToCartProducts(sender:)), for: .touchUpInside)
                cell.favouriteBtn.addTarget(self, action: #selector(unfavouriteProdouctcollectionView(sender:)), for: .touchUpInside)
            }else if isSearchFilter == true {
                let data = filteredProductDetails[indexPath.row]

                if data.image != nil {
                    cell.productIamgeView.sd_setImage(with: URL(string: data.image!.src ?? ""), placeholderImage: UIImage(named: "ic_placeholder")) {
                        image, error, _, _ in
                        // your code
                        if error == nil {
                            cell.productIamgeView.contentMode = .scaleAspectFit
                        } else {
                            cell.productIamgeView.contentMode = .scaleAspectFit
                        }
                        print(image ?? "")
                    }
                }
                cell.productNameLbl.text = data.title!
                var price = data.variants![0].price
                if let dotRange = price!.range(of: ".") {
                    price!.removeSubrange(dotRange.lowerBound ..< price!.endIndex)
                }
                let p = Int(price ?? "")
                cell.productPriceLbl.text = "Rs. \(p?.withCommas() ?? "")"
                cell.favouriteBtn.tag = indexPath.row
                for id in wishlistIDs {
                    if id == data.id {
                        cell.favouriteBtn.isSelected = true
                        cell.favouriteBtn.setImage(UIImage(named: "ic_favourite"), for: .normal)
                        break
                    } else {
                        cell.favouriteBtn.isSelected = false
                        cell.favouriteBtn.setImage(UIImage(named: "ic_unfavourite"), for: .normal)
                    }
                }
                cell.addToCartBtn.tag = indexPath.row
                cell.addToCartBtn.addTarget(self, action: #selector(addToCartProducts(sender:)), for: .touchUpInside)
                cell.favouriteBtn.addTarget(self, action: #selector(unfavouriteProdouctcollectionView(sender:)), for: .touchUpInside)
            }else{
            
            let data = brandsProducts.products![indexPath.row]

            if data.image != nil {
                cell.productIamgeView.sd_setImage(with: URL(string: data.image!.src ?? ""), placeholderImage: UIImage(named: "ic_placeholder")) {
                    image, error, _, _ in
                    // your code
                    if error == nil {
                        cell.productIamgeView.contentMode = .scaleAspectFit
                    } else {
                        cell.productIamgeView.contentMode = .scaleAspectFit
                    }
                    print(image ?? "")
                }
            }
            cell.productNameLbl.text = data.title!
            var price = data.variants![0].price
            if let dotRange = price!.range(of: ".") {
                price!.removeSubrange(dotRange.lowerBound ..< price!.endIndex)
            }
            let p = Int(price ?? "")
            cell.productPriceLbl.text = "Rs. \(p?.withCommas() ?? "")"
            cell.favouriteBtn.tag = indexPath.row
            for id in wishlistIDs {
                if id == data.id {
                    cell.favouriteBtn.isSelected = true
                    cell.favouriteBtn.setImage(UIImage(named: "ic_favourite"), for: .normal)
                    break
                } else {
                    cell.favouriteBtn.isSelected = false
                    cell.favouriteBtn.setImage(UIImage(named: "ic_unfavourite"), for: .normal)
                }
            }
            cell.addToCartBtn.tag = indexPath.row
            cell.addToCartBtn.addTarget(self, action: #selector(addToCartProducts(sender:)), for: .touchUpInside)
            cell.favouriteBtn.addTarget(self, action: #selector(unfavouriteProdouctcollectionView(sender:)), for: .touchUpInside)
            }
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailsViewController
        print("You selected cell #\(indexPath.row)!")
        cv.productDetails = brandsProducts.products![indexPath.row]
        self.navigationController?.pushViewController(cv, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if layoutChanged == false {
            return CGSize(width: view.frame.width * 0.45, height: view.frame.height * 0.35)
        } else {
            return CGSize(width: view.frame.width * 0.95, height: view.frame.height * 0.2)
        }
    }

    // MARK: - Collection View Data Source

    fileprivate func layoutSetting(_ collection: UICollectionView) {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
         layout.itemSize = CGSize(width: view.frame.width * 0.45, height: view.frame.height * 0.35)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 12
        // layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collection.collectionViewLayout = layout
    }
    // MARK: - ADD OR REMOVE FAVOURITES

    @objc func unfavouritePressed(sender: UIButton) {
        let usertoken = AppUtility.sharedInstance.getUserData(forKey: USER_TOKEN_KEY)
        if usertoken != nil {
        let section = sender.tag / 100
        let item = sender.tag % 100
        let indexPath = IndexPath(item: item, section: section)

        let cell = productsCollectionView?.cellForItem(at: indexPath) as! ItemsCollectionViewCell

        let id = brandsProducts.products?[sender.tag].id

        if cell.favouriteBtn.isSelected {
            cell.favouriteBtn.isSelected = false
            cell.favouriteBtn.setImage(UIImage(named: "ic_unfavourite"), for: .normal)
            removeWishlistIDs(productID: id!)
        } else {
            cell.favouriteBtn.isSelected = true
            cell.favouriteBtn.setImage(UIImage(named: "ic_favourite"), for: .normal)
            addToWishlist(productID: id)
        }
        }else{
            showMessage(message: "Please Login to add to wishlist.")
        }
        let buttonNumber = sender.tag
        print(buttonNumber)
        //  print(myarray)
    }

    @objc func unfavouriteProdouctcollectionView(sender: UIButton) {
        let usertoken = AppUtility.sharedInstance.getUserData(forKey: USER_TOKEN_KEY)
        if usertoken != nil {
        let section = sender.tag / 100
        let item = sender.tag % 100
        let indexPath = IndexPath(item: item, section: section)

        let cell = productsCollectionView?.cellForItem(at: indexPath) as! ProdoctsNewCollectionViewCell
        let id = brandsProducts.products![sender.tag].id

        if cell.favouriteBtn.isSelected {
            cell.favouriteBtn.isSelected = false
            cell.favouriteBtn.setImage(UIImage(named: "ic_unfavourite"), for: .normal)
            removeWishlistIDs(productID: id!)
        } else {
            cell.favouriteBtn.isSelected = true
            cell.favouriteBtn.setImage(UIImage(named: "ic_favourite"), for: .normal)
            addToWishlist(productID: id)
        }
        }else{
            showMessage(message: "Please Login to add to wishlist.")
        }
        let buttonNumber = sender.tag
        print(buttonNumber)
        //  print(myarray)
    }
    
    @objc func addToCartProducts(sender: UIButton) {
        let buttonNumber = sender.tag
        setCartData(tagID: sender.tag)
        print(buttonNumber)
    }
    
    func setCartData(tagID:Int?){
        var userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
        let myVarinats = brandsProducts.products?[tagID ?? 0].variants!
        let objVariant = myVarinats?[variantIndex]
        
        if userInfo?.lineItems?.count == 1{
            
            if userInfo?.lineItems?[0].title == "" || userInfo?.lineItems![0].title == nil{
                userInfo?.lineItems![0].variant_id = Int(brandsProducts.products?[tagID ?? 0].variants![0].id ?? "0")
                userInfo?.lineItems![0].id = Int(brandsProducts.products?[tagID ?? 0].id ?? "0")
                userInfo?.lineItems![0].quantity = 1
                userInfo?.lineItems![0].title = brandsProducts.products?[tagID ?? 0].title
                userInfo?.lineItems![0].image = brandsProducts.products?[tagID ?? 0].image?.src
                userInfo?.lineItems![0].price = Double(objVariant?.price ?? "0")
                userInfo?.lineItems![0].size = brandsProducts.products?[tagID ?? 0].title
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
        let  myVarinats = brandsProducts.products?[tagID].variants!
        let objVariant = myVarinats?[variantIndex]
        for i in 0..<(userInfo?.lineItems!.count)! {
           let qty = 1
            let oldQty = (userInfo?.lineItems![i].quantity)!
            if userInfo?.lineItems![i].variant_id == Int(brandsProducts.products?[tagID ].variants![0].id ?? "0"){
                userInfo?.lineItems![i].quantity = oldQty + qty
                userInfo?.saveCurrentSession(forKey: USER_MODEL)
                self.view.makeToast(AppTheme.sharedInstance.quantityAdded)
                return
            }
        }
        var product:Item = Item()
        product.quantity = 1
        userInfo?.currencyCode = "PKR"
        userInfo?.currencyCode = "PKR"
        product.price = Double(objVariant?.price! ?? "0")
        product.size = brandsProducts.products?[tagID].title
        product.title = brandsProducts.products?[tagID].title
        product.image = brandsProducts.products?[tagID].image?.src
        product.id = Int(brandsProducts.products?[tagID].id ?? "0")
        product.variant_id = Int(brandsProducts.products?[tagID ].variants![0].id ?? "0")
        userInfo?.lineItems?.append(product)
        userInfo?.saveCurrentSession(forKey: USER_MODEL)
        addBadgeCounter()
       self.view.makeToast("Product added to cart")
    }
    
    
    // MARK: - ADD BADGE COUNTER
    let badgeCount = UILabel(frame: CGRect(x: 22, y: -05, width: 20, height: 20))
    func addBadgeCounter() {
        let userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
       
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
                tabItem.badgeValue = badgeCount.text
            }
            badgeCount.isHidden = false
        } else {
            if let tabItems = tabBarController?.tabBar.items {
                // In this case we want tomodify the badge number of the third tab:
                let tabItem = tabItems[2]
                tabItem.badgeValue = nil
            }
            badgeCount.isHidden = true
        }
    }
    
    

    @IBAction func filterBtn(_ sender: Any) {
        filterView.isHidden = false
    }

    @IBAction func closeFiltersBtn(_ sender: Any) {
        filterView.isHidden = true
    }

    @IBAction func viewBtn(_ sender: Any) {
        if layoutChanged == false {
            layoutChanged = true

            productsCollectionView.reloadData()
            viewButton.setImage(UIImage(named: "grid"), for: .normal)

        } else {
            layoutChanged = false
            productsCollectionView.reloadData()
            viewButton.setImage(UIImage(systemName: "list.dash"), for: .normal)
        }
    }
    
    @IBAction func clearBtn(_ sender: Any) {
        
        if isSearchFilter == true {
            layoutChanged = false
            isSearchFilter = false
            isPriceFilter = false
            filteredProductDetails.removeAll()
            productsCollectionView.reloadData()
            UIView.transition(with: filterView, duration: 0.5, options: .curveEaseInOut, animations: {
                self.filterView.isHidden = true
            })
        } else {
            layoutChanged = false
            isPriceFilter = false
            isSearchFilter = false
            filteredProductDetails.removeAll()
            productsCollectionView.reloadData()
            UIView.transition(with: filterView, duration: 0.5, options: .curveEaseInOut, animations: {
                self.filterView.isHidden = true
            })
        }
        
    }
    
    
    // MARK: - TagListViewDelegate

    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender),\(sender.tag)")

        if tagView.isSelected == false {
            tagView.isSelected = !tagView.isSelected
            vendor = title
            for item in brandsProducts.products! {
                if vendor == item.vendor {
                    filteredProductDetails.append(item)
                }
            }
            isSearchFilter = true
            productsCollectionView.reloadData()
        } else {
            tagView.isSelected = false
            vendor = title
            if isSearchFilter == true {
                filteredArray.removeAll()
                for i in 0 ..< filteredProductDetails.count {
                    if vendor != filteredProductDetails[i].vendor {
                        filteredArray.append(filteredProductDetails[i])
                    } else {
                        if !(filteredArray.count > 0) {
                            filteredArray.removeAll()
                        }
                    }
                }

                print(filteredArray)
                if filteredArray.count > 0 {
                    filteredProductDetails.removeAll()
                    filteredProductDetails = filteredArray
                    productsCollectionView.reloadData()
                } else {
                    isSearchFilter = false
                    productsCollectionView.reloadData()
                    UIView.transition(with: filterView, duration: 0.5, options: .curveEaseInOut, animations: {
                        self.filterView.isHidden = true
                    })
                }
            }
        }
    }
    @IBAction func priceSlideBtn(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        minimumPriceFilterLabel.text = "Rs." + "\(currentValue)"

        
        if currentValue != 0 {
            isPriceFilter = true
            priceFilteredArray.removeAll()
            for i in brandsProducts.products! {
                let data = i.variants![0].price
                let itemPrice = Double(data ?? "")
                if currentValue > 0  {
                    if currentValue >= Int(itemPrice ?? 0){
                    priceFilteredArray.append(i)
                    }
                }
            }
           
            print("Price:", priceFilteredArray.count)
            self.totalProductCount.text = "\(priceFilteredArray.count) Products "
        } else {
            isPriceFilter = false
            self.totalProductCount.text = "\(brandsProducts.products!.count) Products"
            priceFilteredArray.removeAll()
        }
        
        productsCollectionView.reloadData()
    }


    // MARK: - GET BRANDS PRODUCTS API

    func getBrands(name: String) {
        DispatchQueue.main.async {
            
            self.animationView.isHidden = false
            self.animationView.image = UIImage.gif(name: "Shahalami_cart_loader")
        }
        if Reachability.isConnectedToNetwork() {   
            ServerManager.sharedInstance.getRequest(url: ServerManager.sharedInstance.BASE_URL + "products.json?published_status=published&limit=250&vendor=\(name)", completion: { js in
                print(js)
                self.getBrandsData(json: js)
            })
        } else {
            CommonMethods.doSomething(view: self) { [self] in
                self.getBrands(name: brandName ?? "")
            }
        }
    }

    func getBrandsData(json: AnyObject) {
        if json is [String: Any] {
            let js = Products(dictionary: json as! NSDictionary)
            brandsProducts = js
         
            DispatchQueue.main.async { [self] in
            if brandsProducts.products?.count ?? 0 > 0{
                self.productsCollectionView.isHidden = false
                self.noProductsLbl.isHidden = true
                self.animationView.isHidden = true
                self.totalProductCount.text = "\(brandsProducts.products!.count ) Products"
                productsCollectionView.delegate = self
                productsCollectionView.dataSource = self
                productsCollectionView.reloadData()
                self.tagListView.delegate = self

                self.filterArray.removeAll()
                for item in self.brandsProducts.products! {
                    self.filterArray.append(item.vendor!)
                }

                self.filterArray.removeDuplicates()
                print(self.filterArray)
                for item in self.filterArray {
                    self.tagListView.addTag(item)
                }
                
            }else{
                self.animationView.isHidden = true
                self.productsCollectionView.isHidden = true
                self.noProductsLbl.isHidden = false
                }
            }

        } else {
            
        }
    }

    // MARK: - WISHLIST API

    func getWishlistIDs() {
        let userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
        let param = [
            "user_id": "\(userInfo!.userID ?? 0)" as Any
        ] as [String: AnyObject]

        if Reachability.isConnectedToNetwork() {
            ServerManager.sharedInstance.postRequestNew(param: param, url: ServerManager.sharedInstance.exdURL + "viewUserProducts", fnToken: "") { js, _ in
                self.getWishlist(json: js)
            }
        } else {
            CommonMethods.doSomething(view: self) {
                self.getWishlistIDs()
            }
        }
    }

    func getWishlist(json: AnyObject) {
        if json is [String: Any] {
            let json = json as! [String: Any]
            guard json["product_ids"] as! String != "" else {
                return
            }

            wishlist_ids = json["product_ids"]! as? String
            wishlistIDs = wishlist_ids!.components(separatedBy: ",")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                if brandsProducts.products != nil {
                    self.productsCollectionView.delegate = self
                    self.productsCollectionView.dataSource = self
                    self.productsCollectionView.reloadData()

                    print("Wishlist")
                    print(wishlistIDs)
                }
            }

        } else {
            let message = json.value(forKey: "message")
            showMessage(message: message as? String)
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

    func removeWishlist(json: AnyObject) {
        if json is [String: Any] {
            let json = json as! [String: Any]
            if json["product_ids"]! as! String != "" {
                DispatchQueue.main.async { [self] in
                view.makeToast(AppTheme.sharedInstance.productRemovedFromWishlist)
                getWishlistIDs()
                }
            } else {
                view.makeToast(json["message"]! as? String)
            }

        } else {
            let message = json.value(forKey: "message")
            showMessage(message: message as? String)
        }
    }

    // MARK: - POPUP MESSAGES

    func showMessage(message: String?) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            alert.dismiss(animated: true) {
            }
        }))
        present(alert, animated: true, completion: nil)
    }
}
