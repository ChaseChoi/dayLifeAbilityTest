//
//  ReportFormComposer.swift
//  AbilityTest
//
//  Created by Chase Choi on 2019/3/21.
//  Copyright © 2019 Chase Choi. All rights reserved.
//

import UIKit

class ReportFormComposer: NSObject {
    
    // MARK: - Properties
    
    private let reportHTMLTemplateFileName = "reportTemplate"
    
    var pdfFilePath: String {
        let documentURL = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let pdfFilePath = "\(documentURL)/EXPORT.pdf"
        return pdfFilePath
    }
    
    // MARK: - Initialization
    
    override init() {
        super.init()
    }
    
    // MARK: - Renderer
    
    func renderPDF(for candidate: Candidate, with totalScore: Int) {
        guard let templatePath = Bundle.main.path(forResource: reportHTMLTemplateFileName, ofType: "html") else {
            return
        }
        do {
            var reportHTMLTemplateContent = try String(contentsOfFile: templatePath)
            
            // Fill Out Blank Space in the Reportnot
            let status = [true: "智力障碍", false: "正常"]
            let notApplicable = "N/A"
            reportHTMLTemplateContent = reportHTMLTemplateContent.replacingOccurrences(of: "@NAME@", with: candidate.name ?? notApplicable)
            reportHTMLTemplateContent = reportHTMLTemplateContent.replacingOccurrences(of: "@ID@", with: candidate.id ?? notApplicable)
            reportHTMLTemplateContent = reportHTMLTemplateContent.replacingOccurrences(of: "@EXAMINER@", with: candidate.examiner ?? notApplicable)
            reportHTMLTemplateContent = reportHTMLTemplateContent.replacingOccurrences(of: "@TYPE@", with: status[candidate.isIntellecuallyDisabled] ?? notApplicable)
            reportHTMLTemplateContent = reportHTMLTemplateContent.replacingOccurrences(of: "@TOTAL@", with: String(totalScore))
            
            
            // Scores of each topic
            if let topics = candidate.topics as? Set<Topic> {
                for index in 1...9 {
                    let currentTopic = topics.first {
                        $0.id == Int32(index)
                    }
                    let scores = Int(currentTopic?.score ?? 0)
                    reportHTMLTemplateContent = reportHTMLTemplateContent.replacingOccurrences(of: "@TOPIC-\(index)@", with: String(scores))
                }
                reportHTMLTemplateContent = reportHTMLTemplateContent.replacingOccurrences(of: "@NUMBER@", with: String(topics.count))
            } else {
                for index in 1...9 {
                    reportHTMLTemplateContent = reportHTMLTemplateContent.replacingOccurrences(of: "@TOPIC-\(index)@", with: notApplicable)
                }
                reportHTMLTemplateContent = reportHTMLTemplateContent.replacingOccurrences(of: "@NUMBER@", with: notApplicable)
            }
            
            // Date
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.locale = Locale(identifier: "zh_CN")
            if let createDate = candidate.createAt {
                let date = dateFormatter.string(from: createDate)
                reportHTMLTemplateContent = reportHTMLTemplateContent.replacingOccurrences(of: "@DATE@", with: date)
            } else {
                reportHTMLTemplateContent = reportHTMLTemplateContent.replacingOccurrences(of: "@DATE@", with: "N/A")
            }
            
            

            let printPageRenderer = CustomPrintPageRenderer()
            
            let printFormatter = UIMarkupTextPrintFormatter(markupText: reportHTMLTemplateContent)
            
            // Configure Print Formatter
            printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
            
            // Draw and Write PDF
            let pdfData = drawPDF(use: printPageRenderer)
            
            pdfData.write(toFile: pdfFilePath, atomically: true)
            
        } catch {
            print("Unable to Load HTML File")
        }
    }
    
    private func drawPDF(use printPageRenderer: UIPrintPageRenderer) -> NSData {
        let data = NSMutableData()
        
        UIGraphicsBeginPDFContextToData(data, CGRect.zero, nil)
        
        // Print Page by Page
        for index in 0 ..< printPageRenderer.numberOfPages {
            UIGraphicsBeginPDFPage()
            printPageRenderer.drawPage(at: index, in: UIGraphicsGetPDFContextBounds())
        }
        
        UIGraphicsEndPDFContext()
        
        return data
    }
    
}
