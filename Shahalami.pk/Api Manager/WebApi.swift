//
//  WebApi.swift
//  ivids
//
//
//  Created by Ahmed Ayub on 06/08/2021.
//

import UIKit
import Photos
import CoreData


class WebApi: NSObject {
    
    static let manager = WebApi()
    static var ErrorBlock: ((_ errorTitle: String?, _ errorMessage: String?) -> Void)?
    
    func showNetworkConnectivityError() {
        WebApi.ErrorBlock!("Error","Netwrok Error" );
    }
    
    class func showServerError(with errorDesc: String?) {
        WebApi.ErrorBlock!("Error", errorDesc)
    }
    
    class func showDataFetchingError(with errorDesc: String?) {
        WebApi.ErrorBlock!("Error", errorDesc)
    }
    
    
    
    
    
    
    //MARK:- Send Otp  APi
    
    
//    class func loginApi(_ params: [String : Any ]?, withCompletionHandler completion: @escaping (_ returbObj: Login) -> Void, didFailWithError Error: @escaping (_ errorTitle: String?, _ errorMessage: String?) -> Void) {
//
        

//        
//    
//    
//       class func sendOtp(params: [String:Any],completionHandler : @escaping(Result<forgotPassword, Error>)-> Void ) {
//            let urlString = BASEURL + "sendOtp"
//            
//            let url = URL(string: urlString)!
//            print("Api url :\(urlString)")
//            
//            HttpClient.servicesManager.postForgotApi(requestUrl: url, params: params, resultType: forgotPassword.self) { (resp) in
//                switch resp {
//                case .success(let resp):
//                    print(resp as Any)
//                    completionHandler(.success(resp!))
//                case .failure(let error):
//                    completionHandler(.failure(error))
//                    print(error)
//                }
//            
//            
//            }
//            
//        }
//    class func verifyOtp(params: [String:Any],completionHandler : @escaping(Result<verifyOTP, Error>)-> Void ) {
//         let urlString = BASEURL + "verifyOtp"
//         
//         let url = URL(string: urlString)!
//         print("Api url :\(urlString)")
//         
//         HttpClient.servicesManager.postForgotApi(requestUrl: url, params: params, resultType: verifyOTP.self) { (resp) in
//             switch resp {
//             case .success(let resp):
//                 print(resp as Any)
//                 completionHandler(.success(resp!))
//             case .failure(let error):
//                 completionHandler(.failure(error))
//                 print(error)
//             }
//         
//         
//         }
//         
//     }
//    
//    class func resetPasswordApi(params: [String:Any],completionHandler : @escaping(Result<resetPassword, Error>)-> Void ) {
//         let urlString = BASEURL + "resetPassword?"
//         
//         let url = URL(string: urlString)!
//         print("Api url :\(urlString)")
//         
//         HttpClient.servicesManager.postForgotApi(requestUrl: url, params: params, resultType: resetPassword.self) { (resp) in
//             switch resp {
//             case .success(let resp):
//                 print(resp as Any)
//                 completionHandler(.success(resp!))
//             case .failure(let error):
//                 completionHandler(.failure(error))
//                 print(error)
//             }
//         
//         
//         }
//         
//     }
    
    
    
    func fetchWishlist(params: [String:Any],completionHandler : @escaping(Result<Favourites, Error>)-> Void ){
        
        let urlString = ServerManager.sharedInstance.exdURL + "viewUserProducts"
        let fileUrl = URL(string: urlString)
        print("Api url :\(urlString)")
        HttpClient.servicesManager.postFetchWishlist(requestUrl:fileUrl!, params: params, resultType: Favourites.self){ (resp) in
            switch resp {
            case .success(let resp):
                print(resp as Any)
                completionHandler(.success(resp!))
            case .failure(let error):
                completionHandler(.failure(error))
                print(error)
            }
        }

    }
    
    
    func addtoWishlistNew(params: [String:Any],completionHandler : @escaping(Result<AddFavourites, Error>)-> Void ) {
        let urlString = ServerManager.sharedInstance.exdURL + "addUserProduct"
        
        let url = URL(string: urlString)!
        print("Api url :\(urlString)")
        
        HttpClient.servicesManager.newNetwork(requestUrl: url, params: params, resultType: AddFavourites.self) { (resp) in
            switch resp {
            case .success(let resp):
                print(resp as Any)
                completionHandler(.success(resp!))
            case .failure(let error):
                completionHandler(.failure(error))
                print(error)
            }
        
        }
    }
 //MARK: - FETCH BRANDS
    
