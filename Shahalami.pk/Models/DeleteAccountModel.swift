//
//  DeleteAccountModel.swift
//  Shahalami.pk
//
//  Created by Ahmed on 08/09/2022.
//

import Foundation

struct DeleteAccountModel : Codable {
    
    var data : String?
    
    enum CodingKeys: String, CodingKey {
        
        case data = "data"
       
    }
    
    init(){
        
        data = ""

    }
}
