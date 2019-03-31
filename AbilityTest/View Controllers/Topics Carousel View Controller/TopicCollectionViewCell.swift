//
//  TopicCollectionViewCell.swift
//  AbilityTest
//
//  Created by Chase Choi on 2019/3/22.
//  Copyright © 2019 Chase Choi. All rights reserved.
//

import UIKit

class TopicCollectionViewCell: UICollectionViewCell {
    
    // MARK: - @IBOutlets
    @IBOutlet weak var finishStatusLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundColorView: UIView!
    
    // MARK: - Properties
    
    static let identifier = "topicItemCell"
    private let status = ["🌟已完成🌟", "未完成"]
    
    var topicItem: TopicCollectionItem! {
        didSet {
            updateView()
        }
    }
    
    private func updateView() {
        if let topicItem = topicItem {
            let statusIndex = topicItem.finishStatus ? 0 : 1
            titleLabel.text = topicItem.title
            finishStatusLabel.text = status[statusIndex]
        } else {
            titleLabel.text = nil
            finishStatusLabel.text = nil
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true
        
        self.layer.shadowRadius = 4.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.layer.shadowOpacity = 0.5
    }
}
