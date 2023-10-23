//
//  ViewAllProductsViewController.swift
//  Shahalami.pk
//
//  Created by Ahmed on 18/11/2021.
//

import CDAlertView
import ImageSlideshow
import NVActivityIndicatorView
import Reachability
import SwiftGifOrigin
import TagListView
import Toast_Swift
import UIKit
import ViewAnimator

class ViewAllProductsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TagListViewDelegate {
    @IBOutlet var totalProductLbl: UILabel!

    // TagList
    @IBOutlet var tagListView: TagListView!

    // UICollectionView
    @IBOutlet var productsCollectionview: UICollectionView!

//    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var filtersButton: UIButton!
    @IBOutlet weak var viewRightConstraint: NSLayoutConstraint!
    // Outlets

    @IBOutlet var loadingUIView: UIView!

    @IBOutlet var animationView: UIImageView!

    @IBOutlet var btnBack: UIBarButtonItem!
    @IBOutlet var filtersView: UIView!
    @IBOutlet private var tagsLabel: UILabel!
    @IBOutlet var viewButton: UIButton!
    @IBOutlet var minimumPriceFilterLabel: UILabel!

    // Variables
    // Bool

    var variantIndex: Int = 0
    var vendor: String?
    var wishlist_ids: String?
    var collectionID: String?
    var wishlistIDs: [String] = []
    var filterArray: [String] = []

    var filters: Bool = false
    var isPriceFilter: Bool = false
    var isSearchPriceFilter:Bool = false
    var topSellingVC: Bool = false
    var searchResults: Bool = false
    var layoutChanged: Bool = false
    var isSearchFilter: Bool = false
    var isProductByCategory: Bool = false
    var collectionViewHidden: Bool = false

    var filteredArray = [Pro]()
    var priceFilteredArray = [Pro]()
    var searchArray = [Poducts]()
    var filteredSearch = [Poducts]()
    var searchProducts : [SearchProducts]?
    var priceSearchFilter = [Pro]()
    var productByCategory = Products()
    var productDetails = Products()
    var filteredProductDetails = [Pro]()
    var collectionList = SearchedProduct()

    private let animate = [AnimationType.from(direction: .bottom, offset: 300)]
    let alert = CDAlertView(title: "Network Error", message: "Please connect to the internet", type: .warning)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        view.layoutIfNeeded()

        layoutSetting(productsCollectionview)

        tagListView.delegate = self

        if isProductByCategory == false {
            productsCollectionview.delegate = self
            productsCollectionview.dataSource = self
            if topSellingVC == true { // for new and top products
                for item in productDetails.products! {
                    filterArray.append(item.vendor!)
                }

                filterArray.removeDuplicates()
                print(filterArray)

                for item in filterArray {
                    tagListView.addTag(item)
                }

            } else { // for searched products
                self.viewRightConstraint.constant = 8
                self.filtersButton.isHidden = true
                for item in searchProducts! {
                    filterArray.append(item.vendor!)
                }
                filterArray.removeDuplicates()
                print(filterArray)

                for item in filterArray {
                    tagListView.addTag(item)
                }
            }
        } else {
            getProducts(collectionID: collectionID!)
        }
        tagListView.textColor = #colorLiteral(red: 0.1686044633, green: 0.1686406434, blue: 0.1686021686, alpha: 1)

        let nibName = UINib(nibName: "ProdoctsNewCollectionViewCell", bundle: nil)

        productsCollectionview.register(nibName, forCellWithReuseIdentifier: "cell")
        if topSellingVC == true {
            totalProductLbl.text = "\(productDetails.products?.count ?? 0) Products"

        } else {
            totalProductLbl.text = "\(searchProducts?.count ?? 0) Products"
        }

        productsCollectionview?.performBatchUpdates({
            UIView.animate(views: self.productsCollectionview!.orderedVisibleCells,
                           animations: self.animate, completion: {
                           })
        }, completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        let usertoken = AppUtility.sharedInstance.getUserData(forKey: USER_TOKEN_KEY)
        if usertoken != nil {
            getWishlistIDs()
        }
        // addBadgeCounter()
    }

