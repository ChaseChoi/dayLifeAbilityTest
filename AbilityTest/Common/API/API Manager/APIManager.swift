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
}
