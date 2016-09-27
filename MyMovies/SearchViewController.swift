//
//  SearchMovieViewController.swift
//  MyMovies
//
//  Created by Ratmir Naumov on 03.08.16.
//  Copyright © 2016 Ratmir Naumov. All rights reserved.
//

import UIKit
import Kingfisher

class SearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let cellMovieId = "cellMovieId"
    let cellTvShowId = "cellTvShowId"
    let cellNothingFoundId = "cellNothingFoundId"
    var totalPages = 0
    var currentPage = 1

    var movies = [Movie]() {
        didSet {
           collectionView.reloadData()
        }
    }
    
    var tvShows = [TvShow]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var searchText: String? {
        didSet {
            if segmentedControl.selectedSegmentIndex == 0 {
                TheMovieDbManager.sharedInstance.searchForMovies(searchText!) { [weak self] movies, totalPages, error in
                    self?.checkForNetworkError(error)
                    self?.movies.removeAll()
                    self?.movies = movies
                    self?.totalPages = totalPages
                    self?.currentPage = 1
//                    print("\nMovies(" + movies.count.description + ")\n")
                }
            } else{
                TheMovieDbManager.sharedInstance.searchForTvShows(searchText!) { [weak self] tvShows, totalPages, error in
                    self?.checkForNetworkError(error)
                    self?.tvShows.removeAll()
                    self?.tvShows = tvShows
                    self?.totalPages = totalPages
                    self?.currentPage = 1
//                    print("TvShows(" + tvShows.count.description + ")\n")
                }
            }
            collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        }
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.searchBarStyle = .Default
        sb.placeholder = "Enter the name..."
        sb.delegate = self
        return sb
    }()
    
    lazy var segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Movies", "TvShows"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.backgroundColor = UIColor.whiteColor()
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(segmentedControlChanged), forControlEvents: .ValueChanged)
        return sc
    }()
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = UIColor.whiteColor()
        return cv
    }()
    
    lazy var toolBar: UIToolbar = {
        let tb =  UIToolbar(frame: CGRectMake(0, (self.navigationController?.navigationBar.bounds.height)! + 20,
                            self.view.frame.width, 32))
        tb.delegate = self
        return tb
    }()
    
    let nothingFoundLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.blueColor()
        label.text = "Nothing found"
        label.hidden = false
        return label
    }()
    
    func segmentedControlChanged() {
       
        if let st = searchText {
            if segmentedControl.selectedSegmentIndex == 0 {
                TheMovieDbManager.sharedInstance.searchForMovies(st) { [weak self] movies, totalPages, error in
                    self?.checkForNetworkError(error)
                    self?.movies.removeAll()
                    self?.movies = movies
                    self?.totalPages = totalPages
                    self?.currentPage = 1
                }
            } else {
                TheMovieDbManager.sharedInstance.searchForTvShows(st) { [weak self] tvShows, totalPages, error in
                    self?.checkForNetworkError(error)
                    self?.tvShows.removeAll()
                    self?.tvShows = tvShows
                    self?.totalPages = totalPages
                    self?.currentPage = 1
                }
            }
        }
        collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        KingfisherManager.sharedManager.cache.clearMemoryCache()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.resignFirstResponder()
        searchBar.searchBarStyle = .Minimal
        
        collectionView.keyboardDismissMode = .OnDrag
        collectionView.registerClass(MovieCell.self, forCellWithReuseIdentifier: cellMovieId)
        collectionView.registerClass(TVShowCell.self, forCellWithReuseIdentifier: cellTvShowId)
        collectionView.registerClass(NothingFoundCell.self, forCellWithReuseIdentifier: cellNothingFoundId)
        
        navigationItem.titleView = searchBar
        //remove line under navigation
        self.navigationController?.navigationBar.subviews[0].subviews.filter({$0 is UIImageView})[0].removeFromSuperview()
        
        view.backgroundColor = UIColor.whiteColor()
        
        toolBar.addSubview(self.segmentedControl)
        segmentedControl.centerXAnchor.constraintEqualToAnchor(toolBar.centerXAnchor).active = true
        segmentedControl.centerYAnchor.constraintEqualToAnchor(toolBar.centerYAnchor).active = true
        
        view.addSubview(toolBar)
        view.addSubview(collectionView)
        
        collectionView.topAnchor.constraintEqualToAnchor(toolBar.bottomAnchor).active = true
        collectionView.leftAnchor.constraintEqualToAnchor(self.view.leftAnchor).active = true
        collectionView.rightAnchor.constraintEqualToAnchor(self.view.rightAnchor).active = true
        collectionView.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor).active = true
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 1 {
            return (tvShows.count == 0 && searchText != nil) ? 1 : tvShows.count
        }
        return (movies.count == 0 && searchText != nil) ? 1 : movies.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
       
        if segmentedControl.selectedSegmentIndex == 0 {
            
            if movies.count == 0 && searchText != nil {
                return collectionView.dequeueReusableCellWithReuseIdentifier(cellNothingFoundId, forIndexPath: indexPath) as! NothingFoundCell
            }
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellMovieId, forIndexPath: indexPath) as! MovieCell
            cell.movie = movies[indexPath.row]
            
            if indexPath.row == movies.count - 1 {
                if currentPage < totalPages {
                    currentPage += 1
                    if let searchText = searchText {
                        TheMovieDbManager.sharedInstance.searchForMovies(searchText, page: currentPage) { [weak self] movies, totalMoviesPages, error in
                            self?.checkForNetworkError(error)
                            self?.movies.appendContentsOf(movies)
                            self?.collectionView.reloadData()
                        }
                    }
                }
            }
            
            return cell
        }else {
            
            if tvShows.count == 0 && searchText != nil {
                return collectionView.dequeueReusableCellWithReuseIdentifier(cellNothingFoundId, forIndexPath: indexPath) as! NothingFoundCell
            }
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellTvShowId, forIndexPath: indexPath) as! TVShowCell
            cell.tvShow = tvShows[indexPath.row]
            
            if indexPath.row == tvShows.count - 1 {
                if currentPage < totalPages {
                    currentPage += 1
                    if let searchText = searchText {
                        TheMovieDbManager.sharedInstance.searchForTvShows(searchText, page: currentPage) { [weak self] tvShows, totalPages, error in
                            self?.checkForNetworkError(error)
                            self?.tvShows.appendContentsOf(tvShows)
                            self?.collectionView.reloadData()
                        }
                    }
                }
            }
            
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if segmentedControl.selectedSegmentIndex == 0 {
            if movies.count == 0 { return }
            let vc = MovieViewController()
            vc.movie = movies[indexPath.row]
            navigationController?.navigationBar.topItem?.title = ""
            navigationController?.pushViewController(vc, animated: false)
        } else{
            if tvShows.count == 0 { return }
            let vc = TVShowViewController()
            vc.tvShow = tvShows[indexPath.row]
            navigationController?.navigationBar.topItem?.title = ""
            navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if (segmentedControl.selectedSegmentIndex == 0 && movies.count == 0) ||
            (segmentedControl.selectedSegmentIndex == 1 && tvShows.count == 0) {
            return CGSizeMake(UIScreen.mainScreen().bounds.size.width - 10, 100)
        }
        
        return CGSizeMake(UIScreen.mainScreen().bounds.size.width / 2 - 10, 250)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchText = searchBar.text
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: UIToolbarDelegate {
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}




