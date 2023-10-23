//
//  CommonMethods.swift
//  Easy Shopping
//
//  Created by XintMac on 03/08/2021.
//

import Foundation
import NVActivityIndicatorView
import MaterialComponents.MaterialSnackbar
class CommonMethods: NSObject {
    
    
    static func animator(view : UIView) {
        var activityIndicator : NVActivityIndicatorView!
        let frame = CGRect(x: 0, y: 0, width: 60, height: 50)
        activityIndicator = NVActivityIndicatorView(frame: frame)
        activityIndicator.type = .ballPulseSync
        activityIndicator.color = #colorLiteral(red: 0.1490196078, green: 0.168627451, blue: 0.3725490196, alpha: 1)
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    static func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
     
    
    static func doSomething(view:UIViewController ,actionClosure: @escaping () -> Void) {
       
  
       
       let action = MDCSnackbarMessageAction()
       let actionHandler = {() in
          
          actionClosure()
          
       }
       
       action.handler = actionHandler
       action.title = "Try Again"
       let message = MDCSnackbarMessage()
       message.action = action
       message.text = "Please check your internet!"
       message.duration = 10.0
       MDCSnackbarManager.default.show(message)
       MDCSnackbarManager.default.snackbarMessageViewBackgroundColor = #colorLiteral(red: 0.06612512469, green: 0.4526025057, blue: 0.7391296029, alpha: 1)
       
       
       
       
    }
    
//  static func showMessage(message: String?) {
//        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
//            alert.dismiss(animated: true) {
//            }
//        }))
//      self.present(alert, animated: true, completion: nil)
//    }

    
    
   
}
extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
