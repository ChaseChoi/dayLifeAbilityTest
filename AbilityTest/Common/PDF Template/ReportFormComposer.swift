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
    
    func renderPDF() {
        guard let templatePath = Bundle.main.path(forResource: reportHTMLTemplateFileName, ofType: "html") else {
            return
        }
        do {
            let reportHTMLTemplateContent = try String(contentsOfFile: templatePath)
            
            // TODO: Fill Out Blank Space in the Report
            

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
