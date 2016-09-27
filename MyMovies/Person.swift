//
//  Person.swift
//  MyMovies
//
//  Created by Ratmir Naumov on 13.08.16.
//  Copyright © 2016 Ratmir Naumov. All rights reserved.
//

import SwiftyJSON

class Person {
    let id: Int
    let name: String
    let popularity: Double
    let profile_path: String?
    
    let biography: String?
    let birthday: String?
    let homepage: String?
    let place_of_birth: String?
    let imdb_id: String?
    
    init(data: JSON) {
        id = data["id"].intValue
        name = data["name"].stringValue
        popularity = data["popularity"].doubleValue
        profile_path = data["profile_path"].string
        
        biography = data["biography"].string
        birthday = data["birthday"].string
        homepage = data["homepage"].string
        place_of_birth = data["place_of_birth"].string
        imdb_id = data["imdb_id"].string
    }
}