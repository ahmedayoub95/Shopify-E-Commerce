//
//  AppUtility.swift
//  puma-swift
//
//  Created by Elementary Logics on 12/28/16.
//  Copyright © 2016 elementary. All rights reserved.
//

import UIKit
import Foundation
import AVKit
import Photos


typealias CompletionHandlerForDialog = (_ success: ErrorDialogAction) -> ()

protocol DialogProtocol {
    func dialogResponse(action:ErrorDialogAction)
}

extension DialogProtocol{
    func dialogResponse(action:ErrorDialogAction){
        
    }
}

enum ErrorDialogAction {
    case Yes
    case No
}

protocol ErrorDialogProtocol {
    func response(action:ErrorDialogAction)
}



class AppUtility: NSObject {
    
    static var sharedInstance = AppUtility()
   
    static var isInternetDisconnected : Bool = false
    
    // MARK: color
    
     func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.utf8.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    class func color(_ rgbColor: Int) -> UIColor{
        return UIColor(
            red:   CGFloat((rgbColor & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbColor & 0x00FF00) >> 8 ) / 255.0,
            blue:  CGFloat((rgbColor & 0x0000FF) >> 0 ) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

   class func shadowToView(view:UIView,shadowColor:UIColor,radious:Float,opacity:Float) {
        
        view.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        view.layer.shadowRadius = CGFloat(radious)
        view.layer.shadowColor = shadowColor.cgColor
        view.layer.shadowOpacity = opacity
    }

    class func shadowButton(button: UIButton,shadowColor:UIColor,radious:Float,opacity:Float){
        button.layer.shadowColor = shadowColor.cgColor
        button.layer.shadowOpacity = opacity
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = CGFloat(radious)
        button.layer.shouldRasterize = true
    }
    
    //MARK:- Set bottom border only of text field
    class func bottomBorder(textfeild:UITextField) {
        let bottomLine = CALayer()
        print(textfeild.frame.width)
        bottomLine.frame = CGRect(x: 0.0, y: textfeild.frame.height - 1, width: textfeild.frame.width, height: 1.0)
        bottomLine.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        textfeild.borderStyle = UITextField.BorderStyle.none
        textfeild.layer.addSublayer(bottomLine)
    }
    
    class func getProperValidationMsg(_ message: Any?) -> String? {
        let alerts : NSMutableArray = []
        if (message is String) {
            if let aMessage = message {
                alerts.add(aMessage)
            }
        } else if (message != nil) {
            let dict = message as! [String: Any]
            for key: String? in (dict.keys) {
                var message: String? = nil
                if key == nil{
                    break
                }else{
                    if let aKey = dict[key!] {
                        message = "\(aKey)"
                    }
                    message = message?.replacingOccurrences(of: "(", with: "")
                    message = message?.replacingOccurrences(of: ")", with: "")
                    alerts.add(message ?? "")
                }
            }
        }
        let errorMessages = alerts.copy() as! NSArray
        return errorMessages.componentsJoined(by: "")
    }
    

    
   class func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    
    
    
    //MARK: - GET USER DATA
    func getUserData(forKey: String) -> UserModel? {

        let decoder = JSONDecoder()
        if let userInfo = UserDefaults.standard.data(forKey: forKey),
            let userInformation = try? decoder.decode(UserModel.self, from: userInfo) {
            return userInformation
        }
        return nil
    }
   
    //MARK: - GET PRODUCST DATA
//    func getUserData(forKey: String) -> Products? {
//
//        let decoder = JSONDecoder()
//        if let products = UserDefaults.standard.data(forKey: forKey),
//            let productInformation = try? decoder.decode(Products.self, from: products) {
//            return productInformation
//        }
//        return nil
//    }
  //  MARK: - GET TOKEN SESSION

    func getTokenSession(forKey: String) -> UserToken? {

        let decoder = JSONDecoder()
        if let userInfo = UserDefaults.standard.data(forKey: forKey),
            let userInformation = try? decoder.decode(UserToken.self, from: userInfo) {
            return userInformation
        }
        return nil
    }
   
    //MARK: - LOGOUT SESSION
    
    func removeSession(forKey: String){
        UserDefaults.standard.set(nil, forKey: forKey)
    }
    
     func removeValueFromUserDefault(key:String)
    {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key)
        defaults.synchronize()
    }
    // MARK: - popup
    
//    class func errorMessage(_ Title: String?, Message: String?) {
//    
//        ISMessages.showCardAlert(withTitle: Title, message: Message, duration: 3, hideOnSwipe: true, hideOnTap: true, alertType: .error, alertPosition: .top) { (hide) in
//            
//        }
//    }
//    
//    class func successMessage(_ Title: String?, Message: String?) {
//        ISMessages.showCardAlert(withTitle: Title, message: Message, duration: 3, hideOnSwipe: true, hideOnTap: true, alertType: .success, alertPosition: .top) { (hide) in
//            
//        }
//    }
    
    // MARK: email validation
    
    class func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    

    
    class func removeValueFromUserDefault(key:String)
    {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key)
        defaults.synchronize()
    }
    
    // MARK: storyboard
   class func getMainStoryBoard() -> UIStoryboard {
    
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        return storyboard
    
    }
    

    
    
    
    
    public static func textFieldError(textField : UITextField){
        for v in (textField.superview?.subviews)! {
            if(v.tag == 100){
                if(textField.text == ""){
                    v.backgroundColor = UIColor.red
                }else{
                    v.backgroundColor = AppUtility.sharedInstance.hexStringToUIColor(hex: "C7C7C7")
                }
                
            }
        }
    }
    
    public static func textViewError(textView : UITextView){
        for v in (textView.superview?.subviews)! {
            if(v.tag == 100){
                if(textView.text == ""){
                    v.backgroundColor = UIColor.red
                }else{
                    v.backgroundColor = AppUtility.sharedInstance.hexStringToUIColor(hex: "C7C7C7")
                }
            }
        }
    }
    
    
    public static func removeSpecialCharsFromString(text: String) -> String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        return text.filter {okayChars.contains($0) }
    }
    
    public static func checkIsSpecial(text: String) -> Bool {
       
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        if text.rangeOfCharacter(from: characterset.inverted) != nil {
            return true
        }else{
            return false
        }
        
    }
    
    
    class func shadowToAllView(view:UIView,shadowColor:UIColor,radious:Float,opacity:Float) {
        
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = CGFloat(radious)
        view.layer.shadowColor = shadowColor.cgColor
        view.layer.shadowOpacity = opacity
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
    }

    class func checkCameraAccess() -> Bool {
        var isenabled = false
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            print("Denied, request permission from settings")
            isenabled = false
        case .restricted:
            print("Restricted, device owner must approve")
            isenabled = false
        case .authorized:
            print("Authorized, proceed")
            isenabled = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    isenabled = true
                } else {
                    isenabled = false
                }
            }
        }
        
        return isenabled
    }
    
    class func checkPhotoLibraryPermission() -> Bool {
        let status = PHPhotoLibrary.authorizationStatus()
        var isenabled = false
        switch status {
        case .authorized:
            isenabled = true
        case .denied, .restricted :
            isenabled = false
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    isenabled = true
                case .denied, .restricted:
                    isenabled = false
                case .notDetermined:
                    isenabled = false
                case .limited: break
                    
                @unknown default: break
                    
                }
            }
        case .limited: break
            
        @unknown default: break
            
        }
        
        return isenabled
    }
    
    class func presentPermissionSettings(message : String) {
        let alertController = UIAlertController(title: "Permission Denied",
                                                message: message,
                                                preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Go to Settings", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                })
            }
        })
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true)
    }
    
    
    
    
}
