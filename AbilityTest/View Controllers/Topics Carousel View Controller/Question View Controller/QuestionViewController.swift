//
//  QuestionViewController.swift
//  AbilityTest
//
//  Created by Chase Choi on 2019/3/23.
//  Copyright © 2019 Chase Choi. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {
    
    // MARK: - @IBOutlets
    
    @IBOutlet weak var questionContentLabel: UILabel!
    @IBOutlet weak var currentQuestionIDLabel: UILabel!
    @IBOutlet weak var refImageView: UIImageView!
    
    // MARK: - Properties
    
    private var currentQuestionIndex = 0
    private var answerIndex = 0
    private var correctNumber = 0
    
    var questionItems: [QuestionItem]!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayNewQuestions()
    }
    
    // MARK: - @IBActions
    
    @IBAction func optionTapped(_ sender: AnyObject) {
        if (currentQuestionIndex < questionItems.count) {
            if (sender.tag-1000 == answerIndex) {
                correctNumber += 1
            }
            // TODO: Update Candidate Data
            displayNewQuestions()
        } else {
            // Show Scores
            let message = "你已顺利完成测试!"
            let title = "总分：\(correctNumber)分"
        
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "好的", style: .default) { action -> Void in
                self.dismiss(animated: true, completion: nil)
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
