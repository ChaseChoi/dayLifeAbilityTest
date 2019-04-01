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
    @IBOutlet weak var acitivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var checkRecordsButton: UIButton!
    
    // MARK: - Core Data Manager
    
    private var coreDataManager: CoreDataManager?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createButton.isHidden = true
        checkRecordsButton.isHidden = true
        
        coreDataManager = CoreDataManager(modelName: DataModel.Candidates) {
            self.setupView()
            self.loadSampleData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case Segue.recordsView:
            if let splitViewController = segue.destination as? UISplitViewController,
                let leftNavigationController = splitViewController.viewControllers.first as? UINavigationController,
                let recordsViewController = leftNavigationController.topViewController as? RecordsListViewController,
            let rightNavigationController = splitViewController.viewControllers.last as? UINavigationController,
                let detailViewController = rightNavigationController.topViewController as? DetailViewController {
                // Dependency Injection
                recordsViewController.managedObjectContext = coreDataManager?.mainManagedObjectContext
                
                // Delegate
                recordsViewController.delegate = detailViewController
            }
        case Segue.registerView:
            if let registerViewController = segue.destination as? RegisterViewController {
                // Dependency Injection
                registerViewController.managedObjectContext = coreDataManager?.mainManagedObjectContext
            }
        default:
            break;
        }
    }
    
    // MARK: - Helper Methods
    
    func setupView() {
        acitivityIndicatorView.stopAnimating()
        
        createButton.isHidden = false
        createButton.applyRegisterViewButtonStyle()
        checkRecordsButton.isHidden = false
        checkRecordsButton.applyRegisterViewButtonStyle()
    }
    
    func loadSampleData() {
        guard let managedObjectContext = coreDataManager?.mainManagedObjectContext else {
            return
        }
        let names = ["张三", "李四", "王五"]
        let ids = ["20152100179", "20152100180", "20152100181"]
        let examiners = ["王老师", "蔡老师", "刘老师"]
        let statusList = [true, false, true]
        for i in 0..<3 {
            let newCandidate = Candidate(context: managedObjectContext)
            newCandidate.name = names[i]
            newCandidate.createAt = Date()
            newCandidate.id = ids[i]
            newCandidate.examiner = examiners[i]
            newCandidate.isIntellecuallyDisabled = statusList[i]
            
            for topicIndex in 1...9 {
                let topic = Topic(context: managedObjectContext)
                // Configure
                topic.startAt = Date()
                topic.finishAt = Date()
                topic.id = Int32(topicIndex)
                topic.questionNumbers = Int32(24)
                topic.score = Int32(1 + arc4random_uniform(24))
                // Relationship
                topic.candidate = newCandidate
            }
        }
    }
    
    // MARK: - @IBActions
    
    @IBAction func unwindRegisterView(with segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindRecordsView(with segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindTopcisView(with segue: UIStoryboardSegue) {
        
    }
}


