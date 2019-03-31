//
//  QuestionViewController.swift
//  AbilityTest
//
//  Created by Chase Choi on 2019/3/23.
//  Copyright © 2019 Chase Choi. All rights reserved.
//

import UIKit

protocol QuestionViewControllerDelegate: class {
    func questionViewController(_ controller: QuestionViewController, didFinishTopicItemIndex: Int)
}

class QuestionViewController: UIViewController {
    
    // MARK: - @IBOutlets
    
    @IBOutlet weak var questionContentLabel: UILabel!
    @IBOutlet weak var currentQuestionIDLabel: UILabel!
    @IBOutlet weak var refImageView: UIImageView!
    
    // MARK: - Properties
    
    private var currentQuestionIndex = 0
    private var answerIndex = 0
    private var correctNumber = 0
    
    private var answers: Set<Answer> = []
    
    // Dependency Injection
    
    var questionItems: [QuestionItem]!
    var currentTopic: Topic!
    var currentTopicItemIndex: Int!
    
    // Delegate
    
    var delegate: QuestionViewControllerDelegate?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayNewQuestions()
    }
    
    // MARK: - @IBActions
    
    @IBAction func optionTapped(_ sender: AnyObject) {
        guard let managedObjectContext = currentTopic.managedObjectContext else {
            return
        }
        if (currentQuestionIndex < questionItems.count) {
            let userOption = sender.tag - 1000
            
            // Create Answer Object
            let currentAnswer = Answer(context: managedObjectContext)
            currentAnswer.chosenIndex = Int32(userOption)
            currentAnswer.id = Int32(questionItems[currentQuestionIndex].id)
            
            // Check Answer
            if (userOption == answerIndex) {
                correctNumber += 1
                currentAnswer.isCorrect = true
            } else {
                currentAnswer.isCorrect = false
            }
            
            // Add to answers array
            answers.insert(currentAnswer)
            
            displayNewQuestions()
        } else {
            // Update Data
            currentTopic.finishAt = Date()
            currentTopic.score = Int32(correctNumber)
            
            // Update Relationship
            currentTopic.addToAnswers(answers as NSSet)
            
            // Show Scores
            let message = "你已顺利完成测试!"
            let title = "总分：\(correctNumber)分"
        
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "好的", style: .default) { action -> Void in
//                self.dismiss(animated: true, completion: nil)
                self.delegate?.questionViewController(self, didFinishTopicItemIndex: self.currentTopicItemIndex)
            }
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Helper Methods
    
    func displayNewQuestions() {
        var button: UIButton = UIButton()
        
        // Get Current Question
        let currentQuestionData = questionItems[currentQuestionIndex]
        
        answerIndex = currentQuestionData.correctOptionIndex
        
        // Update UI
        currentQuestionIDLabel.text = "\(currentQuestionIndex+1)/\(questionItems.count)"
        questionContentLabel.text = currentQuestionData.questionContent
        
        for index in 0...3 {
            button = view.viewWithTag(index+1000) as! UIButton
            
            let imageName = currentQuestionData.options[index]
            let image = UIImage(named: imageName)
            button.setImage(image, for: .normal)
            if let size = image?.size {
                button.frame.size = size
            }
        }
        // Update Reference Image
        if let refImageName = currentQuestionData.refImageName {
            refImageView.image = UIImage(named: refImageName)
            refImageView.sizeToFit()
            refImageView.isHidden = false
        } else {
            refImageView.isHidden = true
        }
        
        // Update index
        currentQuestionIndex += 1
    }
}
