//
//  PopularCell.swift
//  MyMovies
//
//  Created by Ratmir Naumov on 14.08.16.
//  Copyright © 2016 Ratmir Naumov. All rights reserved.
//

import UIKit

enum CellType {
    case TVShowPopular
    case TVShowAiringToday
    case MoviePopular
    case MovieNowPLaying
}

protocol PopularCellDelegate {
    func movieCellClicked(movie: Movie)
    func tvShowCellClicked(tvShow: TvShow)
    func cellCheckForNetworkError(error: NSError?)
}

class PopularCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let cellID = "cellID"
    
    var delegate: PopularCellDelegate?
    
    var type: CellType? {
        didSet{
            fetchData()
        }
    }
    
    var tvShows = [TvShow]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var movies = [Movie]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func fetchData() {
        if let type = type {
            switch type {
            case .TVShowPopular: TheMovieDbManager.sharedInstance.fetchPopularTVShows { [weak self] shows, _, error in
                self?.delegate?.cellCheckForNetworkError(error)
                self?.tvShows = shows
                }
                
            case .TVShowAiringToday: TheMovieDbManager.sharedInstance.fetchAiringTodayTVShows { [weak self] shows, _, error in
                self?.delegate?.cellCheckForNetworkError(error)
                self?.tvShows = shows
                }
            case .MoviePopular: TheMovieDbManager.sharedInstance.fetchPopularMovies { [weak self] movies, _, error in
                self?.delegate?.cellCheckForNetworkError(error)
                self?.movies = movies
                }
            case .MovieNowPLaying: TheMovieDbManager.sharedInstance.fetchNowPlayingMovies { [weak self] movies, _, error in
                self?.delegate?.cellCheckForNetworkError(error)
                self?.movies = movies
                }
            }
        }
    }
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.whiteColor()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews() {
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        addSubview(nameLabel)
        nameLabel.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 10).active = true
        nameLabel.rightAnchor.constraintEqualToAnchor(self.rightAnchor).active = true
        nameLabel.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        nameLabel.heightAnchor.constraintEqualToConstant(20).active = true

        addSubview(collectionView)
        collectionView.leftAnchor.constraintEqualToAnchor(self.leftAnchor).active = true
        collectionView.rightAnchor.constraintEqualToAnchor(self.rightAnchor).active = true
        collectionView.topAnchor.constraintEqualToAnchor(nameLabel.bottomAnchor).active = true
        collectionView.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor).active = true
        
        collectionView.registerClass(TVShowCell.self, forCellWithReuseIdentifier: cellID)

    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if type == CellType.MoviePopular || type == CellType.MovieNowPLaying {
            return movies.count
        }
        return tvShows.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! Cell
        var poster_path = ""
        
        if let type = type {
            switch type {
            case CellType.MoviePopular, CellType.MovieNowPLaying: poster_path = movies[indexPath.row].posterURL ?? ""
            case CellType.TVShowAiringToday, CellType.TVShowPopular: poster_path = tvShows[indexPath.row].poster_path ?? ""
            }
        }
        
        if !poster_path.isEmpty {
            if let url = NSURL(string: TheMovieDbManager.sharedInstance.baseImageURL + "w154" + poster_path) {
                cell.imageView.kf_setImageWithURL(url)
            }
        } else {
            cell.imageView.image = UIImage(named: "noImage")
        }

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(150, frame.height - 25)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let type = type {
            switch type {
            case CellType.MoviePopular, CellType.MovieNowPLaying:
                delegate?.movieCellClicked(movies[indexPath.row])
            case CellType.TVShowAiringToday, CellType.TVShowPopular:
                delegate?.tvShowCellClicked(tvShows[indexPath.row])
            }
        }
    }
    
}

