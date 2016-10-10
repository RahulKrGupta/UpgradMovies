//
//  Constants.swift
//  UpgradMovies
//
//  Created by Rahul Gupta on 10/10/16.
//  Copyright © 2016 SRS. All rights reserved.
//

import Foundation
import UIKit
struct Constants {
    static let movieDBKey="d72f518fa6f086fc2b468761d49a62bf"
    static let popularMovieURL="https://api.themoviedb.org/3/movie/popular?api_key=\(Constants.movieDBKey)"
    static let imageURLPrefix="http://image.tmdb.org/t/p/w185///"
    
    static let noURL="No URL"
    static let noData = "No data"
    
    static let details = "Details"
    
    //error messages
    static let unknownError = "Unknown Error"
    static let noMoreResults = "No more results"
    
    //alert messages
    static let chooseSortMethod = "Choose Sort Setting:"
    static let alertMsg = "Popularity or Rating, its your way."
    static let sortByPopularity = "Sort by popularity"
    static let sortByRating = "Sort by rating"
    
    
    static let cancel = "Cancel"
    static let App_Theme_Color = UIColor.init(red: 34/255, green: 35/255, blue: 36/255, alpha: 1)
    static let movieList = "Movie List"
}
