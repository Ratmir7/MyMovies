//
//  TvShow.swift
//  MyMovies
//
//  Created by Ratmir Naumov on 14.09.16.
//  Copyright © 2016 Ratmir Naumov. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON


class TvShow: NSManagedObject {

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    init(data: JSON) {
        
        let entity =  NSEntityDescription.entityForName("TvShow", inManagedObjectContext: CoreDataManager.sharedInstance.context)!
        super.init(entity: entity, insertIntoManagedObjectContext: CoreDataManager.sharedInstance.context)
        
        updateData(data)
    }
    
    func updateData(data: JSON) {
        id = data["id"].int
        name = data["name"].string
        overview = data["overview"].string
        popularity = data["popularity"].double
        vote_average = data["vote_average"].double
        poster_path = data["poster_path"].string
    }


}