    func getBrands(completionHandler : @escaping(Result<Brands, Error>)-> Void ){
        
        let urlString = ServerManager.sharedInstance.exdURL + "brands"
        let fileUrl = URL(string: urlString)
        print("Api url :\(urlString)")
        HttpClient.servicesManager.getBannerFromShopify(requestUrl:fileUrl!,resultType: Brands.self){ (resp) in
            switch resp {
            case .success(let resp):
                print(resp as Any)
                completionHandler(.success(resp!))
            case .failure(let error):
                completionHandler(.failure(error))
                print(error)
            }
        }

    }
    
    
    //MARK: - SEARCH API
    
    func searchProducts(completionHandler : @escaping(Result<Brands, Error>)-> Void ){
        
        let urlString = ServerManager.sharedInstance.exdURL + "brands"
        let fileUrl = URL(string: urlString)
        print("Api url :\(urlString)")
        HttpClient.servicesManager.getBannerFromShopify(requestUrl:fileUrl!,resultType: Brands.self){ (resp) in
            switch resp {
            case .success(let resp):
                print(resp as Any)
                completionHandler(.success(resp!))
            case .failure(let error):
                completionHandler(.failure(error))
                print(error)
            }
        }

    }
    

    //MARK: - Search
    
    class func dashboard(params: String,completionHandler : @escaping(Result<SearchResponse, Error>)-> Void ){
        let urlString = ServerManager.sharedInstance.searchProductUrl + "q=\(params.trimmingCharacters(in: .whitespaces))&resources[type]=product".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    
        print("Api url :\(urlString)")
       HttpClient.servicesManager.getRequest(urlString: urlString, resultType: SearchResponse.self) { (resp) in
           switch resp {
           case .success(let resp):
               print(resp as Any)
               completionHandler(.success(resp!))
           case .failure(let error):
               completionHandler(.failure(error))
               print(error)
           }
       }

    }
    
    //MARK: - getservices Api
    class func getAllCategories(withCompletionHandler completion: @escaping (_ returbObj: Categories?) -> Void, didFailWithError Error: @escaping (_ errorTitle: String?, _ errorMessage: String?) -> Void) {
        
        let urlString = ServerManager.sharedInstance.exdURL + "categories"
        
        HttpClient.servicesManager.getRequest(urlString: urlString, completion: { (result, error) -> Void in
            if((error) != nil)
            {
                Error("Error",error?.localizedDescription)
            }
            else
            {
                if(result!.count > 0){
                    let fetchingError: Error? = nil
                    let response = Categories(dictionary:result!)

                    print(response)
                    if(fetchingError == nil)
                    {
                        completion(response)
                    }
                }else
                {
                   // completion(error?.localizedDescription)
                }

                
            }
            
            
        })
    }
    
