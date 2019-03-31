//
//  TopicCollectionItem.swift
//  AbilityTest
//
//  Created by Chase Choi on 2019/3/22.
//  Copyright © 2019 Chase Choi. All rights reserved.
//

import UIKit

struct TopicCollectionItem: Decodable {
    let id: Int
    let title: String
    let gist: String
    var finishStatus: Bool
}
