//
//  FetchManager.swift
//  UpgradMovies
//
//  Created by Rahul Gupta on 10/10/16.
//  Copyright © 2016 SRS. All rights reserved.
//

import Foundation
//import Alamofire

class FetchManager {
    
    class func fetchPopularMovies(_ currentPage:Int,completionHandler:@escaping (_ success:Bool,_ results:[Movie]?,_ error:NSError?)->Void){
        var popularMovieURL = Constants.popularMovieURL
        
        //if paginated call append page number to URL
        if currentPage > 1{
            popularMovieURL += "&page=\(currentPage)"
        }
        
        NetworkManager.getData(URLString: popularMovieURL, parameters: nil, headers: nil, completionHandler: {response in
            if response.result.error != nil{
                completionHandler( false, nil, response.result.error! as NSError?)
            }
            else{
                if let movieDataDictionary = response.result.value as? NSDictionary{
                    UpgradMoviesHelper.parseMovieData(movieDataDictionary, completionHandler: completionHandler)
                }
               // completionHandler(success: true,error: nil)
            }
        })
    }
}
