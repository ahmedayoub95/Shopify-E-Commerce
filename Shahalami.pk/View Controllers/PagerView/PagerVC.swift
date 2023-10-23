//
//  ViewController.swift
//  PageViewControllerWithTabs
//
//  Created by Leela Prasad on 22/03/18.
//  Copyright © 2018 Leela Prasad. All rights reserved.
//

import UIKit
import ViewPager_Swift

class PagerVC: UIViewController {


    
    @IBOutlet weak var menuBarView: MenuTabsView!
    
    
    var collectionList = [ChildCategory]()
    var isComingFromCategories:Int?
    var mainCollectionID = ""
    var currentIndex :Int = 0
    var tabs = [String]()
    var pageController: UIPageViewController!
    var isComingFromHomeIndex :Int?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        for i in 0..<(collectionList.count){
            let collectObj = collectionList[i].title!
            tabs.append(collectObj)
        }
        

        
     // menuBarView.layoutSetting(menuBarView.collView)
        menuBarView.dataArray = tabs
        menuBarView.isSizeToFitCellsNeeded = true
        menuBarView.collView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
     
        
        presentPageVCOnView()
        
        menuBarView.menuDelegate = self
        pageController.delegate = self
        pageController.dataSource = self
        

        print(isComingFromCategories ?? 1)
        //For Intial Display
        let index = NSIndexPath(item: isComingFromCategories ?? 1,section:0)
        menuBarView.collView.selectItem(at: IndexPath.init(item: isComingFromCategories ?? 1,section:0), animated: true, scrollPosition: .centeredVertically)
        menuBarView.collView.scrollToItem(at: IndexPath.init(item: isComingFromCategories ?? 1, section: 0), at: .centeredHorizontally, animated: true)
        
        
        pageController.setViewControllers([viewController(At: isComingFromCategories ?? 1)!], direction: .forward, animated: true, completion: nil)
     
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        menuBarView.collView.scrollToItem(at: IndexPath.init(item: isComingFromCategories ?? 1, section: 0), at: .centeredHorizontally, animated: true)
    }


    func presentPageVCOnView() {
        
        self.pageController = storyboard?.instantiateViewController(withIdentifier: "PageControllerVC") as! PageControllerVC
        self.pageController.view.frame = CGRect.init(x: 0, y: menuBarView.frame.maxY, width: self.view.frame.width, height: self.view.frame.height - menuBarView.frame.maxY)
        self.addChild(self.pageController)
        self.view.addSubview(self.pageController.view)
        self.pageController.didMove(toParent: self)
        
    }

    
    func viewController(At index: Int) -> UIViewController? {
        
        if((self.menuBarView.dataArray.count == 0) || (index >= self.menuBarView.dataArray.count)) {
            return nil
        }
    
        let contentVC = storyboard?.instantiateViewController(withIdentifier: "ProductsVC") as! ProductsViewController
        contentVC.strTitle = tabs[index]
        contentVC.pageIndex = index
        currentIndex = index
        contentVC.mainCollectionID = mainCollectionID
        contentVC.collectionID = collectionList[index].id!
        return contentVC
        
    }
}
extension PagerVC: MenuBarDelegate {

    func menuBarDidSelectItemAt(menu: MenuTabsView, index: Int) {

        if index != currentIndex {

            if index > currentIndex {
                self.pageController.setViewControllers([viewController(At: index)!], direction: .forward, animated: true, completion: nil)
            }else {
                self.pageController.setViewControllers([viewController(At: index)!], direction: .reverse, animated: true, completion: nil)
            }

            menuBarView.collView.scrollToItem(at: IndexPath.init(item: index, section: 0), at: .centeredHorizontally, animated: true)

        }

    }

}


extension PagerVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! ProductsViewController).pageIndex
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index -= 1
        return self.viewController(At: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! ProductsViewController).pageIndex
        
        if (index == tabs.count) || (index == NSNotFound) {
            return nil
        }
        
        index += 1
        return self.viewController(At: index)
        
    }
   
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if finished {
            if completed {
                let cvc = pageViewController.viewControllers!.first as! ProductsViewController
                let newIndex = cvc.pageIndex
                menuBarView.collView.selectItem(at: IndexPath.init(item: newIndex, section: 0), animated: true, scrollPosition: .centeredVertically)
                menuBarView.collView.scrollToItem(at: IndexPath.init(item: newIndex, section: 0), at: .centeredHorizontally, animated: true)
            }
        }
        
    }
    
}
