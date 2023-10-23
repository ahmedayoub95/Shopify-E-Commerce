//
//  TabBarViewController.swift
//  Easy Shopping
//
//  Created by XintMac on 30/07/2021.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

        tabBar.layer.cornerRadius = 22
        tabBar.layer.borderWidth = 0.5
        tabBar.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        tabBar.uiViewShadow()
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        tabBar.layer.masksToBounds = true
        
  
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.SimpleAnnimationWhenSelectItem(item)
    }
    func SimpleAnnimationWhenSelectItem(_ item: UITabBarItem){
     guard let barItemView = item.value(forKey: "view") as? UIView else { return }

     let timeInterval: TimeInterval = 0.4
     let propertyAnimator = UIViewPropertyAnimator(duration: timeInterval, dampingRatio: 0.5) {
     barItemView.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
     }
     propertyAnimator.addAnimations({ barItemView.transform = .identity }, delayFactor: CGFloat(timeInterval))
     propertyAnimator.startAnimation()
    }
    
    
    
}