    // +

//    class func checkin(params: [String:Any],completionHandler : @escaping(Result<Attendance, Error>)-> Void ) {
//         let urlString = BASEURL + "markAttendance"
//         
//         let url = URL(string: urlString)!
//         print("Api url :\(urlString)")
//         
//         HttpClient.servicesManager.postApiData(requestUrl: url, params: params, resultType: Attendance.self) { (resp) in
//             switch resp {
//             case .success(let resp):
//                 print(resp as Any)
//                 completionHandler(.success(resp!))
//             case .failure(let error):
//                 completionHandler(.failure(error))
//                 print(error)
//             }
//         
//         }
//     }
//    class func getHistory(params: [String:Any],completionHandler : @escaping(Result<AttendanceHistory, Error>)-> Void ) {
//         let urlString = BASEURL + "getAttendanceHistory"
//         
//         let url = URL(string: urlString)!
//         print("Api url :\(urlString)")
//         
//         HttpClient.servicesManager.postApiData(requestUrl: url, params: params, resultType: AttendanceHistory.self) { (resp) in
//             switch resp {
//             case .success(let resp):
//                 print(resp as Any)
//                 completionHandler(.success(resp!))
//             case .failure(let error):
//                 completionHandler(.failure(error))
//                 print(error)
//             }
//         
//         }
//     }
//    class func getProfile(params: [String:Any],completionHandler : @escaping(Result<Profile, Error>)-> Void ) {
//         let urlString = BASEURL + "profile"
//         
//         let url = URL(string: urlString)!
//         print("Api url :\(urlString)")
//         
//         HttpClient.servicesManager.postApiData(requestUrl: url, params: params, resultType: Profile.self) { (resp) in
//             switch resp {
//             case .success(let resp):
//                 print(resp as Any)
//                 completionHandler(.success(resp!))
//             case .failure(let error):
//                 completionHandler(.failure(error))
//                 print(error)
//             }
//         
//         }
//     }
//        HttpClient.postRequest(input: params! as NSDictionary, urlString: urlString, token: "", completion: { (result, error) -> Void in
//            if((error) != nil)
//            {
//                Error("Error",error?.localizedDescription)
//            }
//            else
//            {
//                if(result?.object(forKey: "isSuccessful") as! Bool)
//                {
//                    print(result as Any)
//                    let fetchingError: Error? = nil
//
//                    let message = result?.object(forKey: "responseMessage") as? String
//                    let objData = result?.object(forKey: "data")
//                    let jsonDecoder = JSONDecoder()
//                    let responseModel = try jsonDecoder.decode(Login.self, from: objData)
//
//                    if(fetchingError == nil)
//                    {
//                        completion(responseModel)
//                    }
//
//                }
//                else
//                {
//                    let error = result?.object(forKey: "errors") as? [String]
//                    Error("Error",error?.first)
//                }
//            }
//        })
    
    

//       class func fetchWishlist(_ params: [String : Any]?, withCompletionHandler completion: @escaping (_ returbObj: String) -> Void, didFailWithError Error: @escaping (_ errorTitle: String?, _ errorMessage: String?) -> Void) {
//
//
//            let urlString = ServerManager.sharedInstance.exdURL + "viewUserProducts"
//
//           HttpClient.servicesManager.postRequest(input: params! as NSDictionary, urlString: urlString, token: "", completion: { (result, error) -> Void in
//
//            if((error) != nil)
//            {
//                Error("Error",error?.localizedDescription)
//            }
//            else
//            {
//                if(result?.object(forKey: "isSuccessfull") as! Bool)
//                {
//                    print(result as Any)
//                    let fetchingError: Error? = nil
//
//                    let message = result?.object(forKey: "product_ids") as? String
//                    if(fetchingError == nil)
//                    {
//                        completion(message!)
//                    }
//                }
//                else
//                {
//
//                    completion(error?.localizedDescription ?? "Error")
//                }
//            }
//        })
//    }
//

    class func verifiyOtp(_ params: [String : Any]?, withCompletionHandler completion: @escaping (_ returbObj: String) -> Void, didFailWithError Error: @escaping (_ errorTitle: String?, _ errorMessage: String?) -> Void) {


         let urlString = BASEURL + "verifyOtp"
         
        HttpClient.servicesManager.postRequest(input: params! as NSDictionary, urlString: urlString, token: "", completion: { (result, error) -> Void in
         if((error) != nil)
         {
             Error("Error",error?.localizedDescription)
         }
         else
         {
             if(result?.object(forKey: "isSuccessful") as! Bool)
             {
                 print(result as Any)
                 let fetchingError: Error? = nil

                 let message = result?.object(forKey: "message") as? String
                 if(fetchingError == nil)
                 {
                     completion(message!)
                 }
             }
             else
             {
                 let error = result?.object(forKey: "errors") as? [String]
                 Error("Error",error?.first)
             }
         }
     })
 }
    
    
    //deleteRequest
    
    
   class func deleteUser(urlString:String?,completionHandler : @escaping(Result<DeleteAccountModel, Error>)-> Void ) {
     //   let urlString = BASEURL + "user/register"

