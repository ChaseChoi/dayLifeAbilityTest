//
//  DetailViewController.swift
//  AbilityTest
//
//  Created by Chase Choi on 2019/3/20.
//  Copyright © 2019 Chase Choi. All rights reserved.
//

import UIKit
import Charts

class DetailViewController: UIViewController {
    
    // MARK: - @IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var examinerLabel: UILabel!
    @IBOutlet weak var intelligenceLabel: UILabel!
    @IBOutlet weak var totalScoresLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var exportButton: UIButton!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var avatarOffsetConstraint: NSLayoutConstraint!
    @IBOutlet weak var barChartView: BarChartView!
    
    // MARK: - Properties
    
    var candidate: Candidate? {
        didSet {
            updateView()
        }
    }
    
    private let intelligenceStatus = ["智力障碍", "正常"]
    
    // Bar chart data source
    var barChartDataEntries: [BarChartDataEntry] = []
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        configureBarChart()
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
    
    // MARK: - Configure View
    func updateView() {
        if let candidate = candidate {
            // Make view visable
            hideView(status: false)
            
            nameLabel.text = candidate.name
            idLabel.text = candidate.id
            examinerLabel.text = candidate.examiner
            
            let intelligenceStatusIndex = candidate.isIntellecuallyDisabled ? 0 : 1
            intelligenceLabel.text = intelligenceStatus[intelligenceStatusIndex]
            
            totalScoresLabel.text = String(calculateTotalScores())
            
            populateDataEntries()
        }
    }
    
    
    func setupView() {
        
        setupProfileView()
        
        // Configure constraint
        avatarOffsetConstraint.constant = -avatarImageView.frame.height*0.65/2
        
        // Make view invisiable
        hideView(status: true)
        
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
    
    func hideView(status: Bool) {
        profileView.isHidden = status
        avatarImageView.isHidden = status
        barChartView.isHidden = status
    }
    
    // MARK: - Bar Chart
    
    func configureBarChart() {
        
        // Configure appearance
        barChartView.chartDescription?.text = ""
        barChartView.noDataText = "暂无数据"
        barChartView.noDataFont = UIFont.systemFont(ofSize: 17)
        barChartView.noDataTextColor = UIColor(red: 152/255, green: 166/255, blue: 195/255, alpha: 1)
        barChartView.legend.enabled = false
        
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.enabled = false
        barChartView.xAxis.granularity = 1
        
        // Disable interaction
        barChartView.isUserInteractionEnabled = false
        
        // Set min and max value for y axis
        barChartView.leftAxis.axisMinimum = 0.0
        barChartView.leftAxis.axisMaximum = 24.0
    }
    
    func populateDataEntries() {
        // Remove all entries before
        barChartDataEntries.removeAll()
        
        // Get scores of each topic
        if let topicsSet = candidate?.topics as? Set<Topic> {
            // Get topic objects
            var topicsArray = Array(topicsSet)
            topicsArray.sort {
                $0.id < $1.id
            }
            let total = topicsArray.count
            
            for index in 0..<total {
                let scoreEntry = BarChartDataEntry(x: Double(topicsArray[index].id), y: Double(topicsArray[index].score))
                barChartDataEntries.append(scoreEntry)
            }
            
            barChartView.xAxis.labelCount = total
            
            // Populate
            let barChartDataSet = BarChartDataSet(values: barChartDataEntries, label: nil)
            let barChartData = BarChartData(dataSet: barChartDataSet)
            
            // Configure Color
            barChartDataSet.colors = ChartColorTemplates.vordiplom()
            
            // Feed Data
            barChartView.data = barChartData
            
            // Animation
            barChartView.animate(yAxisDuration: 0.8, easingOption: .easeInOutSine)
        }
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
        hideView(status: true)
    }
}

