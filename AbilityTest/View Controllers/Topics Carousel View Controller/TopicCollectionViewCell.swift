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
    
    @IBOutlet weak var topicGistLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundColorView: UIView!
    
    // MARK: - Properties
    
    static let identifier = "topicItemCell"
    
    var topicItem: TopicCollectionItem! {
        didSet {
            updateView()
        }
    }
    
    private func updateView() {
        if let topicItem = topicItem {
            topicGistLabel.text = topicItem.gist
            titleLabel.text = topicItem.title
        } else {
            topicGistLabel.text = nil
            titleLabel.text = nil
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        
    }
}
