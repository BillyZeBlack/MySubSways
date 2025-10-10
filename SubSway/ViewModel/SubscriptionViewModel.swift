//
//  SubscriptionViewModel.swift
//  SubSway
//
//  Created by williams saadi on 27/03/2024.
//

import Foundation
import SwiftUI
import CoreData

class SubscriptionViewModel: ObservableObject {
    private var categoryVM: CategoryViewModel
    
    @Published var mySubscriptionsList : [Subscription] = []
    @Published var subscriptionsList: [Subscription] = []
    
    //	let container: NSPersistentContainer
    
    var subValidator = SubscriptionValidator()
    var floatValuePrice : Float = 0
    
    init(categoryVM: CategoryViewModel) {
        self.categoryVM = categoryVM
        
        if !mySubscriptionsList.isEmpty {
            for subscription in mySubscriptionsList {
                if subscription.subscriptionRenewEndDate < Date() {
                    subscription.subscriptionRenewEndDate = subscription.subscriptionEndDate
                }
            }
        }
    }
    
    func addSubscription(subscriptionImageName: String,
                         subscriptionName: String,
                         subscriptionPrice: String,
                         subscriptionDuration: String,
                         subscriptionCancellationNotice: String,
                         subscriptionStartDate: Date,
                         subscriptionIsCommited: Bool,
                         subscriptionIsTrialPeriod: Bool,
                         subscriptionTrialPeriod: String,
                         subscriptionCategoryName: String,
                         subscriptionInformation: String,
                         subscriptionSelectionPayementFrequency: String,
                         subscriptionId: UUID? )-> (String, Subscription?) {
        
        let subscription = Subscription()
        
        guard validateFloatNumber(value: subscriptionPrice) else {
            return ("Erreur : Veuillez vérifier vos informations", nil)
        }
        
        subscription.subsrciptionImageName = subscriptionImageName
        subscription.subscriptionName = subscriptionName
        subscription.subscriptionPrice = floatValuePrice
        subscription.subscriptionDuration = Int(subscriptionDuration) ?? 0
        subscription.subscriptionCancellationNotice = Int(subscriptionCancellationNotice) ?? 0
        subscription.subscriptionStartDate = subscriptionStartDate
        subscription.isSubscriptionCommitted = subscriptionIsCommited
        subscription.isSubscriptionTrialPeriod = subscriptionIsTrialPeriod
        subscription.subscriptionTrialPeriodDuration = Int(subscriptionTrialPeriod) ?? 0
        subscription.categoryName = subscriptionCategoryName
        subscription.subscriptionInformations = subscriptionInformation
        subscription.selectionPaymentFrequency = subscriptionSelectionPayementFrequency
        
        if let message = validateDetails(of: subscription), !message.isEmpty {
            return (message, nil)
        } else {
            subscription.subscriptionRenewEndDate = subscription.subscriptionEndDate
            
            if subscriptionId != nil {
                if !subscriptionsList.contains(where: { $0 == subscription}) {
                    subscriptionsList.append(subscription)
                } else {
                    if let index = subscriptionsList.firstIndex(where: {$0.id == subscription.id}) {
                        subscriptionsList[index].subsrciptionImageName = subscription.subsrciptionImageName
                        subscriptionsList[index].subscriptionName = subscription.subscriptionName
                        subscriptionsList[index].subscriptionPrice = subscription.subscriptionPrice
                        subscriptionsList[index].subscriptionDuration = subscription.subscriptionDuration
                        subscriptionsList[index].subscriptionCancellationNotice = subscription.subscriptionCancellationNotice
                        subscriptionsList[index].subscriptionStartDate = subscription.subscriptionStartDate
                        subscriptionsList[index].isSubscriptionCommitted = subscription.isSubscriptionCommitted
                        subscriptionsList[index].isSubscriptionTrialPeriod = subscription.isSubscriptionTrialPeriod
                        subscriptionsList[index].isSubscriptionTrialPeriod = subscription.isSubscriptionTrialPeriod
                        subscriptionsList[index].categoryName = subscription.categoryName
                        subscriptionsList[index].subscriptionInformations = subscription.subscriptionInformations
                        subscriptionsList[index].selectionPaymentFrequency = subscription.selectionPaymentFrequency
                    }
                }
            }
            
            return ("Félicitation !" , subscription)
        }
    }
    
