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
    
    func setupView() {
        acitivityIndicatorView.stopAnimating()
        
    }
}


