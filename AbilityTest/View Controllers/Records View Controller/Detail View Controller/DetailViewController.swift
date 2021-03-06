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
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var avatarOffsetConstraint: NSLayoutConstraint!
    
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
            // Make view visable
            profileView.isHidden = false
            avatarImageView.isHidden = false
            
            nameLabel.text = candidate.name
            idLabel.text = candidate.id
            examinerLabel.text = candidate.examiner
            
            let intelligenceStatusIndex = candidate.isIntellecuallyDisabled ? 0 : 1
            intelligenceLabel.text = intelligenceStatus[intelligenceStatusIndex]
            
            totalScoresLabel.text = String(calculateTotalScores())
        }
    }
    
    
    func setupView() {
        
        setupProfileView()
        
        // Configure constraint
        avatarOffsetConstraint.constant = -avatarImageView.frame.height*0.65/2
        
        // Make view invisiable
        profileView.isHidden = true
        avatarImageView.isHidden = true
        
        // Configure Button
        exportButton.applyRegisterViewButtonStyle()
        exportButton.layer.cornerRadius = exportButton.frame.height/2
        
        // Always Display Master Pane
        splitViewController?.preferredDisplayMode = .allVisible
        
    }
    
    func setupProfileView() {
        let gradientLayer = CAGradientLayer()
        let startColor = UIColor(red: 38/255, green: 218/255, blue: 106/255, alpha: 1)
        let endColor = UIColor(red: 76/255, green: 206/255, blue: 220/255, alpha: 1)
        
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = profileView.bounds
        
        profileView.layer.cornerRadius = 8.0
        profileView.layer.masksToBounds = true
        
        profileView.layer.shadowRadius = 5.0
        profileView.layer.shadowColor = UIColor.black.cgColor
        profileView.layer.shadowOffset = CGSize(width: 0, height: 0)
        profileView.layer.shadowOpacity = 0.55
        profileView.layer.shadowPath = UIBezierPath(rect: profileView.bounds).cgPath
        
        profileView.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    @IBAction func unwindPDFPreview(with segue: UIStoryboardSegue) {
        
    }
}

extension DetailViewController: RecordSelectionDelegate {
    
    func recordSelected(_ candidateSelected: Candidate) {
        candidate = candidateSelected
    }
    
    func recordDeleted(_ controller: RecordsListViewController) {
        // Make view invisible
        profileView.isHidden = true
        avatarImageView.isHidden = true
    }
}

