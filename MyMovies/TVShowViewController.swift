//
//  TVShowViewController.swift
//  MyMovies
//
//  Created by Ratmir Naumov on 09.09.16.
//  Copyright © 2016 Ratmir Naumov. All rights reserved.
//

import UIKit
import Kingfisher

class TVShowViewController: UIViewController {
    
    var tvShow: TvShow? {
        didSet {
            if let poster_path = tvShow?.poster_path {
                if let url = NSURL(string: TheMovieDbManager.sharedInstance.baseImageURL + "w342" + poster_path) {
                    
                    imageView.kf_setImageWithURL(url, placeholderImage: nil, optionsInfo: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) in
                        
                        self.imageView.image = image?.scaleToScreenSize()
                        if let imageData = UIImageJPEGRepresentation(image!, 1) {
                            self.tvShow?.imageData = imageData
                        }
                        self.imageViewHeightConstraint.active = false
                    })
                }
            } else {
                imageView.image = UIImage(named: "noImage")
            }
            
            self.nameLabel.text = tvShow?.name
            self.overViewLabel.text = tvShow?.overview

            if let popularity = tvShow?.popularity {
                self.popularityLabel.text = String(format: "%0.2f", popularity.doubleValue)
            }
            
            if let vote = tvShow?.vote_average {
                self.voteAverageLabel.text = String(format: "%.1f", vote.doubleValue)
            }
        }
    }
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .Vertical
        sv.spacing = 5
        sv.distribution = .Fill
        sv.alignment = .Fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.kf_showIndicatorWhenLoading = true
        iv.contentMode = .ScaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    let nameLabelHeader: UILabel = {
        let label = UILabel.headerLabel()
        label.text = " TV Show name"
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(14)
        label.numberOfLines = 0
        label.textAlignment = .Center
        return label
    }()
    
    let overviewLabelHeader: UILabel = {
        let label = UILabel.headerLabel()
        label.text = " Overview"
        return label
    }()
    
    let overViewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(12)
        label.numberOfLines = 0
        label.textAlignment = .Left
        return label
    }()
    
    let voteAverageLabelHeader: UILabel = {
        let label = UILabel.headerLabel()
        label.text = " Vote average"
        return label
    }()
    
    let voteAverageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(12)
        label.numberOfLines = 0
        label.textAlignment = .Center
        return label
    }()
    
    let popularityLabelHeader: UILabel = {
        let label = UILabel.headerLabel()
        label.text = " Popularity"
        return label
    }()
    
    let popularityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(12)
        label.numberOfLines = 0
        label.textAlignment = .Center
        return label
    }()
    
    let footerLabel: UILabel = {
        let label = UILabel.headerLabel()
        label.text = " "
        return label
    }()
    
    lazy var navTitleLabel: UILabel = {
        let tl = UILabel(frame: CGRectMake(0, 0, 200, 40))
        tl.text = self.tvShow!.name
        tl.adjustsFontSizeToFitWidth = true
        tl.minimumScaleFactor = 0.5
        tl.numberOfLines = 0
        tl.textAlignment = .Center
        return tl
    }()
    
    lazy var favButton: UIBarButtonItem = {
        let but = UIBarButtonItem(image: UIImage(named: "Star"), style: .Plain, target: self, action: #selector(favButtonPressed))
        return but
    }()
    
    lazy var favFullButton: UIBarButtonItem = {
        let but = UIBarButtonItem(image: UIImage(named: "fullStar"), style: .Plain, target: self, action: #selector(favButtonPressed))
        return but
    }()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let fav = tvShow?.favorite {
            navigationItem.rightBarButtonItem = fav.boolValue ? favFullButton : favButton
        }
    }
    
    let favButPressedId = "TvShowFavButPressed"
    var imageViewHeightConstraint = NSLayoutConstraint()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        KingfisherManager.sharedManager.cache.clearMemoryCache()
    }
    
    override func viewDidLoad() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(favButtonPressedForNotification), name: favButPressedId, object: nil)
        
        navigationItem.titleView = navTitleLabel
        
        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(scrollView)
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[scrollView]|", options: .AlignAllCenterX, metrics: nil, views: ["scrollView": scrollView]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[scrollView]|", options: .AlignAllCenterX, metrics: nil, views: ["scrollView": scrollView]))
        
        scrollView.addSubview(stackView)
        
        scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[stackView]|", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: ["stackView": stackView]))
        scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[stackView]|", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: ["stackView": stackView]))
        scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[stackView(==scrollView)]", options: .AlignAllCenterX, metrics: nil, views: ["stackView": stackView, "scrollView": scrollView]))
        
        stackView.addArrangedSubview(imageView)
        
        imageViewHeightConstraint = imageView.heightAnchor.constraintEqualToConstant(30)
        if imageView.image == nil { imageViewHeightConstraint.active = true }
        
        stackView.addArrangedSubview(nameLabelHeader)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(overviewLabelHeader)
        stackView.addArrangedSubview(overViewLabel)
        stackView.addArrangedSubview(voteAverageLabelHeader)
        stackView.addArrangedSubview(voteAverageLabel)
        stackView.addArrangedSubview(popularityLabelHeader)
        stackView.addArrangedSubview(popularityLabel)
        stackView.addArrangedSubview(footerLabel)
    }
    
    func favButtonPressedForNotification(notification: NSNotification) {
        //favorite button pressed in another MovieViewController
        if notification.object !== self {
            navigationItem.rightBarButtonItem = (navigationItem.rightBarButtonItem == favButton) ? favFullButton : favButton
        }
    }
    
    func favButtonPressed() {
        if let fav = tvShow?.favorite {
            tvShow?.favorite = fav.boolValue ? false : true
            navigationItem.rightBarButtonItem = fav.boolValue ? favButton : favFullButton
        }
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: favButPressedId, object: self))
        
        CoreDataManager.sharedInstance.saveContext()
    }
    
}
