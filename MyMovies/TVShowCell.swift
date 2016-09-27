//
//  TVShowCell.swift
//  MyMovies
//
//  Created by Ratmir Naumov on 14.08.16.
//  Copyright © 2016 Ratmir Naumov. All rights reserved.
//

import UIKit

class TVShowCell: Cell {
    
    var tvShow: TvShow? {
        didSet {
            if let posterUrl = tvShow!.poster_path {
                if let url = NSURL(string: TheMovieDbManager.sharedInstance.baseImageURL + "w154" + posterUrl) {
                    imageView.kf_setImageWithURL(url)
                }
            }
        }
    }
}










