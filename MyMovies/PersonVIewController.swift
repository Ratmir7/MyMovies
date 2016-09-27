//
//  PersonVIewController.swift
//  MyMovies
//
//  Created by Ratmir Naumov on 09.09.16.
//  Copyright © 2016 Ratmir Naumov. All rights reserved.
//

import UIKit

class PersonViewController: UIViewController {
    var person: Person? {
        didSet {
           
            if let personPath = person?.profile_path {
                if let url = NSURL(string: TheMovieDbManager.sharedInstance.baseImageURL + "h632" + personPath) {
                    imageView.kf_setImageWithURL(url, placeholderImage: nil, optionsInfo: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) in
                        self.imageView.image = self.imageView.image?.scaleToScreenSize()
                        self.imageViewHeightConstraint.active = false
                    })
                }
            }
            
            self.biographyLabel.text = person?.biography
            self.title = person?.name
            
            birthdayLabel.text = person?.birthday ?? "No information"
            placeOfBirthLabel.text = person?.place_of_birth ?? "No information"
            
            if let homepage = person?.homepage {
                if homepage.isEmpty {
                    homePageLabel.text = "No information"
                } else{
                    let urlString = NSMutableAttributedString(string: homepage)
                    homePageLabel.attributedText = urlString
                }
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
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.kf_showIndicatorWhenLoading = true
        iv.clipsToBounds = true
        return iv
    }()
    
    let biographyLabelHeader: UILabel = {
        let label = UILabel.headerLabel()
        label.text = " Biography"
        return label
    }()
    
    let biographyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(12)
        label.numberOfLines = 0
        label.textAlignment = .Left
        return label
    }()
    
    let birthdayLabelHeader: UILabel = {
        let label = UILabel.headerLabel()
        label.text = " Birthday"
        return label
    }()
    
    let birthdayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(12)
        label.numberOfLines = 0
        label.textAlignment = .Center
        return label
    }()
    
    let homepageLabelHeader: UILabel = {
        let label = UILabel.headerLabel()
        label.text = " Homepage"
        return label
    }()
    
    let homePageLabel: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFontOfSize(12)
        tv.textAlignment = .Center
        tv.editable = false
        tv.selectable = true
        tv.dataDetectorTypes = .Link
        tv.text = " "
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let placeOfBirthLabelHeader: UILabel = {
        let label = UILabel.headerLabel()
        label.text = " Place of birth"
        return label
    }()
    
    let placeOfBirthLabel: UILabel = {
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
    
    var imageViewHeightConstraint = NSLayoutConstraint()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        TheMovieDbManager.sharedInstance.fetchPerson((person?.id)!) { [weak self] person, error in
            self?.checkForNetworkError(error)
            self?.person = person
        }
    }
    
    override func viewDidLoad() {
        
        navigationController?.navigationBarHidden = false

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
        
        stackView.addArrangedSubview(biographyLabelHeader)
        stackView.addArrangedSubview(biographyLabel)
        stackView.addArrangedSubview(birthdayLabelHeader)
        stackView.addArrangedSubview(birthdayLabel)
        stackView.addArrangedSubview(homepageLabelHeader)
        stackView.addArrangedSubview(homePageLabel)
        homePageLabel.heightAnchor.constraintEqualToConstant(homePageLabel.contentSize.height).active = true
        stackView.addArrangedSubview(placeOfBirthLabelHeader)
        stackView.addArrangedSubview(placeOfBirthLabel)
        stackView.addArrangedSubview(footerLabel)
        
    }
    
}
