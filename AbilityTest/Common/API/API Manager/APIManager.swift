//
//  APIManager.swift
//  AbilityTest
//
//  Created by Chase Choi on 2019/3/22.
//  Copyright © 2019 Chase Choi. All rights reserved.
//

import UIKit

enum AbilityTestAPI {
    static let topcisJSONFileName = "topics"
    static let questionsJSONFileName = "questions"
    static func getQuestionsJSONFileName(for topic: Int) -> String {
        let filename = "\(questionsJSONFileName)-\(topic)"
        return filename
    }
}

class APIManager {
    static func loadTopics() -> [TopicCollectionItem] {
        var topicItems: [TopicCollectionItem] = []
        
        do {
            guard let topicsURL = Bundle.main.url(forResource: AbilityTestAPI.topcisJSONFileName, withExtension: "json") else {
                return topicItems
            }
            let topicsJSONData = try Data(contentsOf: topicsURL)
            
            topicItems = try JSONDecoder().decode([TopicCollectionItem].self, from: topicsJSONData)
        } catch {
            print(error.localizedDescription)
        }
        return topicItems
    }
    
    static func loadQuestions(for topic: Int) -> [QuestionItem] {
        var questions: [QuestionItem] = []
        
        do {
            let filename = AbilityTestAPI.getQuestionsJSONFileName(for: topic)
            
            guard let questionsURL = Bundle.main.url(forResource: filename, withExtension: "json") else {
                return questions
            }
            let questionsJSONData = try Data(contentsOf: questionsURL)
            
            questions = try JSONDecoder().decode([QuestionItem].self, from: questionsJSONData)
        } catch {
            print(error.localizedDescription)
        }
        
        return questions
    }
}
