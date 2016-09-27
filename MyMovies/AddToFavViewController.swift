//
//  AddToFavViewController.swift
//  MyMovies
//
//  Created by Ratmir Naumov on 09.09.16.
//  Copyright © 2016 Ratmir Naumov. All rights reserved.
//

import UIKit
import CoreData

class AddToFavViewController: UITableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    lazy var switchAddToSeen: UISwitch = {
        let sw = UISwitch()
        
        sw.addTarget(self, action: #selector(switchAddToSeenChanged), forControlEvents: .ValueChanged)
        return sw
    }()
    
    func switchAddToSeenChanged() {
        print("Add to seen switched")
        
        CoreDataManager.sharedInstance.saveContext()
        printDatabaseStatistics()
    }
    
    lazy var switchAddToWatch: UISwitch = {
        let sw = UISwitch()
        sw.addTarget(self, action: #selector(switchAddToWatchChanged), forControlEvents: .ValueChanged)
        return sw
    }()
    
    func switchAddToWatchChanged() {
        print("Add to watch switched")
    }
    
    private func printDatabaseStatistics() {
        let movies = CoreDataManager.sharedInstance.context.countForFetchRequest(NSFetchRequest(entityName: "Movie"), error: nil)
        print("\(movies) Movies\n")
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        switch indexPath.row {
        case 0: cell.textLabel?.text = "Add to: Seen"
                cell.accessoryView = switchAddToSeen
                break
        case 1: cell.textLabel?.text = "Add to: To watch"
                cell.accessoryView = switchAddToWatch
                break
        default: break
        }
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add to lists"
        tableView.contentInset = UIEdgeInsetsMake(24, 0, 0, 0)
        tableView.scrollEnabled = false
        tableView.separatorStyle = .None
        tableView.allowsSelection = false
    }
}

