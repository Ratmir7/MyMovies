//
//  Cell.swift
//  MyMovies
//
//  Created by Ratmir Naumov on 06.09.16.
//  Copyright © 2016 Ratmir Naumov. All rights reserved.
//

import UIKit

class Cell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.kf_showIndicatorWhenLoading = true
        iv.contentMode = .ScaleAspectFit
        iv.clipsToBounds = true
        iv.image = UIImage(named: "noImage")
        return iv
    }()
    
    func setupViews() {
        addSubview(imageView)
        
        imageView.leftAnchor.constraintEqualToAnchor(self.leftAnchor).active = true
        imageView.rightAnchor.constraintEqualToAnchor(self.rightAnchor).active = true
        imageView.widthAnchor.constraintEqualToAnchor(self.widthAnchor).active = true
        imageView.heightAnchor.constraintEqualToAnchor(self.heightAnchor).active = true
        
    }
    
    override func prepareForReuse() {
        imageView.image = UIImage(named: "noImage")
    }
    
}










