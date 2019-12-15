//
//  DataViewModel.swift
//  AthenaHealth
//
//  Created by Saurav Satpathy on 15/12/19.
//  Copyright © 2019 Saurav Satpathy. All rights reserved.
//

import Foundation
class DataViewModel {
    var categories: Categories?
    var topics: Topics?
    var topicSubKeys: TopicSubKeys?
    var receivedData: (()->Void)?
    lazy var dataService = DataService()
    
    func downloadData() {
        dataService.getData {[unowned self] (categories, topics, topicSubKeys) in
            self.categories = categories
            self.topics = topics
            self.topicSubKeys = topicSubKeys
            self.receivedData?()
        }
    }
    func disease(for key: String) -> String? {
        return dataService.readDisease(for: key)
    }
}