        let url = URL(string: urlString ?? "")!
      
       HttpClient.servicesManager.deleteRequest(requestUrl: url, params: [:], resultType:DeleteAccountModel.self) { (resp) in
            switch resp {
            case .success(let resp):
                print(resp as Any)
                completionHandler(.success(resp!))
            case .failure(let error):
                completionHandler(.failure(error))
                print(error)
            }
        
        }
    }
    
    
//
//    //MARK:- Verify Otp  APi
//
//    class func verifyOtp(_ params: [String : Any ]?, withCompletionHandler completion: @escaping (_ returbObj: NSDictionary) -> Void, didFailWithError Error: @escaping (_ errorTitle: String?, _ errorMessage: String?) -> Void) {
//
//
//        let urlString = BASEURLCreateUSER + "code-verification"
//        print("Api url :\(urlString)")
//        HttpClient.postRequest(input: params! as NSDictionary, urlString: urlString, token: "", completion: { (result, error) -> Void in
//            if((error) != nil)
//            {
//                Error("Error",error?.localizedDescription)
//            }
//            else
//            {
//                if(result?.object(forKey: "success") as! Bool)
//                {
//                    print(result as Any)
//                    let fetchingError: Error? = nil
//
//
//                    let objData = result?.object(forKey: "data") as? NSDictionary
//                    UtilityFunctions.saveUserToken(token: objData?.object(forKey: "token") as! String)
//                    //    DataManager.shared.getUserToken(token: objData?.object(forKey: "token") as! String)
//                    print(objData)
//                    let  user = objData?.object(forKey: "user")
//
//                    let userProfileUpdate = UserModel(dictionary:(user as? NSDictionary)!)
//                    UtilityFunctions.saveUser(userData: userProfileUpdate)
//
//                    if(fetchingError == nil)
//                    {
//
//                        completion(objData!)
//                    }
//
//                }
//                else
//                {
//                    let error = result?.object(forKey: "errors") as? [String]
//                    Error("Error",error?.first)
//                }
//            }
//        })
//    }
//
//    //MARK:- getservices Api
//    class func GETTRANSPORTSERVICE(_ params: [String : Any ]?, withCompletionHandler completion: @escaping (_ returbObj: TransportData?) -> Void, didFailWithError Error: @escaping (_ errorTitle: String?, _ errorMessage: String?) -> Void) {
//
//        let urlString = BASEURLCARPORATETICKETS + "bus/getTransportService"
//        print("Api url :\(urlString)")
//        HttpClient .getRequest(input:[:], urlString: urlString, token: userToken, completion: { (result, error) -> Void in
//            if((error) != nil)
//            {
//                Error("Error",error?.localizedDescription)
//
//            }
//            else
//            {
//                if(result?.object(forKey: "success") as! Bool)
//                {
//                    DispatchQueue.global(qos: .userInitiated).async {
//                        print("This is run on a background queue")
//
//
//
//                        let fetchingError: Error? = nil
//                        let objData = result?.object(forKey: "data") as? NSDictionary
//                        let transportData = TransportData(dictionary:objData! )
//                        DispatchQueue.main.async {
//                            print("This is run on the main queue, after the previous code in outer block")
//                            if(fetchingError == nil)
//                            {
//                                completion(transportData)
//                            }
//                        }
//
//
//                    }
//                }
//                else
//                {
//                    let error = result?.object(forKey: "errors") as? [String]
//                    Error("Error",error?.first)
//                }
//            }
//        })
//    }
//
//    //MARK:- get BusTimings Api
//    class func getTransportServiceTimes(_ params: [String : Any ]?, withCompletionHandler completion: @escaping (_ returbObj: TransportTimings?) -> Void, didFailWithError Error: @escaping (_ errorTitle: String?, _ errorMessage: String?) -> Void) {
//
//        let urlString = BASEURLCARPORATETICKETS + "bus/trips?"
//        print("Api url :\(urlString)")
//        HttpClient .getRequest(input:params! as NSDictionary, urlString: urlString, token: userToken, completion: { (result, error) -> Void in
//            if((error) != nil)
//            {
//                Error("Error",error?.localizedDescription)
//
//            }
//            else
//            {
//                if(result?.object(forKey: "success") as! Bool)
//                {
//                    let fetchingError: Error? = nil
//                    let objData = result?.object(forKey: "data") as? NSDictionary
//                    let transportData = TransportTimings(dictionary:objData! )
//                    if(fetchingError == nil)
//                    {
//                        completion(transportData)
//                    }
//
//                }
//                else
//                {
//                    let error = result?.object(forKey: "errors") as? [String]
//                    Error("Error",error?.first)
//                }
//            }
//        })
//    }
//
//
//    //MARK:- get BusSeatPlan Api
//    class func getBusSeatPlan(_ params: [String : Any ]?, withCompletionHandler completion: @escaping (_ returbObj: availableSeatsData?) -> Void, didFailWithError Error: @escaping (_ errorTitle: String?, _ errorMessage: String?) -> Void) {
//
//        let urlString = BASEURLCARPORATETICKETS + "bus/seat-plan?"
//        print("Api url :\(urlString)")
//        HttpClient .getRequest(input:params! as NSDictionary, urlString: urlString, token: userToken, completion: { (result, error) -> Void in
//            if((error) != nil)
//            {
//                Error("Error",error?.localizedDescription)
//
//            }
//            else
//            {
//                if(result?.object(forKey: "success") as! Bool)
//                {
//                    let fetchingError: Error? = nil
//
//                    let objData = result?.object(forKey: "data") as? NSDictionary
//                    print(objData!)
//                    let seatsPlan = availableSeatsData(dictionary:objData!)
//
//                    if(fetchingError == nil)
//                    {
//                        completion(seatsPlan)
//                    }
//
//                }
//                else
//                {
//                    let error = result?.object(forKey: "errors") as? [String]
//                    Error("Error",error?.first)
//                }
//            }
//        })
//    }
//
//    //MARK:- busSeatsBookingApi APi
//    class func busSeatsBookingApi(_ params: [String : Any ]?, withCompletionHandler completion: @escaping (_ returbObj: NSDictionary) -> Void, didFailWithError Error: @escaping (_ errorTitle: String?, _ errorMessage: String?) -> Void) {
//
//
//        let urlString = BASEURLNewMytmTravels + "order/create-new"
//        print("Api url :\(urlString)")
//
//        HttpClient .postRequest(input: params! as NSDictionary, urlString: urlString , token : userToken, completion: { (result, error) -> Void in
//            if((error) != nil)
//            {
//                Error("Error",error?.localizedDescription)
//            }
//            else
//            {
//                if(result?.object(forKey: "success") as! Bool)
//                {
//                    print(result as Any)
//                    let fetchingError: Error? = nil
//
//                    let objData = result?.object(forKey: "data") as? NSDictionary
//                    DataManager.shared.getUserToken(token: objData?.object(forKey: "token") as! String)
//                    print(objData)
//                    let  user = objData?.object(forKey: "user")
//
//                    let userProfileUpdate = UserModel(dictionary:(user as? NSDictionary)!)
//                    UtilityFunctions.saveUser(userData: userProfileUpdate)
//
//                    if(fetchingError == nil)
//                    {
//
//                        completion(objData!)
//                    }
//
//                }
//                else
//                {
//                    let error = result?.object(forKey: "message") as? [String]
//                    Error("Error",error?.first)
//                }
//            }
//        })
//    }
//
//
//
//    //MARK:- getMybookings Api
//    class func getMybookings(_ params: [String : Any ]?, withCompletionHandler completion: @escaping (_ returbObj: MyBookingsModel?) -> Void, didFailWithError Error: @escaping (_ errorTitle: String?, _ errorMessage: String?) -> Void) {
//
//        let urlString = BASEURLNewMytmTravels + "orders"
//        print("Api url :\(urlString)")
//        HttpClient .getRequest(input:params! as NSDictionary, urlString: urlString ,token :userToken, completion: { (result, error) -> Void in
//            if((error) != nil)
//            {
//                Error("Error",error?.localizedDescription)
//
//            }
//            else
//            {
//                if(result?.object(forKey: "success") as! Bool)
//                {
//                    let fetchingError: Error? = nil
//
//                    let objData = result?.object(forKey: "data") as? NSDictionary
//                    print(objData!)
//                    let myBookingsData = MyBookingsModel(dictionary:result!)
//
//                    if(fetchingError == nil)
//                    {
//                        completion(myBookingsData)
//                    }
//
//                }
//                else
//                {
//                    let error = result?.object(forKey: "errors") as? [String]
//                    Error("Error",error?.first)
//                }
//            }
//        })
//    }
//
//
//
//    //MARK:- getProductByCategories Api
//    class func getProductByCategories(_ params: [String : Any ]?, withCompletionHandler completion: @escaping (_ returbObj: [ProductModel]?) -> Void, didFailWithError Error: @escaping (_ errorTitle: String?, _ errorMessage: String?) -> Void) {
//
//        let urlString = Base_Url
//
//        HttpClient .getRequest(input:params! as NSDictionary, urlString: urlString, token: userToken, completion: { (result, error) -> Void in
//            if((error) != nil)
//            {
//                Error("Error",error?.localizedDescription)
//            }
//            else
//            {
//
//
//            }
//        })
//    }
//
//    class func fetchBookingHistory(_ params: [String : Any ]?, withCompletionHandler completion: @escaping (_ returbObj: String) -> Void, didFailWithError Error: @escaping (_ errorTitle: String?, _ errorMessage: String?) -> Void) {
//
//
//        let urlString = BASEURLCreateUSER + "create"
//        print("Api url :\(urlString)")
//        HttpClient .postRequest(input: params! as NSDictionary, urlString: urlString, token: "", completion: { (result, error) -> Void in
//            if((error) != nil)
//            {
//                Error("Error",error?.localizedDescription)
//            }
//            else
//            {
//                if(result?.object(forKey: "success") as! Bool)
//                {
//                    print(result as Any)
//                    let fetchingError: Error? = nil
//
//                    let message = result?.object(forKey: "message") as? String
//
//                    let objData = result?.object(forKey: "data") as? NSDictionary
//
//                    //
//
//
//                    if(fetchingError == nil)
//                    {
//
//                        completion(message!)
//                    }
//
//                }
//                else
//                {
//                    let error = result?.object(forKey: "errors") as? [String]
//                    Error("Error",error?.first)
//                }
//            }
//        })
//    }
//
//
//    //Air API's
//    class func SEARCHAIRLINES(_ params: [String : Any ]?, withCompletionHandler completion: @escaping (_ returbObj: Pokedex?) -> Void, didFailWithError Error: @escaping (_ errorTitle: String?, _ errorMessage: String?) -> Void) {
//
//        let urlString = BASEURLNewMytmTravels + "search"
//        print("Api url :\(urlString)")
//        HttpClient .getRequest(input:params! as NSDictionary, urlString: urlString, token: userToken, completion: { (result, error) -> Void in
//            if((error) != nil)
//            {
//                Error("Error",error?.localizedDescription)
//
//            }
//            else
//            {
//                if(result?.object(forKey: "success") as! Bool)
//                {
//                    let fetchingError: Error? = nil
//
//                    let transportData = Pokedex(dictionary:result! )
//                    if(fetchingError == nil)
//                    {
//                        completion(transportData)
//                    }
//
//                }
//                else
//                {
//                    let error = result?.object(forKey: "errors") as? [String]
//                    Error("Error",error?.first)
//                }
//            }
//        })
//    }
//

}
