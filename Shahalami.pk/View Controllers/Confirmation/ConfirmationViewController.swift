//
//  ConfirmationViewController.swift
//  Shahalami.pk
//
//  Created by Ahmed on 01/11/2021.
//

import UIKit

class ConfirmationViewController: UIViewController {

    
    @IBOutlet weak var thankyouUserLbl: UILabel!
    @IBOutlet weak var contactLbl: UILabel!
    @IBOutlet weak var shippingAddressLbl: UILabel!
    @IBOutlet weak var paymentMethodLbl: UILabel!
    @IBOutlet weak var subTotalLbl: UILabel!
    @IBOutlet weak var deliveryCharges: UILabel!
    @IBOutlet weak var totalAmountLbl: UILabel!
    @IBOutlet weak var confirmationUIView: UIView!
    
    @IBOutlet weak var orderNumberLbl: UILabel!
    @IBOutlet weak var discountLbl: UILabel!
    
    var subTotal : Double = 0.0
    var totalAmount : Double = 0.0
    var shippingCharges : Double = 0.0
    var userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
    var userOrders: Orders!
    override func viewDidLoad() {
        super.viewDidLoad()

        print(userOrders as Any)
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(ConfirmationViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        thankyouUserLbl.text = "Thank you, \(userInfo?.billingAddress?.first_name ?? "")"
       
        shippingAddressLbl.text = userInfo?.billingAddress?.address1
        contactLbl.text = userInfo?.billingAddress?.phone
        
        
        subTotalLbl.text = "Rs. \(self.change_string(amount: userOrders?.total_line_items_price_set?.shop_money?.amount ?? "0") )"
        totalAmountLbl.text = "Rs. \(self.change_string(amount:userOrders?.total_price_set?.shop_money?.amount ?? "0"))"
        deliveryCharges.text = "Rs. \(self.change_string(amount:userOrders?.total_shipping_price_set?.shop_money?.amount ?? "0"))"
        orderNumberLbl.text = "Your order is confirmed with order \(userOrders.name ?? "")"
        discountLbl.text = "Rs. \(self.change_string(amount:userOrders?.total_discounts_set?.presentment_money?.amount ?? "-"))"
        //confirmationUIView.layer.cornerRadius = 25
        confirmationUIView.addShadow(opacity: 0.5, cornerRadius: 25, shadowRadius: 4.0)
        confirmationUIView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        // Do any additional setup after loading the view.
    }
    
    func change_string(amount:String) -> String {
        var string:String
      if  let index = amount.range(of: ".")?.lowerBound {
            let substring = amount[..<index]
             string = String(substring)
            print(string)
          return string
      }else{
     
          return ""
        }
    
    }
    @objc func back(sender: UIBarButtonItem) {
            // Perform your custom actions
            // ...
            // Go back to the previous ViewController
           // self.navigationController?.popViewControllerAnimated(true)
        DispatchQueue.main.async {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "contentViewController") as! TabBarViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            

        }
        
    }


}
