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
	//private var categoryVM: CategoryViewModel
	
	@Published var mySubscriptionsList : [Subscription] = []
	@Published var subscriptionsList: [Subscription] = []
	
	//	let container: NSPersistentContainer
	
	var subValidator = SubscriptionValidator()
	var floatValuePrice : Float = 0
	
	init(categoryVM: CategoryViewModel) {
//		self.categoryVM = categoryVM
//		populateSubscriptionList()
		
		if !mySubscriptionsList.isEmpty {
			for subscription in mySubscriptionsList {
				if subscription.subscriptionRenewEndDate < Date() {
					subscription.subscriptionRenewEndDate = subscription.subscriptionEndDate
				}
			}
		}
	}
	
//	private func populateSubscriptionList()
//	{
//		subscriptionsList = [
//			Subscription(
//				subscriptionName: "EDF",
//				subscriptionPrice: 0,
//				subsrciptionImageName: UIImage(named: "EDF") != nil ? "EDF" : "Fournisseur d'énergie",
//				subscriptionDuration: 0,
//				subscriptionCancellationNotice: 0,
//				subscriptionStartDate: Date(),
//				subscriptionRenewEndDate: Date(),
//				selectionPaymentFrequency: "",
//				isSubscriptionCommitted: false,
//				subscriptionTrialPeriod: 0,
//				isSubscriptionTrialPeriod: false,
//				categoryLabel: categoryVM.categories[0],
//				subscriptionInformations: ""
//			),
//			Subscription(
//				subscriptionName: "ENGIE",
//				subscriptionPrice: 0,
//				subsrciptionImageName: UIImage(named: "ENGIE") != nil ? "ENGIE" : "Fournisseur d'énergie",
//				subscriptionDuration: 0,
//				subscriptionCancellationNotice: 0,
//				subscriptionStartDate: Date(),
//				subscriptionRenewEndDate: Date(),
//				selectionPaymentFrequency: "",
//				isSubscriptionCommitted: false,
//				subscriptionTrialPeriod: 0,
//				isSubscriptionTrialPeriod: false,
//				categoryLabel: categoryVM.categories[0],
//				subscriptionInformations: ""
//			),
//			Subscription(
//				subscriptionName: "SFR",
//				subscriptionPrice: 0,
//				subsrciptionImageName: UIImage(named: "SFR") != nil ? "SFR" : "Fournisseur Internet",
//				subscriptionDuration: 0,
//				subscriptionCancellationNotice: 0,
//				subscriptionStartDate: Date(),
//				subscriptionRenewEndDate: Date(),
//				selectionPaymentFrequency: "",
//				isSubscriptionCommitted: false,
//				subscriptionTrialPeriod: 0,
//				isSubscriptionTrialPeriod: false,
//				categoryLabel: categoryVM.categories[1],
//				subscriptionInformations: ""
//			),
//			Subscription(
//				subscriptionName: "Free",
//				subscriptionPrice: 0,
//				subsrciptionImageName: UIImage(named: "Free") != nil ? "Free" : "Fournisseur Internet",
//				subscriptionDuration: 0,
//				subscriptionCancellationNotice: 0,
//				subscriptionStartDate: Date(),
//				subscriptionRenewEndDate: Date(),
//				selectionPaymentFrequency: "",
//				isSubscriptionCommitted: false,
//				subscriptionTrialPeriod: 0,
//				isSubscriptionTrialPeriod: false,
//				categoryLabel: categoryVM.categories[1],
//				subscriptionInformations: ""
//			),
//			Subscription(
//				subscriptionName: "BOUYGUES",
//				subscriptionPrice: 0,
//				subsrciptionImageName: UIImage(named: "BOUYGUES") != nil ? "BOUYGUES" : "Fournisseur Internet",
//				subscriptionDuration: 0,
//				subscriptionCancellationNotice: 0,
//				subscriptionStartDate: Date(),
//				subscriptionRenewEndDate: Date(),
//				selectionPaymentFrequency: "",
//				isSubscriptionCommitted: false,
//				subscriptionTrialPeriod: 0,
//				isSubscriptionTrialPeriod: false,
//				categoryLabel: categoryVM.categories[1],
//				subscriptionInformations: ""
//			),
//			Subscription(
//				subscriptionName: "ORANGE",
//				subscriptionPrice: 0,
//				subsrciptionImageName: UIImage(named: "ORANGE") != nil ? "ORANGE" : "Fournisseur Internet",
//				subscriptionDuration: 0,
//				subscriptionCancellationNotice: 0,
//				subscriptionStartDate: Date(),
//				subscriptionRenewEndDate: Date(),
//				selectionPaymentFrequency: "",
//				isSubscriptionCommitted: false,
//				subscriptionTrialPeriod: 0,
//				isSubscriptionTrialPeriod: false,
//				categoryLabel: categoryVM.categories[1],
//				subscriptionInformations: ""
//			),
//			Subscription(
//				subscriptionName: "Netflix",
//				subscriptionPrice: 0,
//				subsrciptionImageName: UIImage(named: "Netflix") != nil ? "Netflix" : "Streaming vidéo",
//				subscriptionDuration: 0,
//				subscriptionCancellationNotice: 0,
//				subscriptionStartDate: Date(),
//				subscriptionRenewEndDate: Date(),
//				selectionPaymentFrequency: "",
//				isSubscriptionCommitted: false,
//				subscriptionTrialPeriod: 0,
//				isSubscriptionTrialPeriod: false,
//				categoryLabel: categoryVM.categories[2],
//				subscriptionInformations: ""
//			),
//			Subscription(
//				subscriptionName: "Amazon Prime",
//				subscriptionPrice: 0,
//				subsrciptionImageName: UIImage(named: "Amazon Prime") != nil ? "Amazon Prime" : "Streaming vidéo",
//				subscriptionDuration: 0,
//				subscriptionCancellationNotice: 0,
//				subscriptionStartDate: Date(),
//				subscriptionRenewEndDate: Date(),
//				selectionPaymentFrequency: "",
//				isSubscriptionCommitted: false,
//				subscriptionTrialPeriod: 0,
//				isSubscriptionTrialPeriod: false,
//				categoryLabel: categoryVM.categories[2],
//				subscriptionInformations: ""
//			),
//			Subscription(
//				subscriptionName: "Disney Plus",
//				subscriptionPrice: 0,
//				subsrciptionImageName: UIImage(named: "Disney Plus") != nil ? "Disney Plus" : "Streaming vidéo",
//				subscriptionDuration: 0,
//				subscriptionCancellationNotice: 0,
//				subscriptionStartDate: Date(),
//				subscriptionRenewEndDate: Date(),
//				selectionPaymentFrequency: "",
//				isSubscriptionCommitted: false,
//				subscriptionTrialPeriod: 0,
//				isSubscriptionTrialPeriod: false,
//				categoryLabel: categoryVM.categories[2],
//				subscriptionInformations: ""
//			),
//			Subscription(
//				subscriptionName: "Deezer",
//				subscriptionPrice: 0,
//				subsrciptionImageName: UIImage(named: "Deezer") != nil ? "Deezer" : "Streaming Musical",
//				subscriptionDuration: 0,
//				subscriptionCancellationNotice: 0,
//				subscriptionStartDate: Date(),
//				subscriptionRenewEndDate: Date(),
//				selectionPaymentFrequency: "",
//				isSubscriptionCommitted: false,
//				subscriptionTrialPeriod: 0,
//				isSubscriptionTrialPeriod: false,
//				categoryLabel: categoryVM.categories[3],
//				subscriptionInformations: ""
//			),
//			Subscription(
//				subscriptionName: "Spotify",
//				subscriptionPrice: 0,
//				subsrciptionImageName: UIImage(named: "Spotify") != nil ? "Spotify" : "Streaming Musical",
//				subscriptionDuration: 0,
//				subscriptionCancellationNotice: 0,
//				subscriptionStartDate: Date(),
//				subscriptionRenewEndDate: Date(),
//				selectionPaymentFrequency: "",
//				isSubscriptionCommitted: false,
//				subscriptionTrialPeriod: 0,
//				isSubscriptionTrialPeriod: false,
//				categoryLabel: categoryVM.categories[3],
//				subscriptionInformations: ""
//			),
//			Subscription(
//				subscriptionName: "Free Mobile",
//				subscriptionPrice: 0,
//				subsrciptionImageName: UIImage(named: "Free Mobile") != nil ? "Free Mobile" : "Téléphonie Mobile",
//				subscriptionDuration: 0,
//				subscriptionCancellationNotice: 0,
//				subscriptionStartDate: Date(),
//				subscriptionRenewEndDate: Date(),
//				selectionPaymentFrequency: "",
//				isSubscriptionCommitted: false,
//				subscriptionTrialPeriod: 0,
//				isSubscriptionTrialPeriod: false,
//				categoryLabel: categoryVM.categories[4],
//				subscriptionInformations: ""
//			),
//			Subscription(
//				subscriptionName: "SFR",
//				subscriptionPrice: 0,
//				subsrciptionImageName: UIImage(named: "SFR") != nil ? "SFR" : "Téléphonie Mobile",
//				subscriptionDuration: 0,
//				subscriptionCancellationNotice: 0,
//				subscriptionStartDate: Date(),
//				subscriptionRenewEndDate: Date(),
//				selectionPaymentFrequency: "",
//				isSubscriptionCommitted: false,
//				subscriptionTrialPeriod: 0,
//				isSubscriptionTrialPeriod: false,
//				categoryLabel: categoryVM.categories[4],
//				subscriptionInformations: ""
//			),
//			Subscription(
//				subscriptionName: "Bouygues Télécom",
//				subscriptionPrice: 0,
//				subsrciptionImageName: UIImage(named: "Bouygues Télécom") != nil ? "Bouygues Télécom" : "Téléphonie Mobile",
//				subscriptionDuration: 0,
//				subscriptionCancellationNotice: 0,
//				subscriptionStartDate: Date(),
//				subscriptionRenewEndDate: Date(),
//				selectionPaymentFrequency: "",
//				isSubscriptionCommitted: false,
//				subscriptionTrialPeriod: 0,
//				isSubscriptionTrialPeriod: false,
//				categoryLabel: categoryVM.categories[4],
//				subscriptionInformations: ""
//			),
//			Subscription(
//				subscriptionName: "Orange",
//				subscriptionPrice: 0,
//				subsrciptionImageName: UIImage(named: "Orange") != nil ? "Orange" : "Téléphonie Mobile",
//				subscriptionDuration: 0,
//				subscriptionCancellationNotice: 0,
//				subscriptionStartDate: Date(),
//				subscriptionRenewEndDate: Date(),
//				selectionPaymentFrequency: "",
//				isSubscriptionCommitted: false,
//				subscriptionTrialPeriod: 0,
//				isSubscriptionTrialPeriod: false,
//				categoryLabel: categoryVM.categories[4],
//				subscriptionInformations: ""
//			),
//			Subscription(
//				subscriptionName: "Canal Plus",
//				subscriptionPrice: 0,
//				subsrciptionImageName: UIImage(named: "Canal Plus") != nil ? "Canal Plus" : "Chaine TV",
//				subscriptionDuration: 0,
//				subscriptionCancellationNotice: 0,
//				subscriptionStartDate: Date(),
//				subscriptionRenewEndDate: Date(),
//				selectionPaymentFrequency: "",
//				isSubscriptionCommitted: false,
//				subscriptionTrialPeriod: 0,
//				isSubscriptionTrialPeriod: false,
//				categoryLabel: categoryVM.categories[5],
//				subscriptionInformations: ""
//			),
//			Subscription(
//				subscriptionName: "Groupama",
//				subscriptionPrice: 0,
//				subsrciptionImageName: UIImage(named: "Groupama") != nil ? "Groupama" : "Assurance",
//				subscriptionDuration: 0,
//				subscriptionCancellationNotice: 0,
//				subscriptionStartDate: Date(),
//				subscriptionRenewEndDate: Date(),
//				selectionPaymentFrequency: "",
//				isSubscriptionCommitted: false,
//				subscriptionTrialPeriod: 0,
//				isSubscriptionTrialPeriod: false,
//				categoryLabel: categoryVM.categories[6],
//				subscriptionInformations: ""
//			),
//			Subscription(
//				subscriptionName: "Axa Assurances",
//				subscriptionPrice: 0,
//				subsrciptionImageName: UIImage(named: "Axa") != nil ? "Axa" : "Assurance",
//				subscriptionDuration: 0,
//				subscriptionCancellationNotice: 0,
//				subscriptionStartDate: Date(),
//				subscriptionRenewEndDate: Date(),
//				selectionPaymentFrequency: "",
//				isSubscriptionCommitted: false,
//				subscriptionTrialPeriod: 0,
//				isSubscriptionTrialPeriod: false,
//				categoryLabel: categoryVM.categories[6],
//				subscriptionInformations: ""
//			),
//			Subscription(
//				subscriptionName: "Direct Assurrnces",
//				subscriptionPrice: 0,
//				subsrciptionImageName: UIImage(named: "Direct Assurances") != nil ? "Direct Assurances" : "Assurance",
//				subscriptionDuration: 0,
//				subscriptionCancellationNotice: 0,
//				subscriptionStartDate: Date(),
//				subscriptionRenewEndDate: Date(),
//				selectionPaymentFrequency: "",
//				isSubscriptionCommitted: false,
//				subscriptionTrialPeriod: 0,
//				isSubscriptionTrialPeriod: false,
//				categoryLabel: categoryVM.categories[6],
//				subscriptionInformations: ""
//			),
//			Subscription(
//				subscriptionName: "Active Assurances",
//				subscriptionPrice: 0,
//				subsrciptionImageName: UIImage(named: "Active Assurances") != nil ? "Active Assurances" : "Assurance",
//				subscriptionDuration: 0,
//				subscriptionCancellationNotice: 0,
//				subscriptionStartDate: Date(),
//				subscriptionRenewEndDate: Date(),
//				selectionPaymentFrequency: "",
//				isSubscriptionCommitted: false,
//				subscriptionTrialPeriod: 0,
//				isSubscriptionTrialPeriod: false,
//				categoryLabel: categoryVM.categories[6],
//				subscriptionInformations: ""
//			),
//			Subscription(
//				subscriptionName: "Fitness Park",
//				subscriptionPrice: 0,
//				subsrciptionImageName: UIImage(named: "Fitness Park") != nil ? "Fitness Park" : "Sport",
//				subscriptionDuration: 0,
//				subscriptionCancellationNotice: 0,
//				subscriptionStartDate: Date(),
//				subscriptionRenewEndDate: Date(),
//				selectionPaymentFrequency: "",
//				isSubscriptionCommitted: false,
//				subscriptionTrialPeriod: 0,
//				isSubscriptionTrialPeriod: false,
//				categoryLabel: categoryVM.categories[7],
//				subscriptionInformations: ""
//			),
//			Subscription(
//				subscriptionName: "Vita Liberté",
//				subscriptionPrice: 0,
//				subsrciptionImageName: UIImage(named: "Vita Liberté") != nil ? "Vita Liberté" : "Sport",
//				subscriptionDuration: 0,
//				subscriptionCancellationNotice: 0,
//				subscriptionStartDate: Date(),
//				subscriptionRenewEndDate: Date(),
//				selectionPaymentFrequency: "",
//				isSubscriptionCommitted: false,
//				subscriptionTrialPeriod: 0,
//				isSubscriptionTrialPeriod: false,
//				categoryLabel: categoryVM.categories[7],
//				subscriptionInformations: ""
//			)
//		]
//	}
	
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
				subscriptionCategoryName: cat,
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
			subscription.categoryName = subscriptionCategoryName.categoryName.isEmpty ? categoryVM.categories[0] : subscriptionCategoryName
			subscription.subscriptionInformations = subscriptionInformation
			subscription.selectionPaymentFrequency = subscriptionSelectionPayementFrequency
			
			if let message = validateDetails(of: subscription), !message.isEmpty {
				return (message, nil)
			} else {
				subscription.subscriptionRenewEndDate = subscription.subscriptionEndDate
				
				if !mySubscriptionsList.contains(where: { $0 == subscription}) {
					mySubscriptionsList.append(subscription)
				}
				
				return ("Félicitation", subscription)
			}
			
		} else {
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
				if !mySubscriptionsList.contains(where: { $0 == subscriptionObject}) {
					mySubscriptionsList.append(subscriptionObject!)
				}
				
				return ("Félicitation", subscriptionObject)
			}
		}
	}
	
	func removeSubscription (_ subscription: Subscription) {
		mySubscriptionsList.removeAll { $0.id == subscription.id }
	}
}
