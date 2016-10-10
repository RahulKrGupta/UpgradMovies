//
//  MovieDetailsViewController.swift
//  UpgradMovies
//
//  Created by Rahul Gupta on 10/10/16.
//  Copyright © 2016 SRS. All rights reserved.
//

import UIKit
import SDWebImage

class MovieDetailsViewController: UIViewController {
    var selectedMovie:Movie?

    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var averageRatingLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Constants.App_Theme_Color
        self.navigationController?.navigationBar.backgroundColor = Constants.App_Theme_Color
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initWithData()
        self.title = Constants.details
    }
    
    func initWithData(){
        if self.selectedMovie != nil{
            self.titleLabel.text = self.selectedMovie!.title
            self.synopsisLabel.text = self.selectedMovie!.synopsis
            self.popularityLabel.text = "\(self.selectedMovie!.popularity)"
            self.averageRatingLabel.text = "\(self.selectedMovie!.averageRating)"
            self.releaseDateLabel.text = self.selectedMovie!.releaseDate
            
            if self.selectedMovie!.thumbnailURL != Constants.noURL{
                let imageURLString = Constants.imageURLPrefix + self.selectedMovie!.thumbnailURL
                let url = URL(string: imageURLString)
                self.thumbnailImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "movie_icon"))
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
