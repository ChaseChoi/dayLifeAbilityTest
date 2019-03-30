//
//  RegisterTextField.swift
//  AbilityTest
//
//  Created by Chase Choi on 2019/3/30.
//  Copyright © 2019 Chase Choi. All rights reserved.
//

import UIKit

@IBDesignable
class RegisterTextField: UITextField {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.borderColor = UIColor(white: 231/255, alpha: 1).cgColor
        self.layer.borderWidth = 1
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 7)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
}
