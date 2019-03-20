//
//  RecordsListViewController.swift
//  AbilityTest
//
//  Created by Chase Choi on 2019/3/20.
//  Copyright © 2019 Chase Choi. All rights reserved.
//

import UIKit
import CoreData

protocol RecordSelectionDelegate: class {
    func recordSelected(_ candidateSelected: Candidate)
}

class RecordsListViewController: UITableViewController {
    
    // MARK: - Properties
    
    var managedObjectContext: NSManagedObjectContext?
    
    // MARK: Delegate
    
    weak var delegate: RecordSelectionDelegate?
    
    // MARK: Feteched Results Controller
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Candidate> = {
        guard let managedObjectContext = self.managedObjectContext else {
            fatalError("No Managed Object Context Found")
        }
        
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Candidate> = Candidate.fetchRequest()
       
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Candidate.name), ascending: false)]
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        
        title = "测试"
        
        fetchRecords()
    }
    
    // MARK: - Helper Methods
    
    func fetchRecords() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Unable to Perform Fetch Request")
            print("\(error), \(error.localizedDescription)")
        }
    }
}

extension RecordsListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
       tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? RecordListCell {
                configure(cell, at: indexPath)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        }
    }
}

extension RecordsListViewController {
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCandidate = fetchedResultsController.object(at: indexPath)
        delegate?.recordSelected(selectedCandidate)
        
        if let detailViewController = delegate as? DetailViewController,
            let detailNavigationViewController = detailViewController.navigationController {
            splitViewController?.showDetailViewController(detailNavigationViewController, sender: nil)
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections?[section] else {
            return 0
        }
        return sections.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecordListCell.identifier, for: indexPath) as? RecordListCell else {
            fatalError("Unexpected Index Path")
        }
        // Configure Cell
        configure(cell, at: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        
        // Fetch Candidate
        let candidate = fetchedResultsController.object(at: indexPath)
        
        // Delete Candidate
        managedObjectContext?.delete(candidate)
    }
    
    // MARK: - Helper Methods
    func configure(_ cell: RecordListCell, at indexPath: IndexPath) {
        // Fetch Candidate
        let candidate = fetchedResultsController.object(at: indexPath)
        // Configure Cell
        cell.candidate = candidate
    }
    
    
}