    private func validateDetails(of subscription: Subscription) -> String? {
        do {
            try subValidator.validate(subscription: subscription)
            return nil
        } catch {
            return error.localizedDescription
        }
    }
    
    private func validateFloatNumber(value: String) -> Bool {
        guard let floatValue = Float(value.replacingOccurrences(of: ",", with: ".")) else { return false }
        floatValuePrice = floatValue
        return true
    }
    
    func createSubscription(categoryVM: CategoryViewModel, categoryPickerSelection: String, subscriptionSelected: Subscription?, subscriptionPrice: String, subscriptionDuration: String, subscriptionCancellationNotice: String, subscriptionStartDate: Date, subscriptionIsCommited: Bool, subscriptionIsTrialPeriod: Bool, subscriptionTrialPeriodDuration: String, subscriptionInformation: String, selectionPaymentFrequency:String, subscriptionName: String?)->(String, Subscription?)
    {
        var message: (String, Subscription?) = ("", nil)
        let cat = Category()
        
        if let selectedCategory = categoryVM.getCategoryByUUID(uuid: categoryPickerSelection) {
            cat.categoryName = selectedCategory.categoryName
            cat.categoryImageName = selectedCategory.categoryName
        }
        
        if let mySubscription = subscriptionSelected {
            message = createSubscriptionObject(
                subscriptionImageName: mySubscription.subsrciptionImageName,
                subscriptionName: mySubscription.subscriptionName,
                subscriptionPrice: subscriptionPrice,
                subscriptionDuration: subscriptionDuration,
                subscriptionCancellationNotice: subscriptionCancellationNotice,
                subscriptionStartDate: subscriptionStartDate,
                subscriptionIsCommited: subscriptionIsCommited,
                subscriptionIsTrialPeriod: subscriptionIsTrialPeriod,
                subscriptionTrialPeriod: subscriptionTrialPeriodDuration,
                subscriptionCategoryName: mySubscription.categoryName!,
                subscriptionInformation: subscriptionInformation,
                subscriptionSelectionPayementFrequency: selectionPaymentFrequency,
                subscriptionObject: mySubscription
            )
        } else {
            message = createSubscriptionObject(
                subscriptionImageName: cat.categoryName,
                subscriptionName: subscriptionName ?? "",
                subscriptionPrice: subscriptionPrice,
                subscriptionDuration: subscriptionDuration,
                subscriptionCancellationNotice: subscriptionCancellationNotice,
                subscriptionStartDate: subscriptionStartDate,
                subscriptionIsCommited: subscriptionIsCommited,
                subscriptionIsTrialPeriod: subscriptionIsTrialPeriod,
                subscriptionTrialPeriod: subscriptionTrialPeriodDuration,
                subscriptionCategoryName: cat.categoryName,
                subscriptionInformation: subscriptionInformation,
                subscriptionSelectionPayementFrequency: selectionPaymentFrequency,
                subscriptionObject: nil
            )
        }
        
        return message
    }
    
