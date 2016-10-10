//
//  ViewController.swift
//  UpgradMovies
//
//  Created by Rahul Gupta on 10/10/16.
//  Copyright © 2016 SRS. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

class MovieListViewController: UIViewController,UISearchResultsUpdating,UISearchControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var movieList:[Movie]=[]
    var searchArr:[Movie]=[]
    
    var scrollOffset:CGFloat?
    var currentPage=1
    
    var searchController : UISearchController?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchData(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Movies"
        self.setNavigationHeader()
        self.removeSearchBar()
        self.view.backgroundColor = Constants.App_Theme_Color
        self.navigationController?.navigationBar.backgroundColor = Constants.App_Theme_Color
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchData(_ isPaginating:Bool){
        
        if isPaginating == true{
            self.currentPage += 1
        }
        UpgradMoviesHelper.Run_InMainThread {
         SVProgressHUD.show(withStatus: "Fetching data from Server")
        }
        FetchManager.fetchPopularMovies(self.currentPage,completionHandler: {success,arrResults,error in
            UpgradMoviesHelper.Run_InMainThread {
                SVProgressHUD.dismiss()
            }
            
            if success==true{
                if isPaginating == false{
                    self.movieList=arrResults!
                }
                else{
                    self.movieList += arrResults!
                }
                UpgradMoviesHelper.Run_InMainThread {
                    self.collectionView.reloadData()
                }
            }
            else{
                if error != nil{
                    UpgradMoviesHelper.Run_InMainThread {
                        //SVProgressHUD.showInfo(withStatus: "Failed to connect")
                        SVProgressHUD.showError(withStatus: "Failed to connect")
                    }
                    if error == AppErrors.noResults{
                        self.currentPage -= 1
                    }
                }
            }
        })
    }
    
    
    //MARK:_ scrollview delegate methods
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        //check whether we are at the bottom edge and then fetch again
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        if bottomEdge >= scrollView.contentSize.height{
            if maximumOffset-currentOffset <= 20 && self.scrollOffset!<=currentOffset{
                self.fetchData(true)
            }
        }
        self.scrollOffset = currentOffset
    }
    
    //MARK:- Actions
    
    func sortPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: Constants.chooseSortMethod,message: Constants.alertMsg,preferredStyle:.alert)
        let popularitySortAction = UIAlertAction(title: Constants.sortByPopularity,style:.default,handler:{alertAction in
            self.sortAndDisplayResults(.popularity)
        })
        let ratingSortAction =  UIAlertAction(title: Constants.sortByRating,style:.default,handler:{alertAction in
            self.sortAndDisplayResults(.rating)
        })
        
        let cancelAction =  UIAlertAction(title: Constants.cancel,style:.default,handler:nil)
        
        alert.addAction(popularitySortAction)
        alert.addAction(ratingSortAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func searchPressed(_ sender: UIBarButtonItem) {
        if self.searchController == nil{
            self.showSearchBar()
        }
        else{
            self.removeSearchBar()
        }
    }
    
    //MARK:- UISearchResultsUpdating delegate methods
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        self.movieList=[]
        if searchText! != ""{
            for element in self.searchArr{
                if element.title.contains(searchText!){
                    self.movieList.append(element)
                }
            }
            self.collectionView.reloadData()
        }
        else{
            self.movieList=self.searchArr
            self.collectionView.reloadData()
        }
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        self.removeSearchBar()
    }
    
    
    //MARK:- UIUtility functions

    func showMovieDetails(_ index:Int){
        let movieDetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailsScene") as! MovieDetailsViewController
        movieDetailsViewController.selectedMovie = self.movieList[index]
        self.navigationController?.pushViewController(movieDetailsViewController, animated: true)
    }
    
    func showSearchBar(){
        //assign all values to holder array
        self.searchArr=self.movieList
        self.searchController = UISearchController(searchResultsController:nil)
        self.searchController!.searchResultsUpdater=self
        self.searchController!.delegate=self
        self.searchController!.searchBar.delegate=self
        self.searchController!.hidesNavigationBarDuringPresentation=false
        self.searchController!.dimsBackgroundDuringPresentation=false
        self.navigationItem.rightBarButtonItems=[]
        self.navigationItem.titleView = self.searchController!.searchBar
        self.searchController!.isActive=true
        self.definesPresentationContext=true
    }
    
    func removeSearchBar(){
        if self.searchController != nil{
            self.searchController?.isActive=false
            self.searchController?.searchBar.removeFromSuperview()
            self.searchController=nil
            self.setNavigationHeader()
        }
    }
    
    func setNavigationHeader(){
        self.navigationItem.rightBarButtonItem = UpgradMoviesHelper.barItemWithImage(image: UIImage(named: "search")!, highlightedImage: UIImage(named: "search")!, forFrame: CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: 30, height: 30)), withPadding: 5, isLeftBarButton: false, target: self, action: #selector(MovieListViewController.searchPressed(_:)))
        self.navigationItem.leftBarButtonItem = UpgradMoviesHelper.barItemWithImage(image: UIImage(named: "filter_icon")!, highlightedImage: UIImage(named: "filter_icon")!, forFrame: CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: 30, height: 30)), withPadding: 5, isLeftBarButton: true, target: self, action: #selector(MovieListViewController.sortPressed(_:)))
    }
    
    
//MARK:- Utility functions
    func sortAndDisplayResults(_ sortOption:SortType){
        if sortOption == .popularity{
            self.movieList.sort(by: {$0.popularity > $1.popularity})
        }
        else{
            self.movieList.sort(by: {$0.averageRating > $1.averageRating})
        }
        self.collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UpgradMoviesHelper.Run_InMainThread {
            self.navigationItem.titleView = nil
            SVProgressHUD.dismiss()
        }
    }
}

//MARK:- collectionview data source methods
extension MovieListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieListCell", for: indexPath) as! MovieListCollectionViewCell
        cell.movieLabel.text = self.movieList[(indexPath as NSIndexPath).row].title
        
        if self.movieList[(indexPath as NSIndexPath).row].thumbnailURL != Constants.noURL{
            let imageURLString = Constants.imageURLPrefix + self.movieList[(indexPath as NSIndexPath).row].thumbnailURL
            //print(imageURLString)
            let imageURL = URL(string: imageURLString)
            cell.movieImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named:"movie_icon"))
        }
        
        return cell
    }
}

//MARK:- collectionview delegate methods
extension MovieListViewController: UICollectionViewDelegate{

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.showMovieDetails((indexPath as NSIndexPath).row)
        collectionView.deselectItem(at: indexPath, animated: true)
        self.searchController?.searchBar.resignFirstResponder()
    }

}

extension MovieListViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 3.2
        let hardCodedPadding:CGFloat = 2
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = (itemWidth*1.7)
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

extension MovieListViewController: UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationItem.titleView = nil
        self.title = "Movies"
    }
}
