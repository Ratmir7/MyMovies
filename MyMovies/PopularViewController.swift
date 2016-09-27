//
//  PopularViewController.swift
//  MyMovies
//
//  Created by Ratmir Naumov on 14.08.16.
//  Copyright © 2016 Ratmir Naumov. All rights reserved.
//

import UIKit
import Kingfisher

class PopularViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.registerClass(PopularCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.backgroundColor = UIColor.whiteColor()
        collectionView?.showsVerticalScrollIndicator = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        KingfisherManager.sharedManager.cache.clearMemoryCache()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        title = "Popular and on air"
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 4
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! PopularCell
        
        switch indexPath.section {
        case 0: cell.type = CellType.TVShowPopular
                cell.nameLabel.text = "Popular TVShows"
        case 1: cell.type = CellType.TVShowAiringToday
                cell.nameLabel.text = "TVShows Airing Today"
        case 2: cell.type = CellType.MoviePopular
                cell.nameLabel.text = "Popular movies"
        case 3: cell.type = CellType.MovieNowPLaying
                cell.nameLabel.text = "Now playing movies"
        default: break
        }
        
        cell.delegate = self
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.frame.size.width - 10, (collectionView.frame.size.height - 10 ) / 2.5)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
      
}

extension PopularViewController: PopularCellDelegate {
    func movieCellClicked(movie: Movie) {
        let vc = MovieViewController()
        vc.movie = movie
        navigationController?.navigationBar.topItem?.title = ""
        navigationController!.pushViewController(vc, animated: true)
    }
    
    func tvShowCellClicked(tvShow: TvShow) {
        let vc = TVShowViewController()
        vc.tvShow = tvShow
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func cellCheckForNetworkError(error: NSError?) {
        self.checkForNetworkError(error)
    }
}