//
//  Subscription.swift
//  SubSway
//
//  Created by williams saadi on 27/03/2024.
//

import Foundation

class Subscription: Identifiable, Equatable {
	static func == (lhs: Subscription, rhs: Subscription) -> Bool {
		return lhs.id == rhs.id
	}
	
    
    var id = UUID()
    var subscriptionName : String               // nom de l'abonnement
    var subscriptionPrice: Float                // prix de l'abnnement
    var subsrciptionImageName: String           // nom de l'image
    var subscriptionDuration: Int               // duréé de l'abonnement
    var subscriptionCancellationNotice: Int     // préavis de résiliation
    var subscriptionStartDate: Date             // date de début
    var subscriptionRenewEndDate: Date          // date de fin (en fonction de la date du jour)
    var selectionPaymentFrequency: String       //Fréquence des paiements
    var isSubscriptionCommitted: Bool           // Abonnement avec engagement
    var subscriptionTrialPeriodDuration: Int            // Durée de la periode d'essai
    var isSubscriptionTrialPeriod: Bool         // Abonnment en périod d'essai
    var categoryName : String?                  // catégorie de l'abonnement
    var subscriptionInformations: String        // détails de l'abonnement
    var isReadOnly: Bool = false
    
    var subscriptionEndDate: Date {
		updateSubscriptionEndDate(subscriptionDuration: subscriptionDuration, isCommitted: isSubscriptionCommitted, isTrialPeriod: isSubscriptionTrialPeriod, subscriptionTrialPeriodDuration: subscriptionTrialPeriodDuration)
    }
    
    init(subscriptionName: String, subscriptionPrice: Float, subsrciptionImageName: String, subscriptionDuration: Int, subscriptionCancellationNotice: Int, subscriptionStartDate: Date, subscriptionRenewEndDate: Date, selectionPaymentFrequency: String, isSubscriptionCommitted: Bool, subscriptionTrialPeriod: Int, isSubscriptionTrialPeriod: Bool, categoryName: String?, subscriptionInformations: String) {
        self.subscriptionName = subscriptionName
        self.subscriptionPrice = subscriptionPrice
        self.subsrciptionImageName = subsrciptionImageName
        self.subscriptionDuration = subscriptionDuration
        self.subscriptionCancellationNotice = subscriptionCancellationNotice
        self.subscriptionStartDate = subscriptionStartDate
        self.subscriptionRenewEndDate = subscriptionRenewEndDate
        self.selectionPaymentFrequency = selectionPaymentFrequency
        self.isSubscriptionCommitted = isSubscriptionCommitted
        self.subscriptionTrialPeriodDuration = subscriptionTrialPeriod
        self.isSubscriptionTrialPeriod = isSubscriptionTrialPeriod
        self.categoryName = categoryName
        self.subscriptionInformations = subscriptionInformations
    }
    
    init() {
        self.subscriptionName = ""
        self.subscriptionPrice = 0
        self.subsrciptionImageName = ""
        self.subscriptionDuration = 0
        self.subscriptionCancellationNotice = 0
        self.subscriptionStartDate = Date()
        self.subscriptionRenewEndDate = Date()
        self.selectionPaymentFrequency = ""
        self.isSubscriptionCommitted = false
        self.subscriptionTrialPeriodDuration = 0
        self.isSubscriptionTrialPeriod = false
        self.categoryName = ""
        self.subscriptionInformations = ""
    }
    
	private func updateSubscriptionEndDate(subscriptionDuration: Int, isCommitted: Bool, isTrialPeriod: Bool, subscriptionTrialPeriodDuration: Int) -> Date {
		
		var numbersOfMonths = 0
		
		if isCommitted {
			numbersOfMonths = subscriptionDuration
		} else if isTrialPeriod {
			numbersOfMonths = subscriptionTrialPeriodDuration
		} else {
			numbersOfMonths = 12
		}
		
        let today = Date()
        let initialEndDate = Calendar.current.date(byAdding: .month, value: subscriptionDuration, to: subscriptionStartDate) ?? Date()
        let oneDayAfterStartDate = Calendar.current.date(byAdding: .day, value: 1, to: subscriptionStartDate)!
        let monthsAfterStartDate = Calendar.current.date(byAdding: .month, value: numbersOfMonths, to: subscriptionStartDate)!
		let monthsAfterEndDate = Calendar.current.date(byAdding: .month, value: numbersOfMonths == 0 ? 12 : numbersOfMonths
													   , to: initialEndDate)!

        if today < oneDayAfterStartDate {
            return monthsAfterStartDate
        } else if today > initialEndDate {
            return monthsAfterEndDate
        } else {
            return initialEndDate
        }
    }
}
