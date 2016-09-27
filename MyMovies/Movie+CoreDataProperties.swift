//
//  Movie+CoreDataProperties.swift
//  MyMovies
//
//  Created by Ratmir Naumov on 19.09.16.
//  Copyright © 2016 Ratmir Naumov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Movie {

    @NSManaged var favorite: NSNumber?
    @NSManaged var id: NSNumber?
    @NSManaged var imageData: NSData?
    @NSManaged var overview: String?
    @NSManaged var posterURL: String?
    @NSManaged var title: String?
    @NSManaged var voteAverage: NSNumber?
    @NSManaged var budget: NSNumber?
    @NSManaged var revenue: NSNumber?
    @NSManaged var release_date: String?

}
