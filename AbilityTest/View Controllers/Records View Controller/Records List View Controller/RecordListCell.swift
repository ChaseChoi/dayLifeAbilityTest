//
//  RecordListCell.swift
//  AbilityTest
//
//  Created by Chase Choi on 2019/3/20.
//  Copyright © 2019 Chase Choi. All rights reserved.
//

import UIKit

class RecordListCell: UITableViewCell {
    
    // MARK: IBOutlet
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    // MARK: - Properties
    
    static let identifier = "RecordListCell"
    
    var candidate: Candidate? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let name = candidate?.name {
            nameLabel.text = name
        } else {
            nameLabel.text = "未知"
        }
    }
}


