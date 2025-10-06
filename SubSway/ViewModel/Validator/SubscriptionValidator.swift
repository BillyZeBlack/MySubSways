//
//  SubscriptionValidator.swift
//  SubSway
//
//  Created by williams saadi on 27/03/2024.
//

import Foundation

struct SubscriptionValidator {
    
    func validate(subscription: Subscription) throws
    {
        /* Le prix est inf. à 0 */
        if subscription.subscriptionPrice < 0 {
            throw SubscriptionValidatorError.invalidNegativePrice
        }
        
        /* Le prix n'est pas au bon format */
        if subscription.subscriptionPrice.isNaN {
            throw SubscriptionValidatorError.invalidPrice
        }
        
        /* la durée de l'engagement est inf à 1 mois */
        if subscription.isSubscriptionCommitted && subscription.subscriptionDuration < 1{
            throw SubscriptionValidatorError.invalidNegativeDeadline
        }
        
        /* L'abonnement à un engagement et, est une période d'essai */
        if subscription.isSubscriptionCommitted && subscription.isSubscriptionTrialPeriod {
            throw SubscriptionValidatorError.invalidSubscriptionState
        }
        
        /* L'abonnement à un engagement et, une durée de période d'essai */
        if subscription.isSubscriptionCommitted && subscription.subscriptionTrialPeriodDuration != 0 {
            throw SubscriptionValidatorError.invalidSubscriptionState
        }
        
        /* L'abonnement est une période d'essai et a une durée d'engagement */
        if subscription.isSubscriptionTrialPeriod && subscription.subscriptionDuration != 0 {
            throw SubscriptionValidatorError.invalidSubscriptionState
        }
        
        if subscription.isSubscriptionTrialPeriod && subscription.subscriptionTrialPeriodDuration <= 0 {
            throw SubscriptionValidatorError.invalidSubscriptionTrialPeriod
        }
        
        if subscription.subscriptionName.isEmpty {
            throw SubscriptionValidatorError.invalidSubscriptionName
        }
    }
}

extension SubscriptionValidator {
    enum SubscriptionValidatorError: LocalizedError {
        case invalidPrice
        case invalidNegativePrice
        case invalidDeadline
        case invalidNegativeDeadline
        case invalidSubscriptionState
        case invalidSubscriptionTrialPeriod
        case invalidSubscriptionName
        //case invalidSubscriptionStatus
    }
}

extension SubscriptionValidator.SubscriptionValidatorError {
    var errorDescription: String? {
        switch self {
        case.invalidPrice:
            return NSLocalizedString("Fail : The price must not be empty. Enter 0 if this is a trial period.", comment: "invalid price")
            
        case.invalidNegativePrice:
            return NSLocalizedString("Fail : The subscription price cannot be negative.", comment: "negative price")
            
        case.invalidDeadline:
            return NSLocalizedString(" Fail : The duration of the commitment is not valid.", comment: "invalid deadline")
            
        case.invalidNegativeDeadline:
            return NSLocalizedString("Erreur : The duration of the commitment must be greater than 0.", comment: "negative deadline")
            
        case.invalidSubscriptionState:
            return NSLocalizedString("Fail : A subscription cannot be both a trial period and a commitment.", comment: "invalid state")
            
        case.invalidSubscriptionTrialPeriod:
            return NSLocalizedString("Fail : The duration of the trial period must be greater than 0.", comment: "invalid trial period")
        
        case.invalidSubscriptionName:
            return NSLocalizedString("Fail : The name of subscription can not be empty.", comment: "invalid subscription name")
            
        /*case.invalidSubscriptionStatus:
            return NSLocalizedString("Fail : You must select if your subscription is with commit or with a trial period.", comment: "invalid status")*/
        }
    }
}
