//
//  Movie.swift
//  MyMovies
//
//  Created by Ratmir Naumov on 10.09.16.
//  Copyright © 2016 Ratmir Naumov. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON


class Movie: NSManagedObject {

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(data: JSON) {
        
        let entity =  NSEntityDescription.entityForName("Movie", inManagedObjectContext: CoreDataManager.sharedInstance.context)!
        super.init(entity: entity, insertIntoManagedObjectContext: CoreDataManager.sharedInstance.context)

        updateData(data)
    }
    
    func updateData(data: JSON) {
        id = data["id"].int
        title =  data["title"].string
        overview = data["overview"].string
        voteAverage = data["vote_average"].double
        posterURL = data["poster_path"].string
        budget = data["budget"].int
        revenue = data["revenue"].int
        release_date = data["release_date"].string
    }
    
}
