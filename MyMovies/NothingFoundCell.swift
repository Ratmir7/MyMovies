//
//  NothingFoundCell.swift
//  MyMovies
//
//  Created by Ratmir Naumov on 27.09.16.
//  Copyright © 2016 Ratmir Naumov. All rights reserved.
//

import UIKit

class NothingFoundCell: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Nothing found..."
        label.font = UIFont.systemFontOfSize(16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.backgroundColor = UIColor.yellowColor()

        titleLabel.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
        titleLabel.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true

    }
}
