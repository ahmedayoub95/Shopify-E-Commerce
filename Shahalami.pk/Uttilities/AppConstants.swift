//
//  AppConstants.swift
//  Shahalami.pk
//
//  Created by Ahmed on 08/12/2021.
//


import Foundation

let BASEURL = "http://192.168.3.39:8080/hrms-exd-app/api/"



class AppTheme {
    
    static var sharedInstance = AppTheme()
    //MARK: - COLORS
    var LBL_Blue        = AppUtility.sharedInstance.hexStringToUIColor(hex: "#1173BC")
    var LBL_SEP_GRAY    = AppUtility.sharedInstance.hexStringToUIColor(hex: "#dcdcdc")
    var LBL_RED         = AppUtility.sharedInstance.hexStringToUIColor(hex: "#ff2b21")
    var LBL_BLACK       = AppUtility.sharedInstance.hexStringToUIColor(hex: "#000000")
    //var LBL_WHITE       = UIColor.white
    var LBL_BLUE        = AppUtility.sharedInstance.hexStringToUIColor(hex: "#3B5998")
 //   var LBL_DARK_GRAY   = UIColor.darkGray
    var COMPLETE        = AppUtility.sharedInstance.hexStringToUIColor(hex: "#29aa62")
    var PENDING         = AppUtility.sharedInstance.hexStringToUIColor(hex: "#ff8a00")
    var CANCEL          = AppUtility.sharedInstance.hexStringToUIColor(hex: "#dd2a2a")
    var Light_Green     = AppUtility.sharedInstance.hexStringToUIColor(hex: "#7E8C01")
    var Dark_Green      = AppUtility.sharedInstance.hexStringToUIColor(hex: "#86C33E")
    var Orange          = AppUtility.sharedInstance.hexStringToUIColor(hex: "#FF6D00")
    var Gray            = AppUtility.sharedInstance.hexStringToUIColor(hex: "#BDBDBD")
    
    
    //ERROR MESSAGES
    let errorMessage = "Something went Wrong."
    
    //MESSAGES

    let addToCart = "Product added to cart"
    let quantityAdded = "Product quantity added to cart"
    let removedFromCart = "Product removed from cart"
    let quantityDeduct = "Quantity deducted from cart"
    let productAddedToWishlist = "Product added to wishlist"
    let productRemovedFromWishlist = "Product removed from wishlist"

}

let exd_username = "userName"
let exd_password = "userPassword"



// Defaults
let defaults = UserDefaults.standard


func syncronizeDefaults() {
    
    UserDefaults.standard.synchronize()
    
}