    // MARK: - TagListViewDelegate

    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender),\(sender.tag)")

        if tagView.isSelected == false {
            tagView.isSelected = !tagView.isSelected
            vendor = title
            
            if isProductByCategory == true{
                for item in productByCategory.products! {
                    if vendor == item.vendor {
                        filteredProductDetails.append(item)
                    }
                }
                filters = true
                isSearchFilter = false
                topSellingVC = false
             //   isProductByCategory = false
            }else
            if topSellingVC == true {
                if isPriceFilter == true {
                    for item in priceFilteredArray {
                        if vendor == item.vendor {
                            filteredProductDetails.append(item)
                        }
                    }
                }else{
                    for item in productDetails.products! {
                        if vendor == item.vendor {
                            filteredProductDetails.append(item)
                        }
                    }
                    filters = true
                    isSearchFilter = false
                    topSellingVC = false
                    isProductByCategory = false
                    
                }
            } else if searchResults != true {
                for item in productDetails.products! {
                    if vendor == item.vendor {
                        filteredProductDetails.append(item)
                    }
                }
                filters = true
                isSearchFilter = false
                topSellingVC = false
            } else {
                for i in 0 ..< searchProducts!.count {
                    if vendor == searchProducts![i].vendor {
                       // searchArray.append(searchProducts![i])
                    }
                }
                filters = false
                isSearchFilter = true
                topSellingVC = false
            }

            searchArray.removeDuplicates()
            filteredProductDetails.removeDuplicates()
            print(searchArray)
            print(filteredProductDetails)

            productsCollectionview.delegate = self
            productsCollectionview.dataSource = self
            productsCollectionview.reloadData()
        } else {
            tagView.isSelected = false
            vendor = title
            
            if isProductByCategory == true{
                
                filteredArray.removeAll()
                for i in 0 ..< filteredProductDetails.count {
                    if vendor != filteredProductDetails[i].vendor {
                        filteredArray.append(filteredProductDetails[i])

                    } else {
                        if filteredProductDetails.count == 1 {
                            filteredArray.removeAll()
                        }
                    }
                }

                print(filteredArray)

                filteredProductDetails.removeAll()
                filteredProductDetails = filteredArray
           
                
                
            }else if isSearchFilter != true {
                filteredArray.removeAll()
                for i in 0 ..< filteredProductDetails.count {
                    if vendor != filteredProductDetails[i].vendor {
                        filteredArray.append(filteredProductDetails[i])

                    } else {
                        if filteredProductDetails.count == 1 {
                            filteredArray.removeAll()
                        }
                    }
                }

                print(filteredArray)

                filteredProductDetails.removeAll()
                filteredProductDetails = filteredArray
            } else {
                filteredSearch.removeAll()
                for i in 0 ..< searchArray.count {
                    if vendor != searchArray[i].vendor {
                        filteredSearch.append(searchArray[i])

                    } else {
                        if searchProducts!.count == 1 {
                            filteredSearch.removeAll()
                        }
                    }
                }

                print(filteredSearch)
                searchArray.removeAll()
                searchArray = filteredSearch
            }
            
            if filteredProductDetails.count > 0 {
                if isSearchFilter != true {
                    filters = true
                    topSellingVC = false
                    
                    print(filteredProductDetails)
                    productsCollectionview.delegate = self
                    productsCollectionview.dataSource = self
                    productsCollectionview.reloadData()

                } else {
                    filters = false
                    topSellingVC = false
                    isSearchFilter = false
                    print(filteredProductDetails)
                    productsCollectionview.delegate = self
                    productsCollectionview.dataSource = self
                    productsCollectionview.reloadData()
                }

            } else if searchArray.count > 0 {
                filters = false
                isSearchFilter = true
                topSellingVC = false
                print(searchArray)

                productsCollectionview.delegate = self
                productsCollectionview.dataSource = self
                productsCollectionview.reloadData()
            } else if isProductByCategory == true{
                layoutChanged = false
                filters = false
                topSellingVC = false
                filteredProductDetails.removeAll()
                productsCollectionview.reloadData()
                UIView.transition(with: filtersView, duration: 0.5, options: .curveEaseInOut, animations: {
                    self.filtersView.isHidden = true
                })
            }else{
                if isSearchFilter == true {
                    layoutChanged = false
                    filters = false
                    isSearchFilter = false
                    topSellingVC = false
                    searchArray.removeAll()
                    productsCollectionview.reloadData()
                    UIView.transition(with: filtersView, duration: 0.5, options: .curveEaseInOut, animations: {
                        self.filtersView.isHidden = true
                    })
                } else {
                    layoutChanged = false
                    filters = false
                    topSellingVC = true
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

    // MARK: - UICollectionViewDataSource protocol

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if filters == true {
            return filteredProductDetails.count
        } else if isPriceFilter == true {
            return priceFilteredArray.count
        } else if topSellingVC == true {
            return productDetails.products!.count
        } else  if isSearchFilter == true {
            return searchArray.count
        } else if isProductByCategory == true {
            return productByCategory.products!.count
        } else if isSearchPriceFilter == true{
            return priceSearchFilter.count
        }else { return searchProducts!.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if layoutChanged == false {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemsCell", for: indexPath as IndexPath) as! ViewAllProductCollectionViewCell

            cell.contentView.uiViewShadow()
            cell.cellView.layer.cornerRadius = 8

            if topSellingVC == true {
                if isPriceFilter == true {
                    let data = priceFilteredArray[indexPath.row]

                    if data.image != nil {
                        cell.producImages.sd_setImage(with: URL(string: data.image!.src ?? ""), placeholderImage: UIImage(named: "ic_placeholder")) {
                            image, error, _, _ in
                            // your code
                            if error == nil {
                                cell.producImages.contentMode = .scaleAspectFit
                            } else {
                                cell.producImages.contentMode = .scaleAspectFit
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
                    cell.addToCartButton.tag = indexPath.row
                    cell.addToCartButton.addTarget(self, action: #selector(addToCartProducts(sender:)), for: .touchUpInside)
                    cell.favouriteBtn.addTarget(self, action: #selector(unfavouritePressed(sender:)), for: .touchUpInside)
                } else {
                    let data = productDetails.products![indexPath.row]

                    if data.image != nil {
                        cell.producImages.sd_setImage(with: URL(string: data.image!.src ?? ""), placeholderImage: UIImage(named: "ic_placeholder")) {
                            image, error, _, _ in
                            // your code
                            if error == nil {
                                cell.producImages.contentMode = .scaleAspectFit
                            } else {
                                cell.producImages.contentMode = .scaleAspectFit
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
                    cell.addToCartButton.tag = indexPath.row
                    cell.addToCartButton.addTarget(self, action: #selector(addToCartProducts(sender:)), for: .touchUpInside)
                    cell.favouriteBtn.addTarget(self, action: #selector(unfavouritePressed(sender:)), for: .touchUpInside)
                }
            } else if filters == true {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemsCell", for: indexPath as IndexPath) as! ViewAllProductCollectionViewCell

                cell.contentView.uiViewShadow()
                cell.cellView.layer.cornerRadius = 8

                let data = filteredProductDetails[indexPath.row]

                if data.image != nil {
                    cell.producImages.sd_setImage(with: URL(string: data.image!.src ?? ""), placeholderImage: UIImage(named: "ic_placeholder")) {
                        image, error, _, _ in
                        // your code
                        if error == nil {
                            cell.producImages.contentMode = .scaleAspectFit
                        } else {
                            cell.producImages.contentMode = .scaleAspectFit
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

                return cell
            } else if isSearchFilter == true {
                let data = searchArray[indexPath.row]

                if data.image != nil {
                    cell.producImages.sd_setImage(with: URL(string: data.image ?? ""), placeholderImage: UIImage(named: "ic_placeholder")) {
                        image, error, _, _ in
                        // your code
                        if error == nil {
                            cell.producImages.contentMode = .scaleAspectFit
                        } else {
                            cell.producImages.contentMode = .scaleAspectFit
                        }
                        print(image ?? "")
                    }
                }

                cell.productNameLbl.text = data.title!
                var price = data.price
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

                cell.favouriteBtn.addTarget(self, action: #selector(unfavouritePressed(sender:)), for: .touchUpInside)

            } else if isProductByCategory == true {
                
                if isPriceFilter == true{
                    let data = priceFilteredArray[indexPath.row]

                    if data.image?.src != nil {
                        cell.producImages.sd_setImage(with: URL(string: data.image?.src ?? ""), placeholderImage: UIImage(named: "ic_placeholder")) {
                            image, error, _, _ in
                            // your code
                            if error == nil {
                                cell.producImages.contentMode = .scaleAspectFit
                            } else {
                                cell.producImages.contentMode = .scaleAspectFit
                            }
                            print(image ?? "")
                        }
                    }
                    cell.addToCartButton.tag = indexPath.row
                    cell.addToCartButton.addTarget(self, action: #selector(addToCartProducts(sender:)), for: .touchUpInside)
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

                    cell.favouriteBtn.addTarget(self, action: #selector(unfavouritePressed(sender:)), for: .touchUpInside)
                }else{
                let data = productByCategory.products![indexPath.row]

                if data.image?.src != nil {
                    cell.producImages.sd_setImage(with: URL(string: data.image?.src ?? ""), placeholderImage: UIImage(named: "ic_placeholder")) {
                        image, error, _, _ in
                        // your code
                        if error == nil {
                            cell.producImages.contentMode = .scaleAspectFit
                        } else {
                            cell.producImages.contentMode = .scaleAspectFit
                        }
                        print(image ?? "")
                    }
                }
                cell.addToCartButton.tag = indexPath.row
                cell.addToCartButton.addTarget(self, action: #selector(addToCartProducts(sender:)), for: .touchUpInside)
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

                cell.favouriteBtn.addTarget(self, action: #selector(unfavouritePressed(sender:)), for: .touchUpInside)
                }
            } else {
                if isSearchPriceFilter == true{
                    let data = priceSearchFilter[indexPath.row]

                    if data.image != nil {
                        cell.producImages.sd_setImage(with: URL(string: data.image?.src ?? ""), placeholderImage: UIImage(named: "ic_placeholder")) {
                            image, error, _, _ in
                            // your code
                            if error == nil {
                                cell.producImages.contentMode = .scaleAspectFit
                            } else {
                                cell.producImages.contentMode = .scaleAspectFit
                            }
                            print(image ?? "")
                        }
                    }
                    cell.addToCartButton.setTitle("View Details", for: .normal)
                    // cell.addToCartButton.setTitle("View", for: .normal)
                    cell.addToCartButton.addTarget(self, action: #selector(viewDetails(sender:)), for: .touchUpInside)
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

                    cell.favouriteBtn.addTarget(self, action: #selector(unfavouritePressed(sender:)), for: .touchUpInside)
                }else{
                    let data = searchProducts![indexPath.row]

                    if data.image != nil {
                        cell.producImages.sd_setImage(with: URL(string: data.image ?? ""), placeholderImage: UIImage(named: "ic_placeholder")) {
                            image, error, _, _ in
                            // your code
                            if error == nil {
                                cell.producImages.contentMode = .scaleAspectFit
                            } else {
                                cell.producImages.contentMode = .scaleAspectFit
                            }
                            print(image ?? "")
                        }
                    }
                    cell.addToCartButton.setTitle("View Details", for: .normal)
                    
                    cell.productNameLbl.text = data.title!
                    var price = data.price
                    if let dotRange = price!.range(of: ".") {
                        price!.removeSubrange(dotRange.lowerBound ..< price!.endIndex)
                    }
                    let p = Int(price ?? "")
                    cell.productPriceLbl.text = "Rs. \(p?.withCommas() ?? "")"
                    cell.favouriteBtn.tag = indexPath.row
                    cell.addToCartButton.tag = indexPath.row
                    for id in wishlistIDs {
                        if id == "\(data.id!)" {
                            cell.favouriteBtn.isSelected = true
                            cell.favouriteBtn.setImage(UIImage(named: "ic_favourite"), for: .normal)
                            break
                        } else {
                            cell.favouriteBtn.isSelected = false
                            cell.favouriteBtn.setImage(UIImage(named: "ic_unfavourite"), for: .normal)
                        }
                    }
                    cell.addToCartButton.addTarget(self, action: #selector(viewDetails(sender:)), for: .touchUpInside)
                    cell.favouriteBtn.addTarget(self, action: #selector(unfavouritePressed(sender:)), for: .touchUpInside)
                }
               
            }

            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! ProdoctsNewCollectionViewCell

            cell.cellView.addShadow(opacity: 0.4, cornerRadius: 8, shadowRadius: 4.0)

            if topSellingVC == true {
                if isPriceFilter == true {
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
                }else{
                let data = productDetails.products![indexPath.row]

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
            } else if filters == true {
                
                
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

            } else if isSearchFilter == true {
                let data = searchArray[indexPath.row]

                if data.image != nil {
                    cell.productIamgeView.sd_setImage(with: URL(string: data.image!), placeholderImage: UIImage(named: "ic_placeholder")) {
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
                var price = data.price
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

                cell.favouriteBtn.addTarget(self, action: #selector(unfavouriteProdouctcollectionView(sender:)), for: .touchUpInside)
            } else
            if isProductByCategory == true {
                
                if isPriceFilter == true{
                    let data = priceFilteredArray[indexPath.row]

                    if data.image?.src != nil {
                        cell.productIamgeView.sd_setImage(with: URL(string: data.image?.src ?? ""), placeholderImage: UIImage(named: "ic_placeholder")) {
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

                    cell.addToCartBtn.tag = indexPath.row
                    cell.addToCartBtn.addTarget(self, action: #selector(addToCartProducts(sender:)), for: .touchUpInside)
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

                    cell.favouriteBtn.addTarget(self, action: #selector(unfavouriteProdouctcollectionView(sender:)), for: .touchUpInside)
                }else{
                
                let data = productByCategory.products![indexPath.row]
                if data.image?.src != nil {
                    cell.productIamgeView.sd_setImage(with: URL(string: data.image?.src ?? ""), placeholderImage: UIImage(named: "ic_placeholder")) {
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

                cell.addToCartBtn.tag = indexPath.row
                cell.addToCartBtn.addTarget(self, action: #selector(addToCartProducts(sender:)), for: .touchUpInside)
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

                cell.favouriteBtn.addTarget(self, action: #selector(unfavouriteProdouctcollectionView(sender:)), for: .touchUpInside)
                }
            }else
             {
                
                if isSearchPriceFilter == true{
                    
                    let data = priceSearchFilter[indexPath.row]

                    if data.image != nil {
                        cell.productIamgeView.sd_setImage(with: URL(string: data.image?.src ?? ""), placeholderImage: UIImage(named: "ic_placeholder")) {
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
                    cell.addToCartBtn.setTitle("View Details", for: .normal)
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

                    cell.favouriteBtn.addTarget(self, action: #selector(unfavouriteProdouctcollectionView(sender:)), for: .touchUpInside)
                }else{
                    
                    let data = searchProducts![indexPath.row]

                    if data.image != nil {
                        cell.productIamgeView.sd_setImage(with: URL(string: data.image ?? ""), placeholderImage: UIImage(named: "ic_placeholder")) {
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
                    cell.addToCartBtn.setTitle("View Details", for: .normal)
                    cell.productNameLbl.text = data.title!
                    var price = data.price
                    if let dotRange = price!.range(of: ".") {
                        price!.removeSubrange(dotRange.lowerBound ..< price!.endIndex)
                    }
                    let p = Int(price ?? "")
                    cell.productPriceLbl.text = "Rs. \(p?.withCommas() ?? "")"
                    cell.favouriteBtn.tag = indexPath.row
                    cell.addToCartBtn.tag = indexPath.row
                    for id in wishlistIDs {
                        if id == "\(data.id)" {
                            cell.favouriteBtn.isSelected = true
                            cell.favouriteBtn.setImage(UIImage(named: "ic_favourite"), for: .normal)
                            break
                        } else {
                            cell.favouriteBtn.isSelected = false
                            cell.favouriteBtn.setImage(UIImage(named: "ic_unfavourite"), for: .normal)
                        }
                    }
                    cell.addToCartBtn.addTarget(self, action: #selector(viewDetails(sender:)), for: .touchUpInside)
                    cell.favouriteBtn.addTarget(self, action: #selector(unfavouriteProdouctcollectionView(sender:)), for: .touchUpInside)
                }
              
            }

            return cell
        }
    }

    // MARK: - UICollectionViewDelegate protocol

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if searchResults == true {
            loadingUIView.isHidden = false
            DispatchQueue.main.async {
                self.animationView.image = UIImage.gif(name: "Shahalami_cart_loader")
            }
            
            getProduct(productID: "\(searchProducts![indexPath.row].id!)")

        } else if isProductByCategory == true {
            DispatchQueue.main.async { [self] in
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailsViewController
                if filters == true{
                    vc.productDetails = filteredProductDetails[indexPath.row]
                }else if isPriceFilter == true{
                    vc.productDetails = priceFilteredArray[indexPath.row]
                }else{
                vc.productDetails = productByCategory.products![indexPath.row]
                }
                print("You selected cell #\(indexPath.row)!")
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            DispatchQueue.main.async { [self] in
                let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailsViewController
                cv.productDetails = productDetails.products![indexPath.row]
                print("You selected cell #\(indexPath.row)!")
                self.navigationController?.pushViewController(cv, animated: true)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if layoutChanged == false {
            //
            //
            return CGSize(width: view.frame.width * 0.45, height: view.frame.height * 0.35)
        } else {
            return CGSize(width: view.frame.width * 0.95, height: view.frame.height * 0.2)
        }
    }
    
    
    @objc func viewDetails(sender: UIButton) {
        let section = sender.tag / 100
        let item = sender.tag % 100
        let indexPath = IndexPath(item: item, section: section)
        if layoutChanged == false{
        let cell = productsCollectionview?.cellForItem(at: indexPath) as! ViewAllProductCollectionViewCell
            
            loadingUIView.isHidden = false
            DispatchQueue.main.async {
                self.animationView.image = UIImage.gif(name: "Shahalami_cart_loader")
            }
            getProduct(productID: "\(searchProducts![sender.tag].id!)")
        }else{
            let cell = productsCollectionview?.cellForItem(at: indexPath) as! ProdoctsNewCollectionViewCell
            loadingUIView.isHidden = false
            DispatchQueue.main.async {
                self.animationView.image = UIImage.gif(name: "Shahalami_cart_loader")
            }
            getProduct(productID: "\(searchProducts![sender.tag].id!)")
        }
    }

    // MARK: - ADD OR REMOVE FAVOURITES

    
    
    @objc func unfavouritePressed(sender: UIButton) {
        let usertoken = AppUtility.sharedInstance.getUserData(forKey: USER_TOKEN_KEY)
        if usertoken != nil {
            let section = sender.tag / 100
            let item = sender.tag % 100
            let indexPath = IndexPath(item: item, section: section)

            let cell = productsCollectionview?.cellForItem(at: indexPath) as! ViewAllProductCollectionViewCell
            var id: String?

            if topSellingVC == true {
                id = productDetails.products?[sender.tag].id
            } else
            if isProductByCategory == true {
                id = productByCategory.products?[sender.tag].id
            } else
            if filters == true {
                id = filteredProductDetails[sender.tag].id
            } else
            if isSearchFilter == true {
                id = searchArray[sender.tag].id
            } else if isSearchPriceFilter == true{
                id = priceSearchFilter[sender.tag].id
            }else {
                id = "\(searchProducts![sender.tag].id)"
            }

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
            var id: String?

            if topSellingVC == true {
                id = productDetails.products?[sender.tag].id
            } else
            if isProductByCategory == true {
                id = productByCategory.products?[sender.tag].id
            } else
            if filters == true {
                id = filteredProductDetails[sender.tag].id
            } else
            if isSearchFilter == true {
                id = searchArray[sender.tag].id
            } else {
                id = "\(searchProducts![sender.tag].id)"
            }

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

    // MARK: - ADD TO CART
//
//    @objc func addToCartBrandProducts(sender: UIButton) {
//        let buttonNumber = sender.tag
//        setBrandProductsCartData(tagID: sender.tag)
//        print(buttonNumber)
//    }
//
//    func setBrandProductsCartData(tagID: Int?) {
//        var userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
//
//
//
//        let myVarinats = productByCategory.products?[tagID ?? 0].variants!
//        let objVariant = myVarinats?[variantIndex]
//
//        if userInfo?.lineItems?.count == 1 {
//            if userInfo?.lineItems?[0].title == "" || userInfo?.lineItems![0].title == nil {
//                userInfo?.lineItems![0].variant_id = Int(productByCategory.products?[tagID ?? 0].variants![0].id ?? "0")
//                userInfo?.lineItems![0].id = Int(productByCategory.products?[tagID ?? 0].id ?? "0")
//                userInfo?.lineItems![0].quantity = 1
//                userInfo?.lineItems![0].title = productByCategory.products?[tagID ?? 0].title
//                userInfo?.lineItems![0].image = productByCategory.products?[tagID ?? 0].image?.src
//                userInfo?.lineItems![0].price = Double(objVariant?.price ?? "0")
//                userInfo?.lineItems![0].size = productByCategory.products?[tagID ?? 0].title
//                userInfo?.currencyCode = "PKR"
//                userInfo?.saveCurrentSession(forKey: USER_MODEL)
//                addBadgeCounter()
//                view.makeToast("Product added to cart")
//            } else {
//                addToCartBrand(tagID: tagID ?? 0)
//            }
//        } else {
//            addToCartBrand(tagID: tagID ?? 0)
//        }
//        badgeCount.text = "\((userInfo?.lineItems!.count)!)"
//        badgeCount.isHidden = false
//    }
//
//    func addToCartBrand(tagID: Int) {
//        var userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
//        let myVarinats = productByCategory.products?[tagID].variants!
//        let objVariant = myVarinats?[variantIndex]
//        for i in 0 ..< (userInfo?.lineItems!.count)! {
//            let qty = 1
//            let oldQty = (userInfo?.lineItems![i].quantity)!
//            if userInfo?.lineItems![i].variant_id == Int(productByCategory.products?[tagID].variants![0].id ?? "0") {
//                userInfo?.lineItems![i].quantity = oldQty + qty
//                userInfo?.saveCurrentSession(forKey: USER_MODEL)
//                view.makeToast(AppTheme.sharedInstance.quantityAdded)
//                return
//            }
//        }
//        var product: Item = Item()
//        product.variant_id = Int(productByCategory.products?[tagID].variants![0].id ?? "0")
//        product.quantity = 1
//        product.id = Int(productByCategory.products?[tagID].id ?? "0")
//        product.title = productByCategory.products?[tagID].title
//        product.image = productByCategory.products?[tagID].image?.src
//        product.price = Double(objVariant?.price! ?? "0")
//        product.size = productByCategory.products?[tagID].title
//        userInfo?.currencyCode = "PKR"
//        userInfo?.lineItems?.append(product)
//        userInfo?.currencyCode = "PKR"
//        userInfo?.saveCurrentSession(forKey: USER_MODEL)
//        addBadgeCounter()
//        view.makeToast("Product added to cart")
//    }

    // MARK: - ADD TO CART

    @objc func addToCartProducts(sender: UIButton) {
        let buttonNumber = sender.tag
        setCartData(tagID: sender.tag)
        print(buttonNumber)
    }

    func setCartData(tagID: Int?) {
        var userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
        
        var id: String?

        if topSellingVC == true {
            
          if isPriceFilter == true{
                let myVarinats = self.priceFilteredArray[tagID ?? 0].variants!
                
                let objVariant = myVarinats[self.variantIndex]

                if userInfo?.lineItems?.count == 1 {
                    if userInfo?.lineItems?[0].title == "" || userInfo?.lineItems![0].title == nil {
                        userInfo?.lineItems![0].variant_id = Int(self.priceFilteredArray[tagID ?? 0].variants![0].id ?? "0")
                        userInfo?.lineItems![0].id = Int(self.priceFilteredArray[tagID ?? 0].id ?? "0")
                        userInfo?.lineItems![0].quantity = 1
                        userInfo?.lineItems![0].title = self.priceFilteredArray[tagID ?? 0].title
                        userInfo?.lineItems![0].image = self.priceFilteredArray[tagID ?? 0].image?.src
                        userInfo?.lineItems![0].price = Double(objVariant.price ?? "0")
                        userInfo?.lineItems![0].size = self.priceFilteredArray[tagID ?? 0].title
                        userInfo?.currencyCode = "PKR"
                        userInfo?.saveCurrentSession(forKey: USER_MODEL)
                        self.addBadgeCounter()
                        self.view.makeToast("Product added to cart")
                    } else {
                      //  self.addToCart(tagID: tagID ?? 0)
                        var userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
                        let myVarinats = self.priceFilteredArray[tagID!].variants!
                        let objVariant = myVarinats[self.variantIndex]
                        for i in 0 ..< (userInfo?.lineItems!.count)! {
                            let qty = 1
                            let oldQty = (userInfo?.lineItems![i].quantity)!
                            if userInfo?.lineItems![i].variant_id == Int(self.priceFilteredArray[tagID!].variants![0].id ?? "0") {
                                userInfo?.lineItems![i].quantity = oldQty + qty
                                userInfo?.saveCurrentSession(forKey: USER_MODEL)
                                view.makeToast(AppTheme.sharedInstance.quantityAdded)
                                return
                            }
                        }
                        var product: Item = Item()
                        product.variant_id = Int(self.priceFilteredArray[tagID!].variants![0].id ?? "0")
                        product.quantity = 1
                        product.id = Int(self.priceFilteredArray[tagID!].id ?? "0")
                        product.title = self.priceFilteredArray[tagID!].title
                        product.image = self.priceFilteredArray[tagID!].image?.src
                        product.price = Double(objVariant.price!)
                        product.size = self.priceFilteredArray[tagID!].title
                        userInfo?.currencyCode = "PKR"
                        userInfo?.lineItems?.append(product)
                        userInfo?.currencyCode = "PKR"
                        userInfo?.saveCurrentSession(forKey: USER_MODEL)
                        addBadgeCounter()
                        view.makeToast("Product added to cart")
                    }
                } else {
                   // self.addToCart(tagID: tagID ?? 0)
                    var userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
                    let myVarinats = self.priceFilteredArray[tagID!].variants!
                    let objVariant = myVarinats[self.variantIndex]
                    for i in 0 ..< (userInfo?.lineItems!.count)! {
                        let qty = 1
                        let oldQty = (userInfo?.lineItems![i].quantity)!
                        if userInfo?.lineItems![i].variant_id == Int(self.priceFilteredArray[tagID!].variants![0].id ?? "0") {
                            userInfo?.lineItems![i].quantity = oldQty + qty
                            userInfo?.saveCurrentSession(forKey: USER_MODEL)
                            view.makeToast(AppTheme.sharedInstance.quantityAdded)
                            return
                        }
                    }
                    var product: Item = Item()
                    product.variant_id = Int(self.priceFilteredArray[tagID!].variants![0].id ?? "0")
                    product.quantity = 1
                    product.id = Int(self.priceFilteredArray[tagID!].id ?? "0")
                    product.title = self.priceFilteredArray[tagID!].title
                    product.image = self.priceFilteredArray[tagID!].image?.src
                    product.price = Double(objVariant.price! ?? "0")
                    product.size = self.priceFilteredArray[tagID!].title
                    userInfo?.currencyCode = "PKR"
                    userInfo?.lineItems?.append(product)
                    userInfo?.currencyCode = "PKR"
                    userInfo?.saveCurrentSession(forKey: USER_MODEL)
                    addBadgeCounter()
                    view.makeToast("Product added to cart")
                }
          } else{
           // id = productDetails.products?[sender.tag].id
                let myVarinats = self.productDetails.products?[tagID ?? 0].variants!
            
                let objVariant = myVarinats?[self.variantIndex]

            if userInfo?.lineItems?.count == 1 {
                if userInfo?.lineItems?[0].title == "" || userInfo?.lineItems![0].title == nil {
                    userInfo?.lineItems![0].variant_id = Int(self.productDetails.products?[tagID ?? 0].variants![0].id ?? "0")
                    userInfo?.lineItems![0].id = Int(self.productDetails.products?[tagID ?? 0].id ?? "0")
                    userInfo?.lineItems![0].quantity = 1
                    userInfo?.lineItems![0].title = self.productDetails.products?[tagID ?? 0].title
                    userInfo?.lineItems![0].image = self.productDetails.products?[tagID ?? 0].image?.src
                    userInfo?.lineItems![0].price = Double(objVariant?.price ?? "0")
                    userInfo?.lineItems![0].size = self.productDetails.products?[tagID ?? 0].title
                    userInfo?.currencyCode = "PKR"
                    userInfo?.saveCurrentSession(forKey: USER_MODEL)
                    self.addBadgeCounter()
                    self.view.makeToast("Product added to cart")
                } else {
                    self.addToCart(tagID: tagID ?? 0)
                }
            } else {
                self.addToCart(tagID: tagID ?? 0)
            }
            
        }
         
        } else
        if isProductByCategory == true {
         //   id = productByCategory.products?[sender.tag].id
            if filters == true {
                //id = filteredProductDetails[sender.tag].id
                let myVarinats = filteredProductDetails[tagID ?? 0].variants!
                
                let objVariant = myVarinats[variantIndex]

                if userInfo?.lineItems?.count == 1 {
                    if userInfo?.lineItems?[0].title == "" || userInfo?.lineItems![0].title == nil {
                        userInfo?.lineItems![0].variant_id = Int(self.filteredProductDetails[tagID ?? 0].variants![0].id ?? "0")
                        userInfo?.lineItems![0].id = Int(self.filteredProductDetails[tagID ?? 0].id ?? "0")
                        userInfo?.lineItems![0].quantity = 1
                        userInfo?.lineItems![0].title = self.filteredProductDetails[tagID ?? 0].title
                        userInfo?.lineItems![0].image = self.filteredProductDetails[tagID ?? 0].image?.src
                        userInfo?.lineItems![0].price = Double(objVariant.price ?? "0")
                        userInfo?.lineItems![0].size = self.filteredProductDetails[tagID ?? 0].title
                        userInfo?.currencyCode = "PKR"
                        userInfo?.saveCurrentSession(forKey: USER_MODEL)
                        addBadgeCounter()
                        view.makeToast("Product added to cart")
                    } else {
                        var userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
                        let myVarinats = self.filteredProductDetails[tagID!].variants!
                        let objVariant = myVarinats[self.variantIndex]
                        for i in 0 ..< (userInfo?.lineItems!.count)! {
                            let qty = 1
                            let oldQty = (userInfo?.lineItems![i].quantity)!
                            if userInfo?.lineItems![i].variant_id == Int(self.filteredProductDetails[tagID!].variants![0].id ?? "0") {
                                userInfo?.lineItems![i].quantity = oldQty + qty
                                userInfo?.saveCurrentSession(forKey: USER_MODEL)
                                view.makeToast(AppTheme.sharedInstance.quantityAdded)
                                return
                            }
                        }
                        var product: Item = Item()
                        product.variant_id = Int(self.filteredProductDetails[tagID!].variants![0].id ?? "0")
                        product.quantity = 1
                        product.id = Int(self.filteredProductDetails[tagID!].id ?? "0")
                        product.title = self.filteredProductDetails[tagID!].title
                        product.image = self.filteredProductDetails[tagID!].image?.src
                        product.price = Double(objVariant.price! )
                        product.size = self.filteredProductDetails[tagID!].title
                        userInfo?.currencyCode = "PKR"
                        userInfo?.lineItems?.append(product)
                        userInfo?.currencyCode = "PKR"
                        userInfo?.saveCurrentSession(forKey: USER_MODEL)
                        addBadgeCounter()
                        view.makeToast("Product added to cart")
                        //addToCart(tagID: tagID ?? 0)
                    }
                } else {
                    var userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
                    let myVarinats = self.filteredProductDetails[tagID!].variants!
                    let objVariant = myVarinats[self.variantIndex]
                    for i in 0 ..< (userInfo?.lineItems!.count)! {
                        let qty = 1
                        let oldQty = (userInfo?.lineItems![i].quantity)!
                        if userInfo?.lineItems![i].variant_id == Int(self.filteredProductDetails[tagID!].variants![0].id ?? "0") {
                            userInfo?.lineItems![i].quantity = oldQty + qty
                            userInfo?.saveCurrentSession(forKey: USER_MODEL)
                            view.makeToast(AppTheme.sharedInstance.quantityAdded)
                            return
                        }
                    }
                    var product: Item = Item()
                    product.variant_id = Int(self.filteredProductDetails[tagID!].variants![0].id ?? "0")
                    product.quantity = 1
                    product.id = Int(self.filteredProductDetails[tagID!].id ?? "0")
                    product.title = self.filteredProductDetails[tagID!].title
                    product.image = self.filteredProductDetails[tagID!].image?.src
                    product.price = Double(objVariant.price! )
                    product.size = self.filteredProductDetails[tagID!].title
                    userInfo?.currencyCode = "PKR"
                    userInfo?.lineItems?.append(product)
                    userInfo?.currencyCode = "PKR"
                    userInfo?.saveCurrentSession(forKey: USER_MODEL)
                    addBadgeCounter()
                    view.makeToast("Product added to cart")

                }

            }else
            if isPriceFilter == true{
                  let myVarinats = self.priceFilteredArray[tagID ?? 0].variants!
                  
                  let objVariant = myVarinats[self.variantIndex]

                  if userInfo?.lineItems?.count == 1 {
                      if userInfo?.lineItems?[0].title == "" || userInfo?.lineItems![0].title == nil {
                          userInfo?.lineItems![0].variant_id = Int(self.priceFilteredArray[tagID ?? 0].variants![0].id ?? "0")
                          userInfo?.lineItems![0].id = Int(self.priceFilteredArray[tagID ?? 0].id ?? "0")
                          userInfo?.lineItems![0].quantity = 1
                          userInfo?.lineItems![0].title = self.priceFilteredArray[tagID ?? 0].title
                          userInfo?.lineItems![0].image = self.priceFilteredArray[tagID ?? 0].image?.src
                          userInfo?.lineItems![0].price = Double(objVariant.price ?? "0")
                          userInfo?.lineItems![0].size = self.priceFilteredArray[tagID ?? 0].title
                          userInfo?.currencyCode = "PKR"
                          userInfo?.saveCurrentSession(forKey: USER_MODEL)
                          self.addBadgeCounter()
                          self.view.makeToast("Product added to cart")
                      } else {
                        //  self.addToCart(tagID: tagID ?? 0)
                          var userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
                          let myVarinats = self.priceFilteredArray[tagID!].variants!
                          let objVariant = myVarinats[self.variantIndex]
                          for i in 0 ..< (userInfo?.lineItems!.count)! {
                              let qty = 1
                              let oldQty = (userInfo?.lineItems![i].quantity)!
                              if userInfo?.lineItems![i].variant_id == Int(self.priceFilteredArray[tagID!].variants![0].id ?? "0") {
                                  userInfo?.lineItems![i].quantity = oldQty + qty
                                  userInfo?.saveCurrentSession(forKey: USER_MODEL)
                                  view.makeToast(AppTheme.sharedInstance.quantityAdded)
                                  return
                              }
                          }
                          var product: Item = Item()
                          product.variant_id = Int(self.priceFilteredArray[tagID!].variants![0].id ?? "0")
                          product.quantity = 1
                          product.id = Int(self.priceFilteredArray[tagID!].id ?? "0")
                          product.title = self.priceFilteredArray[tagID!].title
                          product.image = self.priceFilteredArray[tagID!].image?.src
                          product.price = Double(objVariant.price!)
                          product.size = self.priceFilteredArray[tagID!].title
                          userInfo?.currencyCode = "PKR"
                          userInfo?.lineItems?.append(product)
                          userInfo?.currencyCode = "PKR"
                          userInfo?.saveCurrentSession(forKey: USER_MODEL)
                          addBadgeCounter()
                          view.makeToast("Product added to cart")
                      }
                  } else {
                     // self.addToCart(tagID: tagID ?? 0)
                      var userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
                      let myVarinats = self.priceFilteredArray[tagID!].variants!
                      let objVariant = myVarinats[self.variantIndex]
                      for i in 0 ..< (userInfo?.lineItems!.count)! {
                          let qty = 1
                          let oldQty = (userInfo?.lineItems![i].quantity)!
                          if userInfo?.lineItems![i].variant_id == Int(self.priceFilteredArray[tagID!].variants![0].id ?? "0") {
                              userInfo?.lineItems![i].quantity = oldQty + qty
                              userInfo?.saveCurrentSession(forKey: USER_MODEL)
                              view.makeToast(AppTheme.sharedInstance.quantityAdded)
                              return
                          }
                      }
                      var product: Item = Item()
                      product.variant_id = Int(self.priceFilteredArray[tagID!].variants![0].id ?? "0")
                      product.quantity = 1
                      product.id = Int(self.priceFilteredArray[tagID!].id ?? "0")
                      product.title = self.priceFilteredArray[tagID!].title
                      product.image = self.priceFilteredArray[tagID!].image?.src
                      product.price = Double(objVariant.price! ?? "0")
                      product.size = self.priceFilteredArray[tagID!].title
                      userInfo?.currencyCode = "PKR"
                      userInfo?.lineItems?.append(product)
                      userInfo?.currencyCode = "PKR"
                      userInfo?.saveCurrentSession(forKey: USER_MODEL)
                      addBadgeCounter()
                      view.makeToast("Product added to cart")
                  }
            } else{
            
            
            let myVarinats = productByCategory.products?[tagID ?? 0].variants!
            
            let objVariant = myVarinats?[variantIndex]

            if userInfo?.lineItems?.count == 1 {
                if userInfo?.lineItems?[0].title == "" || userInfo?.lineItems![0].title == nil {
                    userInfo?.lineItems![0].variant_id = Int(productByCategory.products?[tagID ?? 0].variants![0].id ?? "0")
                    userInfo?.lineItems![0].id = Int(productByCategory.products?[tagID ?? 0].id ?? "0")
                    userInfo?.lineItems![0].quantity = 1
                    userInfo?.lineItems![0].title = productByCategory.products?[tagID ?? 0].title
                    userInfo?.lineItems![0].image = productByCategory.products?[tagID ?? 0].image?.src
                    userInfo?.lineItems![0].price = Double(objVariant?.price ?? "0")
                    userInfo?.lineItems![0].size = productByCategory.products?[tagID ?? 0].title
                    userInfo?.currencyCode = "PKR"
                    userInfo?.saveCurrentSession(forKey: USER_MODEL)
                    addBadgeCounter()
                    view.makeToast("Product added to cart")
                } else {
                   // addToCart(tagID: tagID ?? 0)
                    var userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
                    let myVarinats = self.productByCategory.products?[tagID!].variants!
                    let objVariant = myVarinats![self.variantIndex]
                    for i in 0 ..< (userInfo?.lineItems!.count)! {
                        let qty = 1
                        let oldQty = (userInfo?.lineItems![i].quantity)!
                        if userInfo?.lineItems![i].variant_id == Int(self.productByCategory.products?[tagID!].variants![0].id ?? "0") {
                            userInfo?.lineItems![i].quantity = oldQty + qty
                            userInfo?.saveCurrentSession(forKey: USER_MODEL)
                            view.makeToast(AppTheme.sharedInstance.quantityAdded)
                            return
                        }
                    }
                    var product: Item = Item()
                    product.variant_id = Int(self.productByCategory.products?[tagID!].variants![0].id ?? "0")
                    product.quantity = 1
                    product.id = Int(self.productByCategory.products?[tagID!].id ?? "0")
                    product.title = self.productByCategory.products?[tagID!].title
                    product.image = self.productByCategory.products?[tagID!].image?.src
                    product.price = Double(objVariant.price! ?? "0")
                    product.size = self.productByCategory.products?[tagID!].title
                    userInfo?.currencyCode = "PKR"
                    userInfo?.lineItems?.append(product)
                    userInfo?.currencyCode = "PKR"
                    userInfo?.saveCurrentSession(forKey: USER_MODEL)
                    addBadgeCounter()
                    view.makeToast("Product added to cart")
                }
            } else {
               // addToCart(tagID: tagID ?? 0)
                var userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
                let myVarinats = self.productByCategory.products?[tagID!].variants!
                let objVariant = myVarinats![self.variantIndex]
                for i in 0 ..< (userInfo?.lineItems!.count)! {
                    let qty = 1
                    let oldQty = (userInfo?.lineItems![i].quantity)!
                    if userInfo?.lineItems![i].variant_id == Int(self.productByCategory.products?[tagID!].variants![0].id ?? "0") {
                        userInfo?.lineItems![i].quantity = oldQty + qty
                        userInfo?.saveCurrentSession(forKey: USER_MODEL)
                        view.makeToast(AppTheme.sharedInstance.quantityAdded)
                        return
                    }
                }
                var product: Item = Item()
                product.variant_id = Int(self.productByCategory.products?[tagID!].variants![0].id ?? "0")
                product.quantity = 1
                product.id = Int(self.productByCategory.products?[tagID!].id ?? "0")
                product.title = self.productByCategory.products?[tagID!].title
                product.image = self.productByCategory.products?[tagID!].image?.src
                product.price = Double(objVariant.price!)
                product.size = self.productByCategory.products?[tagID!].title
                userInfo?.currencyCode = "PKR"
                userInfo?.lineItems?.append(product)
                userInfo?.currencyCode = "PKR"
                userInfo?.saveCurrentSession(forKey: USER_MODEL)
                addBadgeCounter()
                view.makeToast("Product added to cart")
            }
            }
        } else
        if isSearchFilter == true {
          //  id = searchArray[sender.tag].id
            let myVarinats = searchArray[tagID ?? 0].variants!
            
            let objVariant = myVarinats[variantIndex]

            if userInfo?.lineItems?.count == 1 {
                if userInfo?.lineItems?[0].title == "" || userInfo?.lineItems![0].title == nil {
                    userInfo?.lineItems![0].variant_id = Int(productDetails.products?[tagID ?? 0].variants![0].id ?? "0")
                    userInfo?.lineItems![0].id = Int(productDetails.products?[tagID ?? 0].id ?? "0")
                    userInfo?.lineItems![0].quantity = 1
                    userInfo?.lineItems![0].title = productDetails.products?[tagID ?? 0].title
                    userInfo?.lineItems![0].image = productDetails.products?[tagID ?? 0].image?.src
                    userInfo?.lineItems![0].price = Double(objVariant.price ?? "0")
                    userInfo?.lineItems![0].size = productDetails.products?[tagID ?? 0].title
                    userInfo?.currencyCode = "PKR"
                    userInfo?.saveCurrentSession(forKey: USER_MODEL)
                    addBadgeCounter()
                    view.makeToast("Product added to cart")
                } else {
                    addToCart(tagID: tagID ?? 0)
                }
            } else {
                addToCart(tagID: tagID ?? 0)
            }

        } else {
           // id = "\(searchProducts![sender.tag].id)"
            let myVarinats = searchProducts![tagID ?? 0].variants!
            
            let objVariant = myVarinats[variantIndex]

            if userInfo?.lineItems?.count == 1 {
                if userInfo?.lineItems?[0].title == "" || userInfo?.lineItems![0].title == nil {
                    userInfo?.lineItems![0].variant_id = Int(productDetails.products?[tagID ?? 0].variants![0].id ?? "0")
                    userInfo?.lineItems![0].id = Int(productDetails.products?[tagID ?? 0].id ?? "0")
                    userInfo?.lineItems![0].quantity = 1
                    userInfo?.lineItems![0].title = productDetails.products?[tagID ?? 0].title
                    userInfo?.lineItems![0].image = productDetails.products?[tagID ?? 0].image?.src
                    userInfo?.lineItems![0].price = Double(objVariant.price ?? "0")
                    userInfo?.lineItems![0].size = productDetails.products?[tagID ?? 0].title
                    userInfo?.currencyCode = "PKR"
                    userInfo?.saveCurrentSession(forKey: USER_MODEL)
                    addBadgeCounter()
                    view.makeToast("Product added to cart")
                } else {
                    addToCart(tagID: tagID ?? 0)
                }
            } else {
                addToCart(tagID: tagID ?? 0)
            }

        }
        
        badgeCount.text = "\((userInfo?.lineItems!.count)!)"
        badgeCount.isHidden = false
    }

    func addToCart(tagID: Int) {
        var userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
        let myVarinats = productDetails.products?[tagID].variants!
        let objVariant = myVarinats?[variantIndex]
        for i in 0 ..< (userInfo?.lineItems!.count)! {
            let qty = 1
            let oldQty = (userInfo?.lineItems![i].quantity)!
            if userInfo?.lineItems![i].variant_id == Int(productDetails.products?[tagID].variants![0].id ?? "0") {
                userInfo?.lineItems![i].quantity = oldQty + qty
                userInfo?.saveCurrentSession(forKey: USER_MODEL)
                view.makeToast(AppTheme.sharedInstance.quantityAdded)
                return
            }
        }
        var product: Item = Item()
        product.variant_id = Int(productDetails.products?[tagID].variants![0].id ?? "0")
        product.quantity = 1
        product.id = Int(productDetails.products?[tagID].id ?? "0")
        product.title = productDetails.products?[tagID].title
        product.image = productDetails.products?[tagID].image?.src
        product.price = Double(objVariant?.price! ?? "0")
        product.size = productDetails.products?[tagID].title
        userInfo?.currencyCode = "PKR"
        userInfo?.lineItems?.append(product)
        userInfo?.currencyCode = "PKR"
        userInfo?.saveCurrentSession(forKey: USER_MODEL)
        addBadgeCounter()
        view.makeToast("Product added to cart")
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

    // MARK: - Collection View Data Source

    fileprivate func layoutSetting(_ collection: UICollectionView) {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
        layout.itemSize = CGSize(width: view.frame.width * 0.45, height: view.frame.height * 0.35)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 12
        collection.collectionViewLayout = layout
    }

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
        // filters = false
        UIView.transition(with: filtersView, duration: 0.5, options: .curveEaseInOut, animations: {
            self.filtersView.isHidden = true
        })
    }

    @IBAction func priceSlideBtn(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        minimumPriceFilterLabel.text = "Rs." + "\(currentValue)"

        if topSellingVC == true {
            if currentValue != 0 {
                isPriceFilter = true
                priceFilteredArray.removeAll()
                for i in productDetails.products! {
                    let data = i.variants![0].price
                    let itemPrice = Double(data ?? "")
                    if currentValue > 0 {
                        if currentValue >= Int(itemPrice ?? 0) {
                            priceFilteredArray.append(i)
                        }
                    }
                }

                print("Price:", priceFilteredArray.count)
                totalProductLbl.text = "\(priceFilteredArray.count) Products"

                

            } else {
                isPriceFilter = false
                totalProductLbl.text = "\(productDetails.products!.count) Products"
                priceFilteredArray.removeAll()
            }

            productsCollectionview.reloadData()

        } else
        if isProductByCategory == true {
            // id = productByCategory.products!
            if currentValue != 0 {
                isPriceFilter = true
                priceFilteredArray.removeAll()
                for i in productByCategory.products! {
                    let data = i.variants![0].price
                    let itemPrice = Double(data ?? "")
                    if currentValue > 0 {
                        if currentValue >= Int(itemPrice ?? 0) {
                            priceFilteredArray.append(i)
                        }
                    }
                }

                print("Price:", priceFilteredArray.count)
                totalProductLbl.text = "\(priceFilteredArray.count) Products"

//                tagListView.removeAllTags()
//                tagListView.delegate = self
//
//                filterArray.removeAll()
//                for i in 0 ..< priceFilteredArray.count {
//                    let vendor = priceFilteredArray[i].vendor
//                    filterArray.append(vendor!)
//                }
//
//                filterArray.removeDuplicates()
//                print(filterArray)
//                for item in filterArray {
//                    tagListView.addTag(item)
//                }

            } else {
                isPriceFilter = false
                totalProductLbl.text = "\(productByCategory.products!.count) Products"
                priceFilteredArray.removeAll()
            }

            productsCollectionview.reloadData()
        } else
        if filters == true {
            // id = filteredProductDetails
        } else
        if isSearchFilter == true {
            // id = searchArray
            
        } else {
            //  id = searchProducts
            if currentValue != 0 {
                isSearchPriceFilter = true
                priceSearchFilter.removeAll()
                for i in searchProducts! {
                    let data = i.price
                    let itemPrice = Double(data ?? "")
                    if currentValue > 0 {
                        if currentValue >= Int(itemPrice ?? 0) {
                           // priceSearchFilter.append(i)
                        }
                    }
                }

                print("Price:", priceSearchFilter.count)
                totalProductLbl.text = "\(priceSearchFilter.count) Products "

            } else {
                isSearchPriceFilter = false
                totalProductLbl.text = "\(searchProducts!.count) Products"
                priceSearchFilter.removeAll()
            }

            productsCollectionview.reloadData()
        }
    }

    @IBAction func clearFiltersBtn(_ sender: Any) {
        if isSearchFilter == true {
            layoutChanged = false
            filters = false
            isSearchFilter = false
            topSellingVC = false
            searchArray.removeAll()
            productsCollectionview.reloadData()
            UIView.transition(with: filtersView, duration: 0.5, options: .curveEaseInOut, animations: {
                self.filtersView.isHidden = true
            })
        } else if isProductByCategory == true{
            isPriceFilter = false
            layoutChanged = false
            filters = false
            topSellingVC = false
            isSearchFilter = false
            isProductByCategory = true
            filteredProductDetails.removeAll()
            productsCollectionview.reloadData()
            UIView.transition(with: filtersView, duration: 0.5, options: .curveEaseInOut, animations: {
                self.filtersView.isHidden = true
            })
        }else{
            isPriceFilter = false
            layoutChanged = false
            filters = false
            topSellingVC = true
            isSearchFilter = false
            filteredProductDetails.removeAll()
            productsCollectionview.reloadData()
            UIView.transition(with: filtersView, duration: 0.5, options: .curveEaseInOut, animations: {
                self.filtersView.isHidden = true
            })
        }
    }

    // MARK: - CALL Searched PRODUCTS API

    func getProduct(productID: String) {
        if Reachability.isConnectedToNetwork() {
            print("Reachable via WiFi")

            ServerManager.sharedInstance.getRequest(url: ServerManager.sharedInstance.BASE_URL + "products/\(productID).json", completion: { js in
                print(js)
                self.getProductData(jsson: js)
            })
        } else {
            CommonMethods.doSomething(view: self) {
            }
        }
    }

    fileprivate func getProductData(jsson: AnyObject) {
        if jsson is [String: Any] {
            let json = jsson as! [String: Any]

            let data = SearchedProduct(dictionary: json as NSDictionary)
            collectionList = data

            guard collectionList != nil else {
                return
            }
            print(collectionList)

            DispatchQueue.main.async { [self] in

                self.loadingUIView.isHidden = true
                // self.loadingView.stopAnimating()
                let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailsViewController

                cv.searchProductDetails = collectionList
                cv.isSearchedProduct = true
                self.navigationController?.pushViewController(cv, animated: true)
            }

        } else {
            DispatchQueue.main.async {
                self.loadingUIView.isHidden = true
                // self.loadingView.stopAnimating()
                self.alert.hide(isPopupAnimated: true)
                let message = jsson.value(forKey: "message") as! String
                self.showMessage(message: message)
            }
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

    // MARK: - GET PRODUCTs FROM COLLECTION ID

    func getProducts(collectionID: String) {
        if Reachability.isConnectedToNetwork() {
            loadingUIView.isHidden = false
            DispatchQueue.main.async {
                self.animationView.image = UIImage.gif(name: "Shahalami_cart_loader")
            }
            ServerManager.sharedInstance.getRequest(url: ServerManager.sharedInstance.BASE_URL + "products.json?collection_id=\(collectionID)&published_status=published&limit=250", completion: { js in
                print(js)
                self.getProductsData(jsson: js)
            })
        } else {
            CommonMethods.doSomething(view: self) {
            }
        }
    }

    fileprivate func getProductsData(jsson: AnyObject) {
        if jsson is [String: Any] {
            let json = jsson as! [String: Any]

            let data = Products(dictionary: json as NSDictionary)
            productByCategory = data
            print(productByCategory)
            DispatchQueue.main.async { [self] in
                
                productsCollectionview.delegate = self
                productsCollectionview.dataSource = self
                productsCollectionview.reloadData()
                totalProductLbl.text = "\(productByCategory.products!.count) Products"
                self.loadingUIView.isHidden = true
                
                for item in productByCategory.products! {
                    filterArray.append(item.vendor!)
                }
                
                filterArray.removeDuplicates()
                print(filterArray)
                
                for item in filterArray {
                  tagListView.addTag(item)
                }

                // self.loadingView.stopAnimating()
            }

        } else {
            let message = jsson.value(forKey: "message") as! String
            showMessage(message: message)
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
                            if productDetails.products != nil {
                                self.productsCollectionview.delegate = self
                                self.productsCollectionview.dataSource = self
                                self.productsCollectionview.reloadData()
                                //print(wishlistIDs)
                            } else if productByCategory.products != nil {
                                self.productsCollectionview.delegate = self
                                self.productsCollectionview.dataSource = self
                                self.productsCollectionview.reloadData()
                            } else if searchResults == true{
                            if searchProducts! != nil{
                                self.productsCollectionview.delegate = self
                                self.productsCollectionview.dataSource = self
                                self.productsCollectionview.reloadData()
                            }
                            } else if searchArray.count > 0 {
                                self.productsCollectionview.delegate = self
                                self.productsCollectionview.dataSource = self
                                self.productsCollectionview.reloadData()
                            } else if filteredProductDetails.count > 0 {
                                self.productsCollectionview.delegate = self
                                self.productsCollectionview.dataSource = self
                                self.productsCollectionview.reloadData()
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
//            "user_id": "\(userInfo!.userID ?? 0)" as Any
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
//            let json = json as! [String: Any]
//            guard json["product_ids"] as! String != "" else {
//                return
//            }
//
//            DispatchQueue.main.async { [self] in
//                wishlist_ids = json["product_ids"]! as? String
//                wishlistIDs = wishlist_ids!.components(separatedBy: ",")
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    if productDetails.products != nil {
//                        self.productsCollectionview.delegate = self
//                        self.productsCollectionview.dataSource = self
//                        self.productsCollectionview.reloadData()
//                        print(wishlistIDs)
//                    } else if productByCategory.products != nil {
//                        self.productsCollectionview.delegate = self
//                        self.productsCollectionview.dataSource = self
//                        self.productsCollectionview.reloadData()
//                    } else if searchResults == true{
//                        if searchProducts! != nil{
//                        self.productsCollectionview.delegate = self
//                        self.productsCollectionview.dataSource = self
//                        self.productsCollectionview.reloadData()
//                       }
//                    } else if searchArray.count > 0 {
//                        self.productsCollectionview.delegate = self
//                        self.productsCollectionview.dataSource = self
//                        self.productsCollectionview.reloadData()
//                    } else if filteredProductDetails.count > 0 {
//                        self.productsCollectionview.delegate = self
//                        self.productsCollectionview.dataSource = self
//                        self.productsCollectionview.reloadData()
//                    }
//                }
//            }
//
//        } else {
//        }
//    }
//
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
            let json = json as! [String: Any]

            DispatchQueue.main.async { [self] in
                if json["product_ids"]! as! String != "" {
                    self.view.makeToast(AppTheme.sharedInstance.productRemovedFromWishlist)
                    self.getWishlistIDs()
                } else {
                    self.view.makeToast(json["message"]! as? String)
                }
            }

        } else {
            let message = json.value(forKey: "message")
            showMessage(message: message as? String)
        }
    }
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = removingDuplicates()
    }
}
