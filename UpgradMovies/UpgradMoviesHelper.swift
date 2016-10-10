//
//  UpgradMoviesHelper.swift
//  UpgradMovies
//
//  Created by Rahul Gupta on 10/10/16.
//  Copyright © 2016 SRS. All rights reserved.
//

import UIKit

enum SortType {
    case popularity
    case rating
}

class UpgradMoviesHelper: NSObject {
    
    class func barItemWithImage(image: UIImage, highlightedImage: UIImage, forFrame rect: CGRect, withPadding padding: CGFloat, isLeftBarButton isleftBarButton: Bool, target: AnyObject, action: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.frame = rect
        button.addTarget(target, action: action, for: .touchUpInside)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.white
        //    [button setImage:highlightedImage forState:UIControlStateHighlighted];
        if isleftBarButton {
            button.imageEdgeInsets = UIEdgeInsetsMake(0, -padding, 0, padding)
        }
        else {
            button.imageEdgeInsets = UIEdgeInsetsMake(0, padding, 0, -padding)
        }
        let customUIBarButtonItem = UIBarButtonItem(customView: button)
        return customUIBarButtonItem
    }
    
    class func Run_InMainThread(block: @escaping (Void)->Void) {
        if Thread.isMainThread {
            block()
        }
        else {
            DispatchQueue.main.async {
                (_: block())
        }
        }
    }
//Uncomment if want to use below methods
    
//    class func Run_InBackgroundThread(block: @escaping (Void)->Void) {
//        if Thread.isMainThread {
//            DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {() -> Void in
//                block()
//            }
//        }
//        else {
//            block()
//        }
//    }
//    
//    class func Run_AfterDelay(block: @escaping (Void)->Void, delay: Double) {
//        
//        let popTime = DispatchTime.init(uptimeNanoseconds: (UInt64(Int64(delay * Double(NSEC_PER_SEC)))))
//        DispatchQueue.main.asyncAfter(deadline: popTime, execute: {
//            block()
//        })
//    }
    
    class func parseMovieData(_ movieData:NSDictionary, completionHandler:(_ success:Bool,_ results:[Movie]?,_ error:NSError?)->Void){
        var arrMovie:[Movie]=[]
        if let resultsArray = movieData["results"] as? [NSDictionary]{
            if resultsArray.count == 0{
                completionHandler(false,nil,AppErrors.noResults)
            }
            else{
                for movieElement in resultsArray{
                    let movie = Movie(dictionary: movieElement)
                    arrMovie.append(movie)
                }
                completionHandler(true,arrMovie,nil)
            }
        }
        else{
            completionHandler(false,nil,nil)
        }
    }
    
}
