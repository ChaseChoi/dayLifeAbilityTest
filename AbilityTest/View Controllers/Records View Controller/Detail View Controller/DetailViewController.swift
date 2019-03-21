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
        super.viewDidLoad()
        
        // Always Display Master Pane
        splitViewController?.preferredDisplayMode = .allVisible
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case Segue.pdfPreviewView:
            if let navigationViewController = segue.destination as? UINavigationController,
                let pdfPreviewController = navigationViewController.topViewController as? PDFPreviewViewController, let candidate = candidate {
                pdfPreviewController.candidate = candidate
            }
        default:
            break
        }
    }
    
    // MARK: - Helper Methods
    
    func updateView() {
        if let candidate = candidate {
            nameLabel.text = candidate.name
        }
    }
    
    @IBAction func unwindPDFPreview(with segue: UIStoryboardSegue) {
        
    }
}

extension DetailViewController: RecordSelectionDelegate {
    func recordSelected(_ candidateSelected: Candidate) {
        candidate = candidateSelected
    }
}

