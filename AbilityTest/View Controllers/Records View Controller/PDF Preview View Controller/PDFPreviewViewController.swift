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
        let fileManager = FileManager.default
        let pdfFilePath = reportFormComposer.pdfFilePath
        
        // Check if File Exists
        if fileManager.fileExists(atPath: pdfFilePath) {
            if let pdfData = NSData(contentsOfFile: pdfFilePath) {
                // TODO: Add String about User Info
                let reportTitle = "日常生活活动能力评估报告"
                let activityViewController = UIActivityViewController(activityItems: [pdfData, reportTitle], applicationActivities: nil)
                
                // For iPad
                if let popOverController = activityViewController.popoverPresentationController {
                    popOverController.barButtonItem = actionButton
                }
                present(activityViewController, animated: true, completion: nil)
            }
        } else {
            // Configure Alert Controller
            let title = "加载失败"
            let message = "PDF文件加载失败, 请检查文件路径"
            let buttonTitle = "好的"
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
            alertController.addAction(action)

            // Show Alert
            present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Helper Methods
    
    func setupView() {
        // Disable buttons
        switchBarButtonItems(to: false)
        
        // Add activityIndicatorView to webView
        webView.addSubview(activityIndicatorView)
        
        // Center activityIndicatorView
        activityIndicatorView.center = webView.convert(webView.center, from: webView.superview)
        
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
        // Compose PDF
        reportFormComposer.renderPDF()
        
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
