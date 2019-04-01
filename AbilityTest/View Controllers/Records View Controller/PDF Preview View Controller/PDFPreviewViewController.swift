//
//  PDFPreviewViewController.swift
//  AbilityTest
//
//  Created by Chase Choi on 2019/3/21.
//  Copyright © 2019 Chase Choi. All rights reserved.
//

import UIKit
import WebKit

class PDFPreviewViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var actionButton: UIBarButtonItem!
    
    // MARK: - Properties
    
    var candidate: Candidate?
    var totalScore: Int?
    
    // TODO: Need to Replace some cells
    
    let reportFormComposer = ReportFormComposer()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadPDF()
    }
    
    // MARK: - Share via Email
    
    @IBAction func shareButtonTapped() {
        // Get PDF File Path
        let pdfFilePath = reportFormComposer.pdfFilePath
        
        // Get PDF File URL
        let pdfURL = URL(fileURLWithPath: pdfFilePath)
        
        let reportTitle = "日常生活活动能力评估报告"
        let activityViewController = UIActivityViewController(activityItems: [pdfURL, reportTitle], applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.barButtonItem = actionButton
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: - Helper Methods
    
    func setupView() {
        // Disable buttons
        switchBarButtonItems(to: false)
        
        // Add activityIndicatorView to webView
        webView.addSubview(activityIndicatorView)
        
        // Configure ActivityIndicatorView
        activityIndicatorView.startAnimating()
        activityIndicatorView.hidesWhenStopped = true
        
        webView.navigationDelegate = self
    }
    
    func switchBarButtonItems(to status: Bool) {
        doneButton.isEnabled = status
        actionButton.isEnabled = status
    }
    
    func loadPDF() {
        guard let candidate = candidate, let totalScore = totalScore else {
            return
        }
        // Compose PDF
        reportFormComposer.renderPDF(for: candidate, with: totalScore)
        
        // Preview PDF via WKWebView
        let pdfFilePath = reportFormComposer.pdfFilePath
        let pdfFileURL = URL(fileURLWithPath: pdfFilePath)
        self.webView.loadFileURL(pdfFileURL, allowingReadAccessTo: pdfFileURL)
    }
}

extension PDFPreviewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicatorView.stopAnimating()
        switchBarButtonItems(to: true)
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicatorView.stopAnimating()
        switchBarButtonItems(to: true)
    }
}
