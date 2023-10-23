//
//  PagerViewViewController.swift
//  Shahalami.pk
//
//  Created by Ahmed Ayub on 22/10/2021.
//

import UIKit
import PageMenu
import SDWebImage
import CDAlertView
import Reachability

class PagerViewViewController: UIViewController,CAPSPageMenuDelegate {

    var collectionList = [ChildCategory]()//[String] = ["All Products","Hair Dryers & Straightners","Home Appliances","Massagers","Mobile Accessories","Shaver & Trimmers", "Xiamo Mi"]
    var currentIndex = 0
    var mainCollectionID = ""
    var pageMenu : CAPSPageMenu?
    
    
    let tempView = UIView()
    var controllerArray : [UIViewController] = []
    let viewController = ProductsViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPageMenu()
    }

    func setPageMenu(){
        
      
       for i in 0..<(collectionList.count){
            let collectObj = collectionList[i].title
            let cv = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductsVC") as! ProductsViewController
            cv.title =  collectObj!
            cv.parentNavController = self.navigationController
            cv.mainCollectionID = mainCollectionID
            
            controllerArray.append(cv)
       }
        let parameters: [CAPSPageMenuOption] = [
               .scrollMenuBackgroundColor(AppUtility.sharedInstance.hexStringToUIColor(hex: "#ffffff")),
               .viewBackgroundColor(AppUtility.sharedInstance.hexStringToUIColor(hex: "#ffffff")),
               .selectionIndicatorColor(AppUtility.sharedInstance.hexStringToUIColor(hex: "#1B75BA")),
               .addBottomMenuHairline(true),
               .menuItemFont(UIFont(name: "Poppins", size: 13.0)!),
               .menuHeight(60),
               .selectionIndicatorHeight(1.0),
               .menuItemWidthBasedOnTitleTextWidth(true),
               .selectedMenuItemLabelColor(AppUtility.sharedInstance.hexStringToUIColor(hex: "#1B75BA")),
               .unselectedMenuItemLabelColor(AppUtility.sharedInstance.hexStringToUIColor(hex: "#2B2B2B"))
           ]
        
        
        
        

        self.pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height), pageMenuOptions: parameters)
        pageMenu?.delegate = self
        
        self.pageMenu?.moveToPage(currentIndex)
      //  let vc = controllerArray[currentIndex] as! ProductsViewController
        //vc.selectedIndex = 5
        self.view.addSubview(self.pageMenu!.view)
    
    }
  
    func willMoveToPage(_ controller: UIViewController, index: Int) {

        print(index)
        let vc = controllerArray[safe: index] as! ProductsViewController
        vc.selectedIndex = Int(collectionList[index].id!)
        vc.collectionID = collectionList[index].id!
        currentIndex = index

       // setViewControllers([controllerArray(At: index)!], direction: .forward, animated: true, completion: nil)

    }

    func didMoveToPage(_ controller: UIViewController, index: Int){
    
        print(index)
        
        
//        cv.collectionID =  collectionList[i].id!
//        cv.selectedIndex = Int(collectionList[currentIndex].id!)
     //   let collectObj = collectionList[index].title
//        //let cv = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductsVC") as! ProductsViewController
//
//        viewController.selectedIndex = 0
//       // viewController.getProducts(collectID: collectionList[index].id!)
//
//        let vc = controllerArray[safe: index] as! ProductsViewController
//        vc.selectedIndex = Int(collectionList[index].id!)
//        vc.collectionID = collectionList[index].id!
//        self.view.addSubview(self.pageMenu!.view)
//        cv.title =  collectObj!
//        cv.parentNavController = self.navigationController
//        cv.collectionID =  collectionList[index].id!
        //cv.selectedIndex = Int(collectionList[currentIndex].id!)
   //     cv.mainCollectionID = mainCollectionID
      //  controllerArray.append(cv)
     //   self.pageMenu?.moveToPage(index)
       // currentIndex = index
    }

    
    func getSelectedIndex()->Int{
        
     return 6
    }
    
}
