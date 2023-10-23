//
//  WishlistViewController.swift
//  Shahalami.pk
//
//  Created by Ahmed on 23/11/2021.
//

import UIKit

import NVActivityIndicatorView
import Toast_Swift
import ViewAnimator
class WishlistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var favouritesArray = Products()

    private let animate = [AnimationType.from(direction: .bottom, offset: 300)]
    var userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
    var userToken = AppUtility.sharedInstance.getTokenSession(forKey: USER_TOKEN_KEY)
    @IBOutlet var wishlistTableView: UITableView!
    @IBOutlet var cartView: UIView!

    @IBOutlet weak var animationView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
   
    }
    override func viewWillAppear(_ animated: Bool) {
        if userToken != nil {
            getWishlistIDs()
        } else {
            showMessage(message: "Please Login to see your wishlist.")
            wishlistTableView.isHidden = true
            cartView.isHidden = false
        }

        wishlistTableView.register(UINib(nibName: "WishlistTableViewCell", bundle: nil), forCellReuseIdentifier: "wishlistCell")
    }

    // MARK: - TABLEVIEW FOR WISHLIST

    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouritesArray.products!.count
    }

    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old onec
        let cell: WishlistTableViewCell = (wishlistTableView.dequeueReusableCell(withIdentifier: "wishlistCell") as! WishlistTableViewCell?)!

        let data = favouritesArray.products?[indexPath.row]
        // let data2 =  data["Product"]
        cell.selectionStyle = .none
        cell.cellView.addShadow(opacity: 0.4, cornerRadius: 6, shadowRadius: 4.0)
        
        // cell.unFavouriteButton.addTarget(self, action:#selector(unfavouritePressed(sender:)), for: .touchUpInside)
        cell.favouriteButton.tag = indexPath.row
        //  cell.unFavouriteButton.tag = indexPath.row

        cell.productNameLbl.text = data?.title
        //cell.variantTitleLbl.text = data?.variants![0].title
//           if !((data?.variants?[0].sku!.isEmpty)!) {
//               cell.skuLbl.isHidden = false
       // cell.skuLbl.text = "SKU: N/A"
//           }else{
//               cell.skuLbl.isHidden = true
//           }
       
        let price = Double(data?.variants?[0].price ?? "")
        let p = Int(price!)
        cell.productPriceLbl.text = "Rs. \(p.withCommas())"
        if data?.image != nil {
            cell.productImage.sd_setImage(with: URL(string: data?.image!.src ?? ""), placeholderImage: UIImage(named: "ic_placeholder")) {
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
        cell.favouriteButton.addTarget(self, action: #selector(removePressed(sender:)), for: .touchUpInside)

        return cell
    }

    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")

        DispatchQueue.main.async { [self] in
            let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailsViewController
            cv.productDetails = favouritesArray.products![indexPath.row]
            print("You selected cell #\(indexPath.row)!")
            self.navigationController?.pushViewController(cv, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 152
    }

    // MARK: - TOP SELLING

    @objc func removePressed(sender: UIButton) {
        let section = sender.tag / 100
        let item = sender.tag % 100
        let indexPath = IndexPath(item: item, section: section)
        let cell = wishlistTableView?.cellForRow(at: indexPath) as! WishlistTableViewCell
        let id = favouritesArray.products![sender.tag].id!
        removeWishlistIDs(productID: id)

        let buttonNumber = sender.tag
        print(buttonNumber)

        // self.getWishlistIDs()
    }

    // MARK: - Remove wishlist

    //

    func removeWishlistIDs(productID: String) {
        DispatchQueue.main.async {
            self.animationView.isHidden = false
            self.animationView.image = UIImage.gif(name: "Shahalami_cart_loader")
        }
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
                    self.animationView.isHidden = true
                    if json["product_ids"]! as! String != "" {
                        getProduct(productID: json["product_ids"]! as! String)
                        self.view.makeToast(AppTheme.sharedInstance.productRemovedFromWishlist)
                    } else {
                        self.animationView.isHidden = true
                        wishlistTableView.isHidden = true
                        cartView.isHidden = false
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

    // MARK: - WISHLIST API

    func getWishlistIDs()
    {
        DispatchQueue.main.async {
            self.animationView.isHidden = false
            self.animationView.image = UIImage.gif(name: "Shahalami_cart_loader")
        }

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
                        if resp.product_ids! != "" {
                            getProduct(productID:  resp.product_ids ?? "")
                        } else {
                            self.animationView.isHidden = true
                            wishlistTableView.isHidden = true
                            cartView.isHidden = false
                            showMessage(message: "No products in wishlist")
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

    // MARK: - CALL  PRODUCTS API

    func getProduct(productID: String) {
        print("Reachable via WiFi")

        ServerManager.sharedInstance.getRequest(url: ServerManager.sharedInstance.BASE_URL + "products.json?ids=\(productID)", completion: { js in
            print(js)
            self.getProductData(jsson: js)
        })
    }

    fileprivate func getProductData(jsson: AnyObject) {
        if jsson is [String: Any] {
//            collectionList = []

            do {
                let json = jsson as! [String: Any]

                let data = Products(dictionary: json as NSDictionary)
                favouritesArray = data
                guard favouritesArray.products != nil else {
                    return
                }
                print(favouritesArray)

                DispatchQueue.main.async { [self] in
                    self.animationView.isHidden = true
                    wishlistTableView.isHidden = false
                    cartView.isHidden = true
                    self.wishlistTableView.delegate = self
                    self.wishlistTableView.dataSource = self
                    self.wishlistTableView.reloadData()
                    self.wishlistTableView?.performBatchUpdates({
                        UIView.animate(views: self.wishlistTableView!.visibleCells,
                                       animations: self.animate, completion: {
                                       })
                    }, completion: nil)
                }

            } catch let error {
                print(error)
                DispatchQueue.main.async {
                    // self.loadingUIView.isHidden = true
                    self.animationView.isHidden = true
                    // self.alert.hide(isPopupAnimated: true)
                    
                    self.showMessage(message: error.localizedDescription)
                }
            }

        } else {
            DispatchQueue.main.async {
//                GIFHUD.shared.dismiss()
                //     self.activityView.stopAnimating()
                // self.alert.hide(isPopupAnimated: true)
            }
            let message = jsson.value(forKey: "message") as! String
            showMessage(message: message)
        }
    }

    // MARK: - POPUP MESSAGES

    func showMessage(message: String) {
        wishlistTableView.isHidden = true

        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            alert.dismiss(animated: true) {
            }
        }))
        present(alert, animated: true, completion: nil)
    }
}
