//
//  ProductsViewController.swift
//  Shahalami.pk
//
//  Created by Ahmed Ayub on 22/10/2021.
//

import CDAlertView
import NVActivityIndicatorView
import SDWebImage
import TagListView
import Toast_Swift
import UIKit
class ProductsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TagListViewDelegate {
    var parentNavController: UINavigationController!

    // TagList
    @IBOutlet var tagListView: TagListView!

    // UICollectionView
    @IBOutlet var productsCollectionview: UICollectionView!

    // Outlets
   
    @IBOutlet var filtersView: UIView!
    @IBOutlet var viewButton: UIButton!
    @IBOutlet var minimumPriceFilterLabel: UILabel!
    @IBOutlet var animationView: UIImageView!
    @IBOutlet var totalProductsCountLbl: UILabel!
    
    
    @IBOutlet weak var noProductsLbl: UILabel!
    // Variables
    var wishlistIDs: [String] = []
    var wishlist_ids: String?
    var collectionViewHidden: Bool = false
    var layoutChanged: Bool = false
    var collectionID = ""
    var mainCollectionID = ""
    var variantIndex: Int = 0
    var productList = Products()
    var filteredArray = [Pro]()
    var priceFilteredArray = [Pro]()
    var filteredProductDetails = [Pro]()
    var filterArray: [String] = []
    var vendor: String = ""
    var isSearchFilter: Bool = false
    var isPriceFilter: Bool = false
    var selectedIndex: Int? = 0
    var i: Int = 0
    var didMove: Bool = false

    var pageIndex: Int = 0
    var strTitle: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.layoutIfNeeded()

        layoutSetting(productsCollectionview)

        print("selected\(selectedIndex)")

        // if selectedIndex == Int(collectionID){
        getProducts(collectID: collectionID)
        // }

//        if i > 0{
        //  getProducts(collectID: collectionID)
        // }

//        if didMove == true{
//        getProducts(collectID: collectionID)
//        }

        tagListView.textColor = #colorLiteral(red: 0.1686044633, green: 0.1686406434, blue: 0.1686021686, alpha: 1)
        productsCollectionview.reloadData()
        let nibName = UINib(nibName: "ProdoctsNewCollectionViewCell", bundle: nil)
        productsCollectionview.register(nibName, forCellWithReuseIdentifier: "cell")
    }

//
//    override func viewWillAppear(_ animated: Bool) {
//        if selectedIndex == Int(collectionID){
//        getProducts(collectID: collectionID)
//        }
//    }

    // MARK: - TagListViewDelegate

    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender),\(sender.tag)")

        if tagView.isSelected == false {
            tagView.isSelected = !tagView.isSelected
            vendor = title
            for item in productList.products! {
                if vendor == item.vendor {
                    filteredProductDetails.append(item)
                }
            }
            isSearchFilter = true
            productsCollectionview.reloadData()
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
                    productsCollectionview.reloadData()
                } else {
                    isSearchFilter = false
                    filteredProductDetails.removeAll()
                    productsCollectionview.reloadData()
                    UIView.transition(with: filtersView, duration: 0.5, options: .curveEaseInOut, animations: {
                        self.filtersView.isHidden = true
                    })
                }
            }
        }
    }

    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag Remove pressed: \(title), \(sender)")
        sender.removeTagView(tagView)
    }

