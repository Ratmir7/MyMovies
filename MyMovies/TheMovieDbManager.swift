//
//  TheMovieDbManager.swift
//  MovieBase
//
//  Created by Ratmir Naumov on 21.05.16.
//  Copyright © 2016 Ratmir Naumov. All rights reserved.
//

import CoreData
import Alamofire
import SwiftyJSON

class TheMovieDbManager {
    
    static let sharedInstance = TheMovieDbManager()
    
    private let apiKey = "193527c5a64a71a5a75dbd352a3bdd89"
    private let apiURL = "http://api.themoviedb.org/3"
    private let genresURL = "/genre/movie/list"
    let baseImageURL = "http://image.tmdb.org/t/p/"
    
    func searchForMovies(query: String, page: Int = 1, callback: ([Movie], Int, NSError?) -> Void) {
        let params: [String : String] = ["api_key" : apiKey, "query" : query, "page" : String(page)]
        var totalPages = 0
        
        Alamofire.request(.GET, apiURL + "/search/movie", parameters: params)
            .validate()
            .responseJSON { response in
                
                guard response.result.isSuccess else {
                    print("Network error: \(response.result.error)")
                    callback([], 0, response.result.error)
                    return
                }
                
                var movies: [Movie] = []
                
                if let data = response.result.value {
                    let json = JSON(data)
                    
                    for movie in json["results"].arrayValue {
                        if let movie = self.createMovie(movie) {
                            movies.append(movie)
                        }
                    }
                    totalPages = json["total_pages"].intValue
                } else{
                    print("Data recieved error: \(response.result.value)")
                    callback([], 0, nil)
                    return
                }
                
                callback(movies, totalPages, nil)
        }
    }
    
    func searchForTvShows(query: String, page: Int = 1, callback: ([TvShow], Int, NSError?) -> Void) {
        let params: [String : String] = ["api_key" : apiKey, "query" : query, "page" : String(page)]
        var totalPages = 0
        
        Alamofire.request(.GET, apiURL + "/search/tv", parameters: params)
            .validate()
            .responseJSON { response in
                
                guard response.result.isSuccess else {
                    print("Network error: \(response.result.error)")
                    callback([], 0, response.result.error)
                    return
                }
                
                var tvShows: [TvShow] = []

                if let data = response.result.value {
                    let json = JSON(data)
                    for tvShow in json["results"].arrayValue {
                        if let tvShow = self.createTvShow(tvShow) {
                            tvShows.append(tvShow)
                        }
                    }
                    totalPages = json["total_pages"].intValue
                } else{
                    print("Data recieved error: \(response.result.value)")
                    callback([], 0, nil)
                    return
                }
                
                callback(tvShows, totalPages, nil)
        }
    }
    
    func fetchPopularPersons(page: Int = 1, callback: ([Person], Int, NSError?) -> Void) {
        let params: [String : String] = ["api_key" : apiKey, "page" : String(page)]
        var totalPersonsPages = 0
        
        Alamofire.request(.GET, apiURL + "/person/popular", parameters: params)
            .validate()
            .responseJSON { response in
                
                guard response.result.isSuccess else {
                    print("Network error: \(response.result.error)")
                    callback([], 0, response.result.error)
                    return
                }
                
                var persons: [Person] = []
                
                if let data = response.result.value {
                    let json = JSON(data)
                    
                    for person in json["results"].arrayValue {
                        persons.append(Person(data: person))
                    }
                    totalPersonsPages = json["total_pages"].intValue
                } else{
                    print("Data recieved error: \(response.result.value)")
                    callback([], 0, nil)
                    return
                }
                
                callback(persons, totalPersonsPages, nil)
        }
    }
    
    func fetchPopularTVShows(page: Int = 1, callback: ([TvShow], Int, NSError?) -> Void) {
        let params: [String : String] = ["api_key" : apiKey, "page" : String(page)]
        var totalTVShowsPages = 0
        
        Alamofire.request(.GET, apiURL + "/tv/popular", parameters: params)
            .validate()
            .responseJSON { response in
                
                guard response.result.isSuccess else {
                    print("Network error: \(response.result.error)")
                    callback([], 0, response.result.error)
                    return
                }
                
                var tvshows: [TvShow] = []
                
                if let data = response.result.value {
                    let json = JSON(data)
                    
                    for tvshow in json["results"].arrayValue {
                        if let tv = self.createTvShow(tvshow) {
                            tvshows.append(tv)
                        }
                    }
                    totalTVShowsPages = json["total_pages"].intValue
                } else{
                    print("Data recieved error: \(response.result.value)")
                    callback([], 0, nil)
                    return
                }
                
                callback(tvshows, totalTVShowsPages, nil)
        }
    }
    
