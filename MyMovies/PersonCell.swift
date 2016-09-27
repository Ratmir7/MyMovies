//
//  PersonCell.swift
//  MyMovies
//
//  Created by Ratmir Naumov on 13.08.16.
//  Copyright © 2016 Ratmir Naumov. All rights reserved.
//

import UIKit

class PersonCell: Cell {
   
    var person: Person? {
        didSet{
            if let image_path = person?.profile_path {
                if let url = NSURL(string: TheMovieDbManager.sharedInstance.baseImageURL + "w185" + image_path) {
                    imageView.kf_setImageWithURL(url)
                }
            }
        }
    }
}
