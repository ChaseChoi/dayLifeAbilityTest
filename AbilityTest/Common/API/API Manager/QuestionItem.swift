//
//  QuestionItem.swift
//  AbilityTest
//
//  Created by Chase Choi on 2019/3/23.
//  Copyright © 2019 Chase Choi. All rights reserved.
//

import UIKit

struct QuestionItem: Decodable {
    let topic: Int
    let id: Int
    let questionContent: String
    let correctOptionIndex: Int
    let refImageName: String?
    let options: [String]
}
