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
    @IBOutlet weak var closeButton: UIButton!
    
    // MARK: - Properites
    
    var candidate: Candidate?
    
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 50, left: 20, bottom: 50, right: 20)
    
    // Load Topics
    var topicItems: [TopicCollectionItem] = APIManager.loadTopics()
    var questionItems: [QuestionItem]?
    var selectedTopicItemIndex: Int?
    
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
                let questionItems = questionItems,
            let managedObjectContext = candidate?.managedObjectContext,
            let selectedTopicItemIndex = selectedTopicItemIndex {
                // Create Topic Object
                let topic = Topic(context: managedObjectContext)
                
                // Delegate
                questionViewController.delegate = self
                
                // Configure Topic Object
                topic.startAt = Date()
                topic.questionNumbers = Int32(questionItems.count)
                topic.id = Int32(questionItems[0].topic)
                
                questionViewController.questionItems = questionItems
                questionViewController.currentTopic = topic
                questionViewController.currentTopicItemIndex = selectedTopicItemIndex
            }
        default:
            break
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        var flag = true
        if identifier == Segue.questionsView {
            
            guard let cell = sender as? TopicCollectionViewCell,
                let indexPath = self.topicCollectionView?.indexPath(for: cell) else {
                    return flag
                    
            }
            
            // Update selected index
            selectedTopicItemIndex = indexPath.row
            
            // Check Question File
            let currentTopicID = topicItems[indexPath.row].id
            questionItems = APIManager.loadQuestions(for: currentTopicID)
            
            if questionItems?.count == 0 {
                flag = false
                let message = "请确认数据文件是否存在！"
                let title = "数据载入失败"
                
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let action = UIAlertAction(title: "好的", style: .default, handler: nil)
                alertController.addAction(action)
                present(alertController, animated: true, completion: nil)
            }
        }
        
        return flag
    }
    
    // MARK: - Helper Methods
    
    func setupView() {
        // Setup Collection View
        
        topicCollectionView.delegate = self
        topicCollectionView.dataSource = self
        
        // Configure close button
        closeButton.applyRegisterViewButtonStyle()
        closeButton.layer.cornerRadius = closeButton.frame.height/2
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

extension TopicsCarouselViewController: QuestionViewControllerDelegate {
    func questionViewController(_ controller: QuestionViewController, didFinishTopicItemIndex: Int) {
        
        // Update collection view data source
        var finishedTopicItem = topicItems[didFinishTopicItemIndex]
        finishedTopicItem.finishStatus = true
        
        // Update view
        let indexPath = IndexPath(row: didFinishTopicItemIndex, section: 0)
        
        if let cell = topicCollectionView.cellForItem(at: indexPath) as? TopicCollectionViewCell {
            cell.topicItem = finishedTopicItem
        }
        
        // Dismiss
        dismiss(animated: true, completion: nil)
    }
}
