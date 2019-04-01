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
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var examinerLabel: UILabel!
    @IBOutlet weak var intelligenceLabel: UILabel!
    @IBOutlet weak var totalScoresLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var exportButton: UIButton!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var profileView: UIView!
    
    // MARK: - Properties
    
    var candidate: Candidate? {
        didSet {
            updateView()
        }
    }
    
    private let intelligenceStatus = ["智力障碍", "正常"]
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
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
                pdfPreviewController.totalScore = calculateTotalScores()
            }
        default:
            break
        }
    }
    
    // MARK: - Helper Methods
    
    func calculateTotalScores() -> Int {
        var totalScores: Int32 = 0
        if let topics = candidate?.topics as? Set<Topic> {
            totalScores = topics.reduce(0) {
                $0 + $1.score
            }
        }
        return Int(totalScores)
    }
    
    // Configure View
    func updateView() {
        if let candidate = candidate {
            nameLabel.text = candidate.name
            idLabel.text = candidate.id
            examinerLabel.text = candidate.examiner
            
            let intelligenceStatusIndex = candidate.isIntellecuallyDisabled ? 0 : 1
            intelligenceLabel.text = intelligenceStatus[intelligenceStatusIndex]
            
            // Configure First Name Label
            firstNameLabel.text = String(candidate.name?.prefix(1) ?? "")
            
            totalScoresLabel.text = String(calculateTotalScores())
        }
    }
    
    
    func setupView() {
        // Make view visable
        profileView.isHidden = false
        
        // Configure text color
        firstNameLabel.textColor = .white
        
        // Configure Button
        exportButton.applyRegisterViewButtonStyle()
        exportButton.layer.cornerRadius = exportButton.frame.height/2
        
        // Always Display Master Pane
        splitViewController?.preferredDisplayMode = .allVisible
        
    }
    
    @IBAction func unwindPDFPreview(with segue: UIStoryboardSegue) {
        
    }
}

extension DetailViewController: RecordSelectionDelegate {
    func recordSelected(_ candidateSelected: Candidate) {
        candidate = candidateSelected
    }
}

