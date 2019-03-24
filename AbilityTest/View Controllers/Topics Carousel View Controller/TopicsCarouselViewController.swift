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
    
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 50, left: 20, bottom: 50, right: 20)
    
    // Load Data
    var topicItems: [TopicCollectionItem] = APIManager.loadTopics()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in self.topicCollectionView.collectionViewLayout.invalidateLayout() }, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        switch identifier {
        case Segue.questionsView:
            if let questionViewController = segue.destination as? QuestionViewController,
                let cell = sender as? TopicCollectionViewCell,
                let indexPath = self.topicCollectionView?.indexPath(for: cell) {
                let currentTopicID = topicItems[indexPath.row].id
                questionViewController.currentTopicID = currentTopicID
            }
        default:
            break
        }
    }
    
    // MARK: - Helper Methods
    
    func setupView() {
        // Setup Collection View
        
        topicCollectionView.delegate = self
        topicCollectionView.dataSource = self
    }
    
}

// MARK: - UICollectionViewDataSource

extension TopicsCarouselViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topicItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicCollectionViewCell.identifier, for: indexPath) as! TopicCollectionViewCell
        let topic = topicItems[indexPath.item]
        
        cell.topicItem = topic
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension TopicsCarouselViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
