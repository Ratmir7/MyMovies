//
//  FavoritesViewController.swift
//  MyMovies
//
//  Created by Ratmir Naumov on 11.09.16.
//  Copyright © 2016 Ratmir Naumov. All rights reserved.
//

import UIKit
import CoreData

class FavoritesViewController: UITableViewController {
    
    var fetchedResultsController : NSFetchedResultsController!
    let cellID = "cellID"
    
    lazy var segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Movies", "TvShows"])
        sc.selectedSegmentIndex = 0;
        sc.addTarget(self, action: #selector(segmentedControlChanged), forControlEvents: .ValueChanged)
        return sc
    }()
    
    let fetchedMovieController: NSFetchedResultsController = {
        let fr = NSFetchRequest(entityName: "Movie")
        fr.predicate = NSPredicate(format: "favorite = true")
        let voteSort = NSSortDescriptor(key: "voteAverage", ascending: true)
        fr.sortDescriptors = [voteSort]
        
        let fmc = NSFetchedResultsController(fetchRequest: fr,
                                             managedObjectContext: CoreDataManager.sharedInstance.context,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)

        return fmc
    }()
    
    let fetchedTvShowController: NSFetchedResultsController = {
        let fr = NSFetchRequest(entityName: "TvShow")
        fr.predicate = NSPredicate(format: "favorite = true")
        let voteSort = NSSortDescriptor(key: "popularity", ascending: false)
        fr.sortDescriptors = [voteSort]
        
        let fmc = NSFetchedResultsController(fetchRequest: fr,
                                             managedObjectContext: CoreDataManager.sharedInstance.context,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)

        return fmc
    }()

    lazy var fetchedControllers: [NSFetchedResultsController] = {
        return [self.fetchedMovieController, self.fetchedTvShowController]
    }()
    
    
    func segmentedControlChanged() {
        fetchedResultsController.delegate = nil
        fetchedResultsController = fetchedControllers[segmentedControl.selectedSegmentIndex]
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellID)

        self.navigationItem.titleView = segmentedControl
        
        fetchedResultsController = fetchedControllers[0]
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if segmentedControl.selectedSegmentIndex == 0 {
            let movie = fetchedResultsController.objectAtIndexPath(indexPath) as? Movie
            let mvc = MovieViewController()
            mvc.movie = movie
            navigationController?.navigationBar.topItem?.title = ""
            navigationController?.pushViewController(mvc, animated: true)
        } else{
            let tvShow = fetchedResultsController.objectAtIndexPath(indexPath) as? TvShow
            let tvc = TVShowViewController()
            tvc.tvShow = tvShow
            navigationController?.navigationBar.topItem?.title = ""
            navigationController?.pushViewController(tvc, animated: true)
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(cellID)
        if cell != nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellID)
        }
        configureCell(cell!, indexPath: indexPath)
        return cell!
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            if segmentedControl.selectedSegmentIndex == 0 {
                let movie = fetchedResultsController.objectAtIndexPath(indexPath) as? Movie
                movie?.favorite = false
            }else {
                let tvShow = fetchedResultsController.objectAtIndexPath(indexPath) as? TvShow
                tvShow?.favorite = false
            }
            
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        if segmentedControl.selectedSegmentIndex == 0 {
            configureMovieCell(cell, indexPath: indexPath)
        }else {
            configureTvShowCell(cell, indexPath: indexPath)
        }
    }
    
    func configureMovieCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        var movie: Movie?
        movie = fetchedResultsController.objectAtIndexPath(indexPath) as? Movie
        if let movie = movie {
            cell.textLabel?.text = movie.title
            if let imageData = movie.imageData {
                cell.imageView?.image = UIImage(data: imageData)
                cell.imageView?.contentMode = .ScaleAspectFill
            }
        }
    }
    
    func configureTvShowCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        var tvShow: TvShow?
        tvShow = fetchedResultsController.objectAtIndexPath(indexPath) as? TvShow
        if let tvShow = tvShow {
            cell.textLabel?.text = tvShow.name
            if let imageData = tvShow.imageData {
                cell.imageView?.image = UIImage(data: imageData)
                cell.imageView?.contentMode = .ScaleAspectFit
            }
        }
    }
 
}

extension FavoritesViewController: NSFetchedResultsControllerDelegate {
   
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject,
                    atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType,
                                newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert: tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        case .Delete: tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        case .Update: if let cell = tableView.cellForRowAtIndexPath(indexPath!) {
                            configureCell(cell, indexPath: indexPath!)
                    }
        case .Move: tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
                    tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
}
