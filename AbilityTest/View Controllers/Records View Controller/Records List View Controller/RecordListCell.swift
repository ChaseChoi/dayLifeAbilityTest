//
//  RecordListCell.swift
//  AbilityTest
//
//  Created by Chase Choi on 2019/3/20.
//  Copyright © 2019 Chase Choi. All rights reserved.
//

import UIKit

class RecordListCell: UITableViewCell {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var createDateLabel: UILabel!
    
    
    // MARK: - Properties
    
    static let identifier = "RecordListCell"
    
    var candidate: Candidate? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let name = candidate?.name, let createDate = candidate?.createAt {
            nameLabel.text = name
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            dateFormatter.locale = Locale(identifier: "zh_CN")
            createDateLabel.text = dateFormatter.string(from: createDate)
        } else {
            nameLabel.text = "未知"
        }
    }
}


