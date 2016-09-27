//
//  SearchPersonsViewController.swift
//  MyMovies
//
//  Created by Ratmir Naumov on 13.08.16.
//  Copyright © 2016 Ratmir Naumov. All rights reserved.
//

import UIKit
import Kingfisher

class SearchPersonsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let cellID = "cellID"
    
    var persons = [Person]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var searchText: String? {
        didSet {
            TheMovieDbManager.sharedInstance.searchForPersons(searchText!) { [weak self] persons, totalPersonsPages, error in
                self?.checkForNetworkError(error)
                self?.persons.removeAll()
                self?.persons = persons
                self?.totalPersonsPages = totalPersonsPages
                self?.currentPersonPage = 1
            }
        }
    }
    
    var totalPersonsPages = 0
    var currentPersonPage = 1
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = UIColor.whiteColor()
        return cv
    }()
    
    lazy var searchBar: UISearchBar = {
        let frame = CGRectMake(0, UIApplication.sharedApplication().statusBarFrame.size.height + 44,
                               UIScreen.mainScreen().bounds.size.width, 44)
        let sb = UISearchBar(frame: frame)
        sb.searchBarStyle = .Default
        sb.placeholder = "Find person"
        sb.delegate = self
        return sb
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        TheMovieDbManager.sharedInstance.fetchPopularPersons { [weak self] persons, totalPersonsPages, error in
            self?.checkForNetworkError(error)
            self?.persons = persons
            self?.totalPersonsPages = totalPersonsPages
        }
        
        searchBar.searchBarStyle = .Minimal
        navigationItem.titleView = searchBar

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        collectionView.keyboardDismissMode = .OnDrag
        collectionView.registerClass(PersonCell.self, forCellWithReuseIdentifier: cellID)
        view.addSubview(collectionView)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        title = "Actors"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        KingfisherManager.sharedManager.cache.clearMemoryCache()
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return persons.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! PersonCell
        
        cell.person = persons[indexPath.row]
        
        if indexPath.row == persons.count - 1 {
            if currentPersonPage < totalPersonsPages {
                currentPersonPage += 1
                
                if let searchText = searchText {
                    TheMovieDbManager.sharedInstance.searchForPersons(searchText, page: currentPersonPage) { [weak self]persons, _, error in
                        self?.checkForNetworkError(error)
                        self?.persons.appendContentsOf(persons)
                        self?.collectionView.reloadData()
                    }
                }else {
                    TheMovieDbManager.sharedInstance.fetchPopularPersons(currentPersonPage) { [weak self] persons, _, error in
                        self?.checkForNetworkError(error)
                        self?.persons.appendContentsOf(persons)
                        self?.collectionView.reloadData()
                    }
                }
            }
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((UIScreen.mainScreen().bounds.size.width - 20) / 2, 200)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        searchBar.resignFirstResponder()
        let vc = PersonViewController()
        vc.person = persons[indexPath.row]
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchPersonsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchText = searchBar.text
        print(searchText!)
        searchBar.resignFirstResponder()
    }
}















