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
    
    func setupView() {
        webView.addSubview(activityIndicatorView)
        
        // Center activityIndicatorView
        activityIndicatorView.center = webView.convert(webView.center, from: webView.superview)
        
        // Configure ActivityIndicatorView
        activityIndicatorView.startAnimating()
        activityIndicatorView.hidesWhenStopped = true
        
        webView.navigationDelegate = self
    }
    
    // MARK: - Helper Methods
    
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
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicatorView.stopAnimating()
    }
}
