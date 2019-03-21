//
//  CustomPrintPageRenderer.swift
//  AbilityTest
//
//  Created by Chase Choi on 2019/3/21.
//  Copyright © 2019 Chase Choi. All rights reserved.
//

import UIKit

class CustomPrintPageRenderer: UIPrintPageRenderer {
    
    // Specify Paper Size
    
    private let a4Pagewidth: CGFloat = 595.2
    private let a4PageHeight: CGFloat = 841.8
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        
        // Specify A4 Page Frame
        let paperFrame = CGRect(x: 0, y: 0, width: a4Pagewidth, height: a4PageHeight)
        
        // Configure Page Frame and Insets
        
        self.setValue(NSValue(cgRect: paperFrame), forKey: "paperRect")
        self.setValue(NSValue(cgRect: paperFrame), forKey: "printableRect")
    }
    
}
