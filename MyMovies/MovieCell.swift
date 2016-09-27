//
//  MovieCell.swift
//  MyMovies
//
//  Created by Ratmir Naumov on 03.08.16.
//  Copyright © 2016 Ratmir Naumov. All rights reserved.
//

import UIKit

class MovieCell: Cell {
    
    var movie: Movie? {
        didSet {
            if let posterUrl = movie!.posterURL {
                if let url = NSURL(string: TheMovieDbManager.sharedInstance.baseImageURL + "w154" + posterUrl) {
                    imageView.kf_setImageWithURL(url)
                }
            }
        }
    }
    
}









