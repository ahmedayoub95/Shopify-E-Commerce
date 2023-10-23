//
//  CategoriesViewController.swift
//  Easy Shopping
//
//  Created by Mazhar on 21/10/2021.
//

import UIKit
import SDWebImage

import Reachability
import SwiftGifOrigin
class CategoriesViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var subCategoriesCollectionView: UICollectionView!
    
    
    @IBOutlet weak var animationView: UIImageView!
   
    @IBOutlet weak var loaderView: UIView!
    var collectionsList = Categories()
    var categoryImages : [UIImage] = []
    var categoryName : [String] = ["All Products","Hair Dryers & Straightners","Home Appliances","Massagers","Mobile Accessories","Shaver & Trimmers", "Xiamo Mi"]
    var categoryName2 : [String] = ["All Products","Barbie","Fisher Piece","Mattle "," Accessories","Winfun", "Hasbro"]
    var selectedIndex : NSInteger = 0
    var category_index : NSInteger = 0
    var total_child_collections : NSInteger = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetting(subCategoriesCollectionView)
       // layoutSetting(<#T##UICollectionView#>)
    }
    
     override func viewWillAppear(_ animated: Bool) {
        self.setup()
    }

    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == categoriesCollectionView){
            return collectionsList.data!.count
        }else{
            return total_child_collections
        }
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
     
        if(collectionView == categoriesCollectionView){
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath as IndexPath) as! CategoriesCollectionViewCell

            if(selectedIndex == indexPath.row){
                UIView.transition(with: cell.selectedCellView, duration: 0.5, options: .allowAnimatedContent, animations: {
                    cell.selectedCellView.backgroundColor = #colorLiteral(red: 0.06797788292, green: 0.44484514, blue: 0.7272182107, alpha: 1)
                   })
                cell.selectedCellView.layer.cornerRadius = 8
                cell.selectedCellView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            }else{
                cell.selectedCellView.backgroundColor = .none
            }
            
            let data = self.collectionsList.data![indexPath.row].attributes
            
            cell.categoryNameLbl.text = self.collectionsList.data![indexPath.row].title
            if (data?.images![0].admin_src != nil){
               // if data!.image != nil {
                    cell.categoryImageView.sd_setImage(with: URL(string: data?.images![0].admin_src ?? ""), placeholderImage: UIImage(named: "ic_placeholder")) {
                        image, error, _, _ in
                        // your code
                        if error == nil {
                            cell.categoryImageView.contentMode = .scaleAspectFill
                        } else {
                            cell.categoryImageView.contentMode = .scaleAspectFit
                        }
                        print(image ?? "")
                    }
               // }
            }else{
                cell.categoryImageView.sd_setImage(with: URL(string: data?.images![1].admin_src ?? ""), placeholderImage: UIImage(named: "ic_placeholder")) {
                    image, error, _, _ in
                    // your code
                    if error == nil {
                        cell.categoryImageView.contentMode = .scaleAspectFit
                    } else {
                        cell.categoryImageView.contentMode = .scaleAspectFit
                    }
                    print(image ?? "")
                }
            }
            
            
            return cell
            
            
        }else
       {
            
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subCategoryCell", for: indexPath as IndexPath) as! SubCategoriesCollectionViewCell
        cell.cellView.layer.cornerRadius =  cell.cellView.frame.size.width/2
        cell.cellView.clipsToBounds = true
        cell.cellView.layer.masksToBounds = false
        cell.cellView.uiViewShadow()
       
        if indexPath.row == 0 {
            let data = collectionsList.data![0].attributes
            cell.subCategoriesLbl.text = data?.child_categories![indexPath.row].title
           // cell.subCategoryImageView.image =  data?.images![0].admin_src//UIImage(named: "in_white")
            cell.subCategoryImageView.contentMode = .scaleToFill
            let image = data?.child_categories![indexPath.row].attributes?.images![0].admin_src
            if (image != nil){
                    cell.subCategoryImageView.sd_setImage(with: URL(string: image ?? ""), placeholderImage: UIImage(named: "ic_placeholder")) {
                        image, error, _, _ in
                        // your code
                        if error == nil {
                            cell.subCategoryImageView.contentMode = .scaleAspectFill
                        } else {
                            cell.subCategoryImageView.contentMode = .scaleToFill
                        }
                        print(image ?? "")
                    }
            }
            cell.cellView.backgroundColor =  #colorLiteral(red: 0.06797788292, green: 0.44484514, blue: 0.7272182107, alpha: 1)
            

        }else{
            let data = collectionsList.data![category_index].attributes
            
            cell.subCategoriesLbl.text = data?.child_categories![indexPath.row].title
            var image = data?.child_categories![indexPath.row].attributes?.images![0].admin_src
            if image == nil {
               image = data?.child_categories![indexPath.row].attributes?.images![1].admin_src
            }
            if (image != nil){
                    cell.subCategoryImageView.sd_setImage(with: URL(string: image ?? ""), placeholderImage: UIImage(named: "ic_placeholder")) {
                        image, error, _, _ in
                        // your code
                        if error == nil {
                            cell.subCategoryImageView.contentMode = .scaleAspectFill
                        } else {
                            cell.subCategoryImageView.contentMode = .scaleAspectFit
                        }
                        print(image ?? "")
                    }
            }

            
            
            
            cell.subCategoryImageView.layer.cornerRadius = cell.subCategoryImageView.frame.size.width/2
            cell.cellView.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
         
        }

           
            
            return cell
        }
    }
    
    // MARK: - UICollectionViewDelegate protocol

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(collectionView == categoriesCollectionView){
            
            selectedIndex = indexPath.row
            category_index = indexPath.row
            //if indexPath.row == 1 {
            let data = collectionsList.data![category_index].attributes
            total_child_collections = (data?.child_categories!.count)!
                categoriesCollectionView.reloadData()
                subCategoriesCollectionView.reloadData()
           // }
        }else{
          //  DispatchQueue.main.async { [self] in
                let cv = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PagerVC") as! PagerVC
                cv.modalTransitionStyle = .crossDissolve
              
                cv.isComingFromCategories = indexPath.row
                cv.mainCollectionID = self.collectionsList.data![category_index].id!
                cv.collectionList = (self.collectionsList.data![category_index].attributes?.child_categories)!

                self.navigationController?.pushViewController(cv, animated: false)
          //  }
        }
        
        print("You selected cell #\(indexPath.row)!")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (collectionView == categoriesCollectionView) {
            return CGSize(width: 119, height: 98)
        }else{
            return CGSize(width: 89, height: 107)
        }
       
      }

    fileprivate func layoutSetting(_ collection: UICollectionView) {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width * 0.31, height: view.frame.height * 0.15)
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 2
        collection.collectionViewLayout = layout
    }

    
    func setup() {
        self.getCollections()
    }

    
    //MARK: - Collections API
    func getCollections() {
        if Reachability.isConnectedToNetwork(){
        self.loaderView.isHidden = false
            DispatchQueue.main.async {
                self.animationView.image = UIImage.gif(name: "Shahalami_cart_loader")
            }
        ServerManager.sharedInstance.getCollectionRequest(url: ServerManager.sharedInstance.exdURL + "categories", completion: { js in
            print(js)
            self.getCollections(json: js)
        })
        }else{
            CommonMethods.doSomething(view: self){
                self.getCollections()
            }
        }
    }

    fileprivate func getCollections(json: AnyObject) {
        if json is [String: Any] {
          //  collectionsList = []

            do {
                let json = try json as! [String: Any]
                let data = Categories(dictionary: json as NSDictionary)
                collectionsList = data
       
                DispatchQueue.main.async { [self] in
                    print(collectionsList)
                    guard collectionsList.data != nil else{
                        return
                    }
                    categoriesCollectionView.delegate = self
                    categoriesCollectionView.dataSource = self
                    categoriesCollectionView.reloadData()
                    
                    
                    if collectionsList.data?.count ?? 0 > 0{
                    let data = collectionsList.data![category_index].attributes
                    total_child_collections = (data?.child_categories!.count)!
                    subCategoriesCollectionView.delegate = self
                    subCategoriesCollectionView.dataSource = self
                    subCategoriesCollectionView.reloadData()
                    loaderView.isHidden = true
                    }else{
                        
                    }
                }
            }//do ends
            catch let jsonError {
                DispatchQueue.main.async {
                let message = json.value(forKey: "message") as! String
                    self.showMessage(message: message)
                }
            }

        } else {
            DispatchQueue.main.async {
               // self.alert.hide(isPopupAnimated: true)
            
            let message = json.value(forKey: "message") as! String
                self.showMessage(message: message)
            }
        }
    }
    
    func showMessage(message: String?) {
          let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
              alert.dismiss(animated: true) {
              }
          }))
        self.present(alert, animated: true, completion: nil)
      }

    
}
