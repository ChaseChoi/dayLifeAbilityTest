//
//  DetailViewController.swift
//  AbilityTest
//
//  Created by Chase Choi on 2019/3/20.
//  Copyright © 2019 Chase Choi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: - Properties
    var candidate: Candidate? {
        didSet {
            updateView()
        }
    }
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        // Always Display Master Pane
        splitViewController?.preferredDisplayMode = .allVisible
    }
    
    // MARK: - Helper Methods
    
    func updateView() {
        if let candidate = candidate {
            nameLabel.text = candidate.name
        }
    }
}

extension DetailViewController: RecordSelectionDelegate {
    func recordSelected(_ candidateSelected: Candidate) {
        candidate = candidateSelected
    }
}