    private func createSubscriptionObject(
        subscriptionImageName: String,
        subscriptionName: String,
        subscriptionPrice: String,
        subscriptionDuration: String,
        subscriptionCancellationNotice: String,
        subscriptionStartDate: Date,
        subscriptionIsCommited: Bool,
        subscriptionIsTrialPeriod: Bool,
        subscriptionTrialPeriod: String,
        subscriptionCategoryName: String,
        subscriptionInformation: String,
        subscriptionSelectionPayementFrequency: String,
        subscriptionObject: Subscription?)->(String, Subscription?)
    {
        guard validateFloatNumber(value: subscriptionPrice) else {
            return ("Erreur : Veuillez vérifier vos informations", nil)
        }
        
        if subscriptionObject == nil {
            let subscription = Subscription()
            
            subscription.subsrciptionImageName = subscriptionImageName
            subscription.subscriptionName = subscriptionName
            subscription.subscriptionPrice = floatValuePrice
            subscription.subscriptionDuration = Int(subscriptionDuration) ?? 0
            subscription.subscriptionCancellationNotice = Int(subscriptionCancellationNotice) ?? 0
            subscription.subscriptionStartDate = subscriptionStartDate
            subscription.isSubscriptionCommitted = subscriptionIsCommited
            subscription.isSubscriptionTrialPeriod = subscriptionIsTrialPeriod
            subscription.subscriptionTrialPeriodDuration = Int(subscriptionTrialPeriod) ?? 0
            subscription.categoryName = subscriptionCategoryName
            subscription.subscriptionInformations = subscriptionInformation
            subscription.selectionPaymentFrequency = subscriptionSelectionPayementFrequency
            
            if let message = validateDetails(of: subscription), !message.isEmpty {
                return (message, nil)
            } else {
                subscription.subscriptionRenewEndDate = subscription.subscriptionEndDate
                
                if !mySubscriptionsList.contains(where: { $0 == subscription}) {
                    mySubscriptionsList.append(subscription)
                    // AJOUT IMPORTANT : Ajouter l'abonnement à sa catégorie
                    categoryVM.addNewSubIntoCategoriesList(sub: subscription)
                }
                
                return ("Félicitation", subscription)
            }
            
        } else {
            // Mise à jour d'un abonnement existant
            subscriptionObject?.subsrciptionImageName = subscriptionImageName
            subscriptionObject?.subscriptionName = subscriptionName
            subscriptionObject?.subscriptionPrice = floatValuePrice
            subscriptionObject?.subscriptionDuration = Int(subscriptionDuration) ?? 00
            subscriptionObject?.subscriptionCancellationNotice = Int(subscriptionCancellationNotice) ?? 00
            subscriptionObject?.subscriptionStartDate = subscriptionStartDate
            subscriptionObject?.isSubscriptionCommitted = subscriptionIsCommited
            subscriptionObject?.isSubscriptionTrialPeriod = subscriptionIsTrialPeriod
            subscriptionObject?.subscriptionTrialPeriodDuration = Int(subscriptionTrialPeriod) ?? 00
            subscriptionObject?.categoryName = subscriptionCategoryName
            subscriptionObject?.subscriptionInformations = subscriptionInformation
            subscriptionObject?.selectionPaymentFrequency = subscriptionSelectionPayementFrequency
            
            if let message = validateDetails(of: subscriptionObject!), !message.isEmpty {
                return (message, nil)
            } else {
                subscriptionObject!.subscriptionRenewEndDate = subscriptionObject!.subscriptionEndDate
                
                // Mettre à jour l'abonnement existant dans mySubscriptionsList
                if let index = mySubscriptionsList.firstIndex(where: { $0.id == subscriptionObject!.id }) {
                    mySubscriptionsList[index] = subscriptionObject!
                    // AJOUT IMPORTANT : Mettre à jour l'abonnement dans sa catégorie
                    categoryVM.addNewSubIntoCategoriesList(sub: subscriptionObject!)
                } else {
                    // Si l'abonnement n'existe pas dans la liste, l'ajouter
                    mySubscriptionsList.append(subscriptionObject!)
                    categoryVM.addNewSubIntoCategoriesList(sub: subscriptionObject!)
                }
                
                return ("Félicitation", subscriptionObject)
            }
        }
    }
    
    func removeSubscription (_ subscription: Subscription) {
        mySubscriptionsList.removeAll { $0.id == subscription.id }
        // Notifier CategoryViewModel de la suppression
        categoryVM.removeSubscriptionFromCategory(subscription)
        // Forcer la mise à jour des observateurs
        objectWillChange.send()
    }
}
