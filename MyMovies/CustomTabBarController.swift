//
//  CustomTabBarController.swift
//  MyMovies
//
//  Created by Ratmir Naumov on 03.08.16.
//  Copyright © 2016 Ratmir Naumov. All rights reserved.
//

import UIKit
import Kingfisher

class CustomTabBarController: UITabBarController {

    let popularNavController: UINavigationController = {
        let layout = UICollectionViewFlowLayout()
        let vc = PopularViewController(collectionViewLayout: layout)
        vc.title = "Popular and on air"
        vc.tabBarItem = UITabBarItem(tabBarSystemItem: .MostViewed, tag: 0)
        let snc = UINavigationController(rootViewController: vc)
        snc.hidesBarsOnSwipe = true
        return snc
    }()
    
    let searchNavController: UINavigationController = {
        let vc = SearchViewController()
        let snc = UINavigationController(rootViewController: vc)
        snc.tabBarItem = UITabBarItem(title: "Search", image: UIImage(named: "Search"), tag: 0)
        return snc
    }()
    
    let personsNavController: UINavigationController = {
        let vc = SearchPersonsViewController()
        vc.title = "Actors"
        let snc = UINavigationController(rootViewController: vc)
        snc.hidesBarsOnSwipe = true
        snc.tabBarItem = UITabBarItem(title: "Actors", image: UIImage(named: "Actors"), tag: 0)
        return snc
    }()
    
    let favNavController: UINavigationController = {
        let vc = FavoritesViewController()
        vc.title = "Favorites"
        vc.tabBarItem = UITabBarItem(tabBarSystemItem: .Favorites, tag: 0)
        let snc = UINavigationController(rootViewController: vc)
        return snc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = [popularNavController, searchNavController, personsNavController, favNavController]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        KingfisherManager.sharedManager.cache.clearMemoryCache()
    }

}
