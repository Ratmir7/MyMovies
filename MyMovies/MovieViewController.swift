//
//  MovieViewController.swift
//  MyMovies
//
//  Created by Ratmir Naumov on 05.09.16.
//  Copyright © 2016 Ratmir Naumov. All rights reserved.
//

import UIKit
import Kingfisher

class MovieViewController: UIViewController {

    var movie: Movie? {
        didSet {
            if let poster_url = movie?.posterURL {
                if let url = NSURL(string: TheMovieDbManager.sharedInstance.baseImageURL + "w342" + poster_url) {
                    imageView.kf_setImageWithURL(url, placeholderImage: nil, optionsInfo: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) in

                        self.imageView.image = image?.scaleToScreenSize()
                        if let imageData = UIImageJPEGRepresentation(image!, 1) {
                            self.movie?.imageData = imageData
                        }
                        self.imageViewHeightConstraint.active = false
                    })
                }
            } else {
                imageView.image = UIImage(named: "noImage")
            }
            titleLabel.text = movie?.title
            overviewLabel.text = movie?.overview ?? "No data"
            voteLabel.text = String((movie?.voteAverage)!) ?? "No data"
            releaseDateLabel.text = movie?.release_date ?? "No data"
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
    
    let titleLabelHeader: UILabel = {
        let label = UILabel.headerLabel()
        label.text = " Movie name"
        return label
    }()
    
    let titleLabel: UILabel = {
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
    
    let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(12)
        label.numberOfLines = 0
        label.textAlignment = .Left
        return label
    }()
    
    let voteLabelHeader: UILabel = {
        let label = UILabel.headerLabel()
        label.text = " Average vote"
        return label
    }()
    
    let voteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(12)
        label.numberOfLines = 0
        label.textAlignment = .Center
        return label
    }()
    
    let releaseDateLabelHeader: UILabel = {
        let label = UILabel.headerLabel()
        label.text = " Release date"
        return label
    }()
    
    let releaseDateLabel: UILabel = {
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
    
    lazy var favButton: UIBarButtonItem = {
        let but = UIBarButtonItem(image: UIImage(named: "Star"), style: .Plain, target: self, action: #selector(favButtonPressed))
        return but
    }()
    
    lazy var favFullButton: UIBarButtonItem = {
        let but = UIBarButtonItem(image: UIImage(named: "fullStar"), style: .Plain, target: self, action: #selector(favButtonPressed))
        return but
    }()
    
    lazy var navTitleLabel: UILabel = {
        let tl = UILabel(frame: CGRectMake(0, 0, 200, 40))
        tl.text = self.movie?.title
        tl.adjustsFontSizeToFitWidth = true
        tl.minimumScaleFactor = 0.5
        tl.numberOfLines = 0
        tl.textAlignment = .Center
        return tl
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        KingfisherManager.sharedManager.cache.clearMemoryCache()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if let fav = movie?.favorite {
            navigationItem.rightBarButtonItem = fav.boolValue ? favFullButton : favButton
        }
    }
    
    let favButPressedId = "MovieFavButPressed"
    var imageViewHeightConstraint = NSLayoutConstraint()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(favButtonPressedForNotification), name: favButPressedId, object: nil)
        //fix navBar is hidden on load bug
        navigationController?.navigationBarHidden = false
       
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
        
        stackView.addArrangedSubview(titleLabelHeader)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(overviewLabelHeader)
        stackView.addArrangedSubview(overviewLabel)
        stackView.addArrangedSubview(voteLabelHeader)
        stackView.addArrangedSubview(voteLabel)
        stackView.addArrangedSubview(releaseDateLabelHeader)
        stackView.addArrangedSubview(releaseDateLabel)
        stackView.addArrangedSubview(footerLabel)

    }
    
    func favButtonPressedForNotification(notification: NSNotification) {
        //favorite button pressed in another MovieViewController
        if notification.object !== self {
            navigationItem.rightBarButtonItem = (navigationItem.rightBarButtonItem == favButton) ? favFullButton : favButton
        }
    }
    
    func favButtonPressed() {
        if let fav = movie?.favorite {
            movie?.favorite = fav.boolValue ? false : true
            navigationItem.rightBarButtonItem = fav.boolValue ? favButton : favFullButton
        }
        
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: favButPressedId, object: self))
        
        CoreDataManager.sharedInstance.saveContext()
    }
}
