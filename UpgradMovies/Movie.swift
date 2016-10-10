//
//  Movie.swift
//  UpgradMovies
//
//  Created by Rahul Gupta on 10/10/16.
//  Copyright © 2016 SRS. All rights reserved.
//

import Foundation

class Movie {
    var title:String=Constants.noData
    var thumbnailURL:String=Constants.noURL
    var synopsis:String=Constants.noData
    var averageRating:Float=0.0
    var popularity:Double=0.0
    var releaseDate:String=Constants.noData // No use of date, hence temporarily using as string
    
    init(dictionary:NSDictionary){
        self.title = dictionary["title"] as? String ?? Constants.noData
        self.synopsis = dictionary["overview"] as? String ?? Constants.noData
        self.releaseDate = dictionary["release_date"] as? String ?? Constants.noData
        //as per documentation poster_path can be null
        if !(dictionary["poster_path"] is NSNull){
            self.thumbnailURL = dictionary["poster_path"] as? String ?? Constants.noData
            let rangeToBeRemoved = self.thumbnailURL.startIndex..<self.thumbnailURL.characters.index(self.thumbnailURL.startIndex, offsetBy: 1)
            self.thumbnailURL.removeSubrange(rangeToBeRemoved)
        }
        self.averageRating = dictionary["vote_average"] as? Float ?? 0.0
        self.popularity = dictionary["popularity"] as? Double ?? 0.0
    }
}
