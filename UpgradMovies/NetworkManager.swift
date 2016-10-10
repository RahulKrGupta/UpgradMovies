//
//  NetworkManager.swift
//  UpgradMovies
//
//  Created by Rahul Gupta on 10/10/16.
//  Copyright © 2016 SRS. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    class func getData(URLString: URLConvertible,parameters: [String: AnyObject]?,encoding: ParameterEncoding = JSONEncoding.default,headers: [String: String]?,completionHandler:@escaping (DataResponse<Any>)->Void){
        Alamofire.request(URLString, method:.get, parameters: parameters, encoding: encoding, headers: headers).responseJSON(completionHandler: {response in
            completionHandler(response)}
        )
    }
}
