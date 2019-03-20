//
//  MainViewController.swift
//  AbilityTest
//
//  Created by Chase Choi on 2019/3/19.
//  Copyright © 2019 Chase Choi. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Properties
    // TODO: Auto-Layout
    @IBOutlet weak var acitivityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - Core Data Manager
    
    private var coreDataManager: CoreDataManager?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        coreDataManager = CoreDataManager(modelName: DataModel.Candidates) {
            self.setupView()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case Segue.recordsView:
            if let splitViewController = segue.destination as? UISplitViewController,
                let navigationViewController = splitViewController.viewControllers.first as? UINavigationController,
                let recordsViewController = navigationViewController.topViewController as? RecordsListViewController {
                recordsViewController.managedObjectContext = coreDataManager?.mainManagedObjectContext
            }
        default:
            break;
        }
    }
    
    func setupView() {
        acitivityIndicatorView.stopAnimating()
        
    }
}


