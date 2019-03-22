//
//  TopicsCarouselViewController.swift
//  AbilityTest
//
//  Created by Chase Choi on 2019/3/22.
//  Copyright © 2019 Chase Choi. All rights reserved.
//

import UIKit

class TopicsCarouselViewController: UIViewController {
    
    // MARK: - @IBOutlets
    
    @IBOutlet weak var topicCollectionView: UICollectionView!
    
    // MARK: - Properites
    
    var candidate: Candidate?
    let apiManager = APIManager()
    var topicItems: [TopicCollectionItem]?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        setupView()
    }
    
    // MARK: - Helper Methods
    
    func loadData() {
        topicItems = apiManager.loadTopics()
    }
    
    func setupView() {
        
    }
}
