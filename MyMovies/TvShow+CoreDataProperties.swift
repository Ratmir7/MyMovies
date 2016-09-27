//
//  TvShow+CoreDataProperties.swift
//  MyMovies
//
//  Created by Ratmir Naumov on 15.09.16.
//  Copyright © 2016 Ratmir Naumov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TvShow {

    @NSManaged var id: NSNumber?
    @NSManaged var name: String?
    @NSManaged var popularity: NSNumber?
    @NSManaged var vote_average: NSNumber?
    @NSManaged var overview: String?
    @NSManaged var poster_path: String?
    @NSManaged var imageData: NSData?
    @NSManaged var favorite: NSNumber?

}
