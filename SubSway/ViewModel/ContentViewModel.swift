//
//  ContentViewModel.swift
//  SubSway
//
//  Created by Williams SAADI on 06/10/2025.
//

import Foundation
//import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var subscriptionVM: SubscriptionViewModel
    @Published var categoryVM: CategoryViewModel
    
    init(subscriptionVM: SubscriptionViewModel, categoryVM: CategoryViewModel) {
        self.subscriptionVM = subscriptionVM
        self.categoryVM = categoryVM
    }
    
    func totalMonthlyCost() -> Float {
        subscriptionVM.mySubscriptionsList.reduce(0) { total, subscription in
            let monthlyCost = calculateMonthlyCost(for: subscription)
            return total + monthlyCost
        }
    }
    
    func calculateMonthlyCost(for subscription: Subscription) -> Float {
        let price = subscription.subscriptionPrice
        let frequency = subscription.selectionPaymentFrequency.lowercased()
        
        switch frequency {
        case "mensuelle", "mensuel":
            return price
        case "trimestrielle", "trimestriel":
            return price / 3.0
        case "annuelle", "annuel":
            return price / 12.0
        default:
            // Par défaut, considérer comme mensuel
            return price
        }
    }
    
    var categoriesPreview: [Category] {
        Array(categoryVM.categories.prefix(4))
    }
    
    var recentSubscriptions: [Subscription] {
        Array(subscriptionVM.mySubscriptionsList.prefix(3))
    }
    
    var hasSubscriptions: Bool {
        !subscriptionVM.mySubscriptionsList.isEmpty
    }
    
    var subscriptionCount: Int {
        subscriptionVM.mySubscriptionsList.count
    }
}
