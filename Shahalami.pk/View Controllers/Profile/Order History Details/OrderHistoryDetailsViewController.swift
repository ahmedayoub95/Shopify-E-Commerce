//
//  OrderHistoryDetailsViewController.swift
//  Shahalami.pk
//
//  Created by Ahmed on 29/10/2021.
//

import UIKit
import CDAlertView
import SafariServices

class OrderHistoryDetailsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var bottomView: NSLayoutConstraint!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableviewHeightConstriants: NSLayoutConstraint!
    @IBOutlet weak var ordersTableVew: UITableView!
    
    @IBOutlet weak var orderNumberLbl: UILabel!
    @IBOutlet weak var dataLbl: UILabel!
    @IBOutlet weak var fullfillmentLbl: UILabel!
    @IBOutlet weak var orderStatusLbl: UILabel!
   
    @IBOutlet weak var subTotalLbl: UILabel!
    @IBOutlet weak var deliveryChargesLbl: UILabel!
    @IBOutlet weak var totalAmountLbl: UILabel!
    
    @IBOutlet weak var contactInfoLbl: UILabel!
    @IBOutlet weak var paymentMethodLbl: UILabel!
    @IBOutlet weak var shippingAddressLbl: UILabel!

    
    let counter:Int = 5
    var height:CGFloat? = nil
    
    var userInfo = AppUtility.sharedInstance.getUserData(forKey: USER_MODEL)
    var userOrders: Orders!
    var totalProductCount : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(userOrders!)
        
       
            setup()
       

    }
    

    
    // number of rows in table view
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return totalProductCount
       }
       
       // create a cell for each table view row
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
        // create a new cell if needed or reuse an old onec
        let cell:OrderDetailsTableViewCell = self.ordersTableVew.dequeueReusableCell(withIdentifier: "ordersCell") as!
           OrderDetailsTableViewCell
         //  cell.cellView.addShadow(opacity: 0.4, cornerRadius: 6, shadowRadius: 4.0)
           cell.selectionStyle = .none
           let data = userOrders.line_items![indexPath.row]
           cell.itemCount.text = "Product No. \(indexPath.row + 1)"
           if(data.variant_title != nil){
           cell.productName.text = "\(data.title ?? "")"
           }else{
               cell.productName.text = "\(data.title ?? "")"
           }
           let price = Int(self.change_string(amount:data.price ?? ""))
           cell.price.text = "Rs. \(price?.withCommas() ?? "")"
           cell.quantity.text = " QTY: \(data.quantity ?? 0) x " + "\(price?.withCommas() ?? "")"
//           cell.sku.text = data.sku
         
           
           
           return cell
       }
       
       // method to run when table view cell is tapped
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           print("You tapped cell number \(indexPath.row).")

           
       }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 97
    }
    
    func setup(){
        
        ordersTableVew.register(UINib(nibName: "OrderDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "ordersCell")
        totalProductCount = userOrders.line_items!.count
            bottomView.constant = 150
      //  tableviewHeightConstriants.constant = tableviewHeightConstriants.constant - 190
        tableviewHeightConstriants.constant = CGFloat(97 * totalProductCount)
            scrollViewHeight.constant = 860 + tableviewHeightConstriants.constant
            print("ScrollView Height: ",scrollViewHeight.constant)
        setData()
        
    }
    
    func setData(){
        orderNumberLbl.text = userOrders.name
        orderStatusLbl.text = userOrders.financial_status
        fullfillmentLbl.text = userOrders.fulfillment_status
        let subTotal = Int(self.change_string(amount:userOrders.subtotal_price ?? ""))
        subTotalLbl.text = "Rs. \(subTotal?.withCommas() ?? "")"
        let deliveryCharges = Int(self.change_string(amount:userOrders.total_shipping_price_set?.shop_money?.amount ?? ""))
        deliveryChargesLbl.text = "Rs. \(deliveryCharges?.withCommas() ?? "")"
        let totalAmount = Int(self.change_string(amount:userOrders.total_price ?? ""))
        totalAmountLbl.text = "Rs. \(totalAmount?.withCommas() ?? "")"
        contactInfoLbl.text = userOrders.contact_email
        shippingAddressLbl.text = userInfo?.billingAddress?.address1
       
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
    
    
    @IBAction func checkStatus(_ sender: Any) {
        
        let urlString = userOrders.order_status_url
        let svc = SFSafariViewController(url: URL(string: urlString!)!)
        present(svc, animated: true, completion: nil)
    }
    
}
