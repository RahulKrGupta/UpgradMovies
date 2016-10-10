//
//  AppErrors.swift
//  UpgradMovies
//
//  Created by Rahul Gupta on 10/10/16.
//  Copyright © 2016 SRS. All rights reserved.
//

import Foundation

class AppErrors {
    static let noResults = NSError(domain:"UpgradMovies.NoResults",code:10000,userInfo:nil)
    
    class func errorMessage(_ code:Int)->String{
        switch code {
        case 10000:
            return Constants.noMoreResults
        default:
            return Constants.unknownError
        }
    }
}