//    @IBAction func clearFiltersBtn(_ sender: Any) {
//    //    if isSearchFilter == true {
//            layoutChanged = false
//       //     filters = false
//            isSearchFilter = false
//        isPriceFilter = false
//         //   topSellingVC = false
//           // searchArray.removeAll()
//            productsCollectionview.reloadData()
//            UIView.transition(with: filtersView, duration: 0.5, options: .curveEaseInOut, animations: {
//                self.filtersView.isHidden = true
//            })
//
//    }

    // MARK: - UICollectionViewDataSource protocol

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isPriceFilter == true {
            return priceFilteredArray.count
        } else
        if isSearchFilter == true {
            return filteredProductDetails.count
        } else {
            return productList.products!.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if layoutChanged == false {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemsCell", for: indexPath as IndexPath) as! ItemsCollectionViewCell
            cell.contentView.uiViewShadow()
            cell.cellView.layer.cornerRadius = 8
            if isPriceFilter == true {
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
                cell.addToCartButton.tag = indexPath.row
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
                cell.addToCartButton.addTarget(self, action: #selector(addToCartProducts(sender:)), for: .touchUpInside)
                cell.favouriteBtn.addTarget(self, action: #selector(unfavouritePressed(sender:)), for: .touchUpInside)

            } else
            if isSearchFilter == true {
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
                cell.addToCartButton.tag = indexPath.row
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
                cell.addToCartButton.addTarget(self, action: #selector(addToCartProducts(sender:)), for: .touchUpInside)
                cell.favouriteBtn.addTarget(self, action: #selector(unfavouritePressed(sender:)), for: .touchUpInside)

            } else {
                let data = productList.products![indexPath.row]

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
                cell.addToCartButton.tag = indexPath.row
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
                cell.addToCartButton.addTarget(self, action: #selector(addToCartProducts(sender:)), for: .touchUpInside)
                cell.favouriteBtn.addTarget(self, action: #selector(unfavouritePressed(sender:)), for: .touchUpInside)
            }
            return cell

        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! ProdoctsNewCollectionViewCell

            cell.cellView.addShadow(opacity: 0.4, cornerRadius: 8, shadowRadius: 4.0)

            if isPriceFilter == true {
                let data = priceFilteredArray[indexPath.row]

                cell.productNameLbl.text = data.title

                let image = data.images![0].src
                if image != nil {
                    cell.productIamgeView.sd_setImage(with: URL(string: image ?? ""), placeholderImage: UIImage(named: "ic_placeholder")) {
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
                var price = data.variants![0].price
                if let dotRange = price!.range(of: ".") {
                    price!.removeSubrange(dotRange.lowerBound ..< price!.endIndex)
                }
                let p = Int(price ?? "")
                cell.productPriceLbl.text = "Rs. \(p?.withCommas() ?? "")"
                cell.favouriteBtn.tag = indexPath.row
                cell.addToCartBtn.tag = indexPath.row
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

                cell.addToCartBtn.addTarget(self, action: #selector(addToCartProducts(sender:)), for: .touchUpInside)
                cell.favouriteBtn.addTarget(self, action: #selector(unfavouriteProdouctcollectionView(sender:)), for: .touchUpInside)
            } else
            if isSearchFilter == true {
                let data = filteredProductDetails[indexPath.row]

                cell.productNameLbl.text = data.title

                let image = data.images![0].src
                if image != nil {
                    cell.productIamgeView.sd_setImage(with: URL(string: image ?? ""), placeholderImage: UIImage(named: "ic_placeholder")) {
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
                var price = data.variants![0].price
                if let dotRange = price!.range(of: ".") {
                    price!.removeSubrange(dotRange.lowerBound ..< price!.endIndex)
                }
                let p = Int(price ?? "")
                cell.productPriceLbl.text = "Rs. \(p?.withCommas() ?? "")"
                cell.favouriteBtn.tag = indexPath.row
                cell.addToCartBtn.tag = indexPath.row
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

                cell.addToCartBtn.addTarget(self, action: #selector(addToCartProducts(sender:)), for: .touchUpInside)
                cell.favouriteBtn.addTarget(self, action: #selector(unfavouriteProdouctcollectionView(sender:)), for: .touchUpInside)
            } else {
                let data = productList.products![indexPath.row]

                cell.productNameLbl.text = data.title

                let image = data.images![0].src
                if image != nil {
                    cell.productIamgeView.sd_setImage(with: URL(string: image ?? ""), placeholderImage: UIImage(named: "ic_placeholder")) {
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
                var price = data.variants![0].price
                if let dotRange = price!.range(of: ".") {
                    price!.removeSubrange(dotRange.lowerBound ..< price!.endIndex)
                }
                let p = Int(price ?? "")
                cell.productPriceLbl.text = "Rs. \(p?.withCommas() ?? "")"
                cell.favouriteBtn.tag = indexPath.row
                cell.addToCartBtn.tag = indexPath.row
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

                cell.addToCartBtn.addTarget(self, action: #selector(addToCartProducts(sender:)), for: .touchUpInside)
                cell.favouriteBtn.addTarget(self, action: #selector(unfavouriteProdouctcollectionView(sender:)), for: .touchUpInside)
            }
            return cell
        }
    }

    // MARK: - UICollectionViewDelegate protocol

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isSearchFilter == true {
            let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailsViewController
            print("You selected cell #\(indexPath.row)!")
            cv.productDetails = filteredProductDetails[indexPath.row]
            navigationController?.pushViewController(cv, animated: true)
        } else if isPriceFilter == true {
            let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailsViewController
            print("You selected cell #\(indexPath.row)!")
            cv.productDetails = priceFilteredArray[indexPath.row]
            navigationController?.pushViewController(cv, animated: true)
        } else {
            let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailsViewController
            print("You selected cell #\(indexPath.row)!")
            cv.productDetails = productList.products![indexPath.row]
            navigationController?.pushViewController(cv, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if layoutChanged == false {
            return CGSize(width: view.frame.width * 0.45, height: view.frame.height * 0.35)
        } else {
            return CGSize(width: view.frame.width * 0.95, height: view.frame.height * 0.2)
        }
    }

    // MARK: - ADD TO CART

    @objc func addToCartProducts(sender: UIButton) {
        let buttonNumber = sender.tag
        setCartData(tagID: sender.tag)
        print(buttonNumber)
    }

    func setCartData(tagID: Int?) {
        
        if isPriceFilter == true{
            var userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
            let myVarinats = priceFilteredArray[tagID ?? 0].variants!
            let objVariant = myVarinats[variantIndex]

            if userInfo?.lineItems?.count == 1 {
                if userInfo?.lineItems?[0].title == "" || userInfo?.lineItems![0].title == nil {
                    userInfo?.lineItems![0].variant_id = Int(priceFilteredArray[tagID ?? 0].variants![0].id ?? "0")
                    userInfo?.lineItems![0].id = Int(priceFilteredArray[tagID ?? 0].id ?? "0")
                    userInfo?.lineItems![0].quantity = 1
                    userInfo?.lineItems![0].title = priceFilteredArray[tagID ?? 0].title
                    userInfo?.lineItems![0].image = priceFilteredArray[tagID ?? 0].image?.src
                    userInfo?.lineItems![0].price = Double(objVariant.price ?? "0")
                    userInfo?.lineItems![0].size = priceFilteredArray[tagID ?? 0].title
                    userInfo?.currencyCode = "PKR"
                    userInfo?.saveCurrentSession(forKey: USER_MODEL)
                    addBadgeCounter()

                } else {
                    addToCart(tagID: tagID ?? 0)
                }
            } else {
                addToCart(tagID: tagID ?? 0)
            }
        }else if isSearchFilter == true{
            var userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
            let myVarinats = filteredProductDetails[tagID ?? 0].variants!
            let objVariant = myVarinats[variantIndex]

            if userInfo?.lineItems?.count == 1 {
                if userInfo?.lineItems?[0].title == "" || userInfo?.lineItems![0].title == nil {
                    userInfo?.lineItems![0].variant_id = Int(filteredProductDetails[tagID ?? 0].variants![0].id ?? "0")
                    userInfo?.lineItems![0].id = Int(filteredProductDetails[tagID ?? 0].id ?? "0")
                    userInfo?.lineItems![0].quantity = 1
                    userInfo?.lineItems![0].title = filteredProductDetails[tagID ?? 0].title
                    userInfo?.lineItems![0].image = filteredProductDetails[tagID ?? 0].image?.src
                    userInfo?.lineItems![0].price = Double(objVariant.price ?? "0")
                    userInfo?.lineItems![0].size = filteredProductDetails[tagID ?? 0].title
                    userInfo?.currencyCode = "PKR"
                    userInfo?.saveCurrentSession(forKey: USER_MODEL)
                    addBadgeCounter()

                } else {
                    addToCart(tagID: tagID ?? 0)
                }
            } else {
                addToCart(tagID: tagID ?? 0)
            }
        }else{
        
        var userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
        let myVarinats = productList.products?[tagID ?? 0].variants!
        let objVariant = myVarinats?[variantIndex]

        if userInfo?.lineItems?.count == 1 {
            if userInfo?.lineItems?[0].title == "" || userInfo?.lineItems![0].title == nil {
                userInfo?.lineItems![0].variant_id = Int(productList.products?[tagID ?? 0].variants![0].id ?? "0")
                userInfo?.lineItems![0].id = Int(productList.products?[tagID ?? 0].id ?? "0")
                userInfo?.lineItems![0].quantity = 1
                userInfo?.lineItems![0].title = productList.products?[tagID ?? 0].title
                userInfo?.lineItems![0].image = productList.products?[tagID ?? 0].image?.src
                userInfo?.lineItems![0].price = Double(objVariant?.price ?? "0")
                userInfo?.lineItems![0].size = productList.products?[tagID ?? 0].title
                userInfo?.currencyCode = "PKR"
                userInfo?.saveCurrentSession(forKey: USER_MODEL)
                addBadgeCounter()

            } else {
                addToCart(tagID: tagID ?? 0)
            }
        } else {
            addToCart(tagID: tagID ?? 0)
        }
            
    }
//        badgeCount.text = "\((userInfo?.lineItems!.count)!)"
//        badgeCount.window?.isHidden = false
    }

    func addToCart(tagID: Int) {
        
        if isPriceFilter == true{
            var userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
            let myVarinats = priceFilteredArray[tagID].variants!
            let objVariant = myVarinats[variantIndex]
            for i in 0 ..< (userInfo?.lineItems!.count)! {
                let qty = 1
                let oldQty = (userInfo?.lineItems![i].quantity)!
                if userInfo?.lineItems![i].variant_id == Int(priceFilteredArray[tagID].variants![0].id ?? "0") {
                    userInfo?.lineItems![i].quantity = oldQty + qty
                    userInfo?.saveCurrentSession(forKey: USER_MODEL)
                    view.makeToast(AppTheme.sharedInstance.quantityAdded)
                    return
                }
            }
            var product: Item = Item()
            product.variant_id = Int(priceFilteredArray[tagID].variants![0].id ?? "0")
            product.quantity = 1
            product.id = Int(priceFilteredArray[tagID].id ?? "0")
            product.title = priceFilteredArray[tagID].title
            product.image = priceFilteredArray[tagID].image?.src
            product.price = Double(objVariant.price! )
            product.size = priceFilteredArray[tagID].title
            userInfo?.currencyCode = "PKR"
            userInfo?.lineItems?.append(product)
            userInfo?.currencyCode = "PKR"
            userInfo?.saveCurrentSession(forKey: USER_MODEL)

            addBadgeCounter()
            view.makeToast("Product added to cart")
            
        }else if isSearchFilter == true{
            
            var userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
            let myVarinats = filteredProductDetails[tagID].variants!
            let objVariant = myVarinats[variantIndex]
            for i in 0 ..< (userInfo?.lineItems!.count)! {
                let qty = 1
                let oldQty = (userInfo?.lineItems![i].quantity)!
                if userInfo?.lineItems![i].variant_id == Int(filteredProductDetails[tagID].variants![0].id ?? "0") {
                    userInfo?.lineItems![i].quantity = oldQty + qty
                    userInfo?.saveCurrentSession(forKey: USER_MODEL)
                    view.makeToast(AppTheme.sharedInstance.quantityAdded)
                    return
                }
            }
            var product: Item = Item()
            product.variant_id = Int(filteredProductDetails[tagID].variants![0].id ?? "0")
            product.quantity = 1
            product.id = Int(filteredProductDetails[tagID].id ?? "0")
            product.title = filteredProductDetails[tagID].title
            product.image = filteredProductDetails[tagID].image?.src
            product.price = Double(objVariant.price!)
            product.size = filteredProductDetails[tagID].title
            userInfo?.currencyCode = "PKR"
            userInfo?.lineItems?.append(product)
            userInfo?.currencyCode = "PKR"
            userInfo?.saveCurrentSession(forKey: USER_MODEL)

            addBadgeCounter()
            view.makeToast("Product added to cart")
        }
            else
        {
            
        var userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
        let myVarinats = productList.products?[tagID].variants!
        let objVariant = myVarinats?[variantIndex]
        for i in 0 ..< (userInfo?.lineItems!.count)! {
            let qty = 1
            let oldQty = (userInfo?.lineItems![i].quantity)!
            if userInfo?.lineItems![i].variant_id == Int(productList.products?[tagID].variants![0].id ?? "0") {
                userInfo?.lineItems![i].quantity = oldQty + qty
                userInfo?.saveCurrentSession(forKey: USER_MODEL)
                view.makeToast(AppTheme.sharedInstance.quantityAdded)
                return
            }
        }
        var product: Item = Item()
        product.variant_id = Int(productList.products?[tagID].variants![0].id ?? "0")
        product.quantity = 1
        product.id = Int(productList.products?[tagID].id ?? "0")
        product.title = productList.products?[tagID].title
        product.image = productList.products?[tagID].image?.src
        product.price = Double(objVariant?.price! ?? "0")
        product.size = productList.products?[tagID].title
        userInfo?.currencyCode = "PKR"
        userInfo?.lineItems?.append(product)
        userInfo?.currencyCode = "PKR"
        userInfo?.saveCurrentSession(forKey: USER_MODEL)

        addBadgeCounter()
        view.makeToast("Product added to cart")
        }
    }

    // MARK: - ADD OR REMOVE FAVOURITES

    @objc func unfavouritePressed(sender: UIButton) {
        let usertoken = AppUtility.sharedInstance.getUserData(forKey: USER_TOKEN_KEY)
        if usertoken != nil {
            let section = sender.tag / 100
            let item = sender.tag % 100
            let indexPath = IndexPath(item: item, section: section)

            let cell = productsCollectionview?.cellForItem(at: indexPath) as! ItemsCollectionViewCell

            let id = productList.products?[sender.tag].id

            if cell.favouriteBtn.isSelected {
                cell.favouriteBtn.isSelected = false
                cell.favouriteBtn.setImage(UIImage(named: "ic_unfavourite"), for: .normal)
                removeWishlistIDs(productID: id!)
            } else {
                cell.favouriteBtn.isSelected = true
                cell.favouriteBtn.setImage(UIImage(named: "ic_favourite"), for: .normal)
                addToWishlist(productID: id)
            }

        } else {
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

            let cell = productsCollectionview?.cellForItem(at: indexPath) as! ProdoctsNewCollectionViewCell
            let id = productList.products![sender.tag].id

            if cell.favouriteBtn.isSelected {
                cell.favouriteBtn.isSelected = false
                cell.favouriteBtn.setImage(UIImage(named: "ic_unfavourite"), for: .normal)
                removeWishlistIDs(productID: id!)
            } else {
                cell.favouriteBtn.isSelected = true
                cell.favouriteBtn.setImage(UIImage(named: "ic_favourite"), for: .normal)
                addToWishlist(productID: id)
            }
        } else {
            showMessage(message: "Please Login to add to wishlist.")
        }
        let buttonNumber = sender.tag
        print(buttonNumber)
        //  print(myarray)
    }

    // MARK: - Collection View Data Source

    fileprivate func layoutSetting(_ collection: UICollectionView) {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
        layout.itemSize = CGSize(width: view.frame.width * 0.45, height: view.frame.height * 0.35)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 12
        collection.collectionViewLayout = layout
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
            let tabItems = tabBarController?.tabBar.items

            let tabItem = tabItems?[2]
            tabItem?.badgeValue = badgeCount.text
            tabItem?.badgeColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
            badgeCount.text = tabItem?.badgeValue
            // }
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

    // MARK: - FILTERS

    @IBAction func viewBtn(_ sender: Any) {
        if layoutChanged == false {
            layoutChanged = true
            productsCollectionview.reloadData()
            viewButton.setImage(UIImage(named: "grid"), for: .normal)

        } else {
            layoutChanged = false
            productsCollectionview.reloadData()
            viewButton.setImage(UIImage(systemName: "list.dash"), for: .normal)
        }
    }

    @IBAction func filterBtn(_ sender: Any) {
        UIView.transition(with: filtersView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.filtersView.isHidden = false

        })
    }

    @IBAction func closeFilterViewBtn(_ sender: Any) {
        UIView.transition(with: filtersView, duration: 0.5, options: .curveEaseInOut, animations: {
            self.filtersView.isHidden = true
        })
    }

    @IBAction func priceSlideBtn(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        minimumPriceFilterLabel.text = "Rs." + "\(currentValue)"

        if isSearchFilter == true {
            if currentValue != 0 {
                isPriceFilter = true
                priceFilteredArray.removeAll()
                for i in filteredProductDetails {
                    let data = i.variants![0].price
                    let itemPrice = Double(data ?? "")
                    if currentValue > 0 {
                        if currentValue >= Int(itemPrice ?? 0) {
                            priceFilteredArray.append(i)
                        }
                    }
                }
                print("Price:", priceFilteredArray.count)
                totalProductsCountLbl.text = "\(priceFilteredArray.count) Products"
            } else {
                isPriceFilter = false
                totalProductsCountLbl.text = "\(productList.products!.count) Products"
                priceFilteredArray.removeAll()
            }

            productsCollectionview.reloadData()

        } else {
            if currentValue != 0 {
                isPriceFilter = true
                priceFilteredArray.removeAll()
                for i in productList.products! {
                    let data = i.variants![0].price
                    let itemPrice = Double(data ?? "")
                    if currentValue > 0 {
                        if currentValue >= Int(itemPrice ?? 0) {
                            priceFilteredArray.append(i)
                        }
                    }
                }
                print("Price:", priceFilteredArray.count)
                totalProductsCountLbl.text = "\(priceFilteredArray.count) Products "
            } else {
                isPriceFilter = false
                totalProductsCountLbl.text = "\(productList.products!.count) Products"
                priceFilteredArray.removeAll()
            }

            productsCollectionview.reloadData()
        }
    }

    // MARK: - GET PRODUCTS API

    func getProducts(collectID: String) {
        animationView.isHidden = false
        animationView.image = UIImage.gif(name: "Shahalami_cart_loader")

        print(mainCollectionID)
        print(collectID)
        if collectID == "0" {
            print("Entered 0")
            ServerManager.sharedInstance.getRequest(url: ServerManager.sharedInstance.BASE_URL + "products.json?collection_id=\(mainCollectionID)&published_status=published&limit=250", completion: { js in
                print("Finished 0")
                self.getProductsData(json: js)
            })

        } else {
            print("Entered 1")

            ServerManager.sharedInstance.getRequest(url: ServerManager.sharedInstance.BASE_URL + "products.json?collection_id=\(collectID)&published_status=published&limit=250", completion: { js in
                print("Finished 1")

                self.getProductsData(json: js)
            })
        }
    }

    fileprivate func getProductsData(json: AnyObject) {
        if json is [String: Any] {
            // productList = []

            do {
                autoreleasepool {
                    let json = json as! [String: Any]
                    let productsModel = Products(dictionary: json as NSDictionary)
                    productList = productsModel
                }

                guard productList.products != nil else {
                    return
                }
                print(productList.products!.count as Any)
                DispatchQueue.main.async { [self] in
                if productList.products?.count ?? 0 > 0{
                    self.noProductsLbl.isHidden = true
                    self.productsCollectionview.isHidden = false
                
                    self.totalProductsCountLbl.text = "\(productList.products!.count) Products"
                    self.animationView.isHidden = true
                    self.productsCollectionview.delegate = self
                    self.productsCollectionview.dataSource = self
                    self.productsCollectionview.reloadData()

                    self.tagListView.delegate = self

                    self.filterArray.removeAll()
                    for item in self.productList.products! {
                        self.filterArray.append(item.vendor!)
                    }

                    self.filterArray.removeDuplicates()
                    print(self.filterArray)
                    for item in self.filterArray {
                        self.tagListView.addTag(item)
                    }
                    let usertoken = AppUtility.sharedInstance.getUserData(forKey: USER_TOKEN_KEY)
                    if usertoken != nil {
                        getWishlistIDs()
                    }
                
                }else{
                    self.animationView.isHidden = true
                    self.noProductsLbl.isHidden = false
                    self.productsCollectionview.isHidden = true
                    
                }
            }
            } catch let error {
                print(error)
                DispatchQueue.main.async {
                    self.animationView.isHidden = true
                }
                let message = json.value(forKey: "message") as! String
                self.showErrorMessage(message: message)
            }

        } else {
            DispatchQueue.main.async {
                self.animationView.isHidden = true
            }
            let message = json.value(forKey: "message") as! String
            showErrorMessage(message: message)
        }
    }

    func showErrorMessage(message: String) {
        let alert = CDAlertView(title: "Customer Login", message: message, type: .warning)
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

    // MARK: - WISHLIST API

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
                            if productList.products != nil {
                                self.productsCollectionview.delegate = self
                                self.productsCollectionview.dataSource = self
                                self.productsCollectionview.reloadData()

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

//    func getWishlistIDs() {
//        // self.activityView.startAnimating()
//
//        let userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
//        let param = [
//            "user_id": "\(userInfo!.userID ?? 0)" as Any,
//        ] as [String: AnyObject]
//
//        if Reachability.isConnectedToNetwork() {
//            ServerManager.sharedInstance.postRequestNew(param: param, url: ServerManager.sharedInstance.exdURL + "viewUserProducts", fnToken: "") { js, _ in
//                self.getWishlist(json: js)
//            }
//        } else {
//            CommonMethods.doSomething(view: self) {
//                self.getWishlistIDs()
//            }
//        }
//    }
//
//    fileprivate func getWishlist(json: AnyObject) {
//        if json is [String: Any] {
//            do {
//                let json = json as! [String: Any]
//                guard json != nil else {
//                    return
//                }
//
    ////                guard json["product_ids"] as! String != "" else {
    ////                    return
    ////                }
//
//
//                DispatchQueue.main.async { [self] in
//                    wishlist_ids = json["product_ids"]! as? String
//                    wishlistIDs = wishlist_ids!.components(separatedBy: ",")
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                        if productList.products != nil {
//                            self.productsCollectionview.delegate = self
//                            self.productsCollectionview.dataSource = self
//                            self.productsCollectionview.reloadData()
//
//                            print("Wishlist")
//                            print(wishlistIDs)
//                        }
//                    }
//                }
//
//            } catch let error {
//                print(error)
//                DispatchQueue.main.async {
//                    // self.alert.hide(isPopupAnimated: true)
//                }
//            }
//
//        } else {
//            DispatchQueue.main.async {
//                //  self.activityView.stopAnimating()
//                // self.alert.hide(isPopupAnimated: true)
//            }
//        }
//    }

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

    func showMessage(message: String?) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            alert.dismiss(animated: true) {
            }
        }))
        present(alert, animated: true, completion: nil)
    }
}