    func fetchAiringTodayTVShows(page: Int = 1, callback: ([TvShow], Int, NSError?) -> Void) {
        let params: [String : String] = ["api_key" : apiKey, "page" : String(page)]
        var totalTVShowsPages = 0
        
        Alamofire.request(.GET, apiURL + "/tv/airing_today", parameters: params)
            .validate()
            .responseJSON { response in
                
                guard response.result.isSuccess else {
                    print("Network error: \(response.result.error)")
                    callback([], 0, response.result.error)
                    return
                }
                
                var tvshows: [TvShow] = []
                
                if let data = response.result.value {
                    let json = JSON(data)
                    
                    for tvshow in json["results"].arrayValue {
                        if let tv = self.createTvShow(tvshow) {
                            tvshows.append(tv)
                        }
                    }
                    totalTVShowsPages = json["total_pages"].intValue
                } else{
                    print("Data recieved error: \(response.result.value)")
                    callback([], 0, nil)
                    return
                }
                
                callback(tvshows, totalTVShowsPages, nil)
        }
    }
    
    func fetchPopularMovies(page: Int = 1, callback: ([Movie], Int, NSError?) -> Void) {
        let params: [String : String] = ["api_key" : apiKey, "page" : String(page)]
        var totalMoviePages = 0
        
        Alamofire.request(.GET, apiURL + "/movie/popular", parameters: params)
            .responseJSON { response in
                
                guard response.result.isSuccess else {
                    print("Network error: \(response.result.error)")
                    callback([], 0, response.result.error)
                    return
                }
                
                var movies: [Movie] = []
                
                if let data = response.result.value {
                    let json = JSON(data)
                    
                    for movie in json["results"].arrayValue {
                        if let movie = self.createMovie(movie) {
                            movies.append(movie)
                        }
                    }
                    totalMoviePages = json["total_pages"].intValue
                } else{
                    print("Data recieved error: \(response.result.value)")
                    callback([], 0, nil)
                    return
                }
                
                callback(movies, totalMoviePages, nil)
        }
    }
    
    func fetchNowPlayingMovies(page: Int = 1, callback: ([Movie], Int, NSError?) -> Void) {
        let params: [String : String] = ["api_key" : apiKey, "page" : String(page)]
        var totalMoviePages = 0
        
        Alamofire.request(.GET, apiURL + "/movie/now_playing", parameters: params)
            .validate()
            .responseJSON { response in
                
                guard response.result.isSuccess else {
                    print("Network error: \(response.result.error)")
                    callback([], 0, response.result.error)
                    return
                }
                
                var movies: [Movie] = []
                
                if let data = response.result.value {
                    let json = JSON(data)
                    
                    for movie in json["results"].arrayValue {
                        if let movie = self.createMovie(movie) {
                            movies.append(movie)
                        }
                    }
                    totalMoviePages = json["total_pages"].intValue
                } else{
                    print("Data recieved error: \(response.result.value)")
                    callback([], 0, nil)
                    return
                }
                
                callback(movies, totalMoviePages, nil)
        }
    }
    
    func fetchPerson(id: Int, callback: (Person?, NSError?) -> Void) {
        let params = ["api_key" : apiKey]
        
        Alamofire.request(.GET, apiURL + "/person/" + String(id), parameters: params)
            .validate()
            .responseJSON { response in
                
                guard response.result.isSuccess else {
                    print("Network error: \(response.result.error)")
                    callback(nil, response.result.error)
                    return
                }
                
                if let data = response.result.value {
                    let json = JSON(data)
                    let person = Person(data: json)
                    callback(person, nil)
                } else{
                    print("Data recieved error: \(response.result.value)")
                    callback(nil, nil)
                    return
                }
        }
    }

    func searchForPersons(query: String, page: Int = 1, callback: ([Person], Int, NSError?) -> Void) {
        let params: [String : String] = ["api_key" : apiKey, "query" : query, "page" : String(page)]
        var totalPersonPages = 0
        
        Alamofire.request(.GET, apiURL + "/search/person", parameters: params)
            .validate()
            .responseJSON { response in
                
                guard response.result.isSuccess else {
                    print("Network error: \(response.result.error)")
                    callback([], 0, response.result.error)
                    return
                }
                
                var persons: [Person] = []
                
                if let data = response.result.value {
                    let json = JSON(data)
                    
                    for person in json["results"].arrayValue {
                        persons.append(Person(data: person))
                    }
                    totalPersonPages = json["total_pages"].intValue
                } else{
                    print("Data recieved error: \(response.result.value)")
                    callback([], 0, nil)
                    return
                }
                
                callback(persons, totalPersonPages, nil)
        }
    }
    
    func createMovie(data: JSON) -> Movie? {
        
        let fetchRequest = NSFetchRequest(entityName: "Movie")
        
        fetchRequest.predicate = NSPredicate(format: "id = %d", data["id"].intValue)
        do {
            let results = try CoreDataManager.sharedInstance.context.executeFetchRequest(fetchRequest).first
            if let res = results {
                return res as? Movie
            }
        } catch let error as NSError {
            print("Error in fetch \(error), \(error.userInfo)")
        }
        
        return Movie(data: data)
    }
    
    func createTvShow(data: JSON) -> TvShow? {
        
        let fetchRequest = NSFetchRequest(entityName: "TvShow")
        
        fetchRequest.predicate = NSPredicate(format: "id = %d", data["id"].intValue)
        do {
            let results = try CoreDataManager.sharedInstance.context.executeFetchRequest(fetchRequest).first
            if let res = results {
                return res as? TvShow
            }
        } catch let error as NSError {
            print("Error in fetch \(error), \(error.userInfo)")
        }
        
        return TvShow(data: data)
    }
    
}










