//
//  Category.swift
//  SubSway
//
//  Created by williams saadi on 27/03/2024.
//

import Foundation

class Category: Identifiable, Hashable {
    var id = UUID()
    var categoryName: String
    var categoryImageName: String
    
    init(categoryName: String, categoryImageName: String, subcriptions: [Subscription]) {
        self.categoryName = categoryName
        self.categoryImageName = categoryImageName
    }
    
    init() {
        self.categoryName = ""
        self.categoryImageName = ""
    }
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
    }
    
    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.id == rhs.id
    }
}
