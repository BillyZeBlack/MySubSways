//
//  MySubscriptionInformationsView.swift
//  SubSway
//
//  Created by williams saadi on 08/04/2024.
//

import SwiftUI
import Combine

struct MySubscriptionInformationsView: View {
	
	@EnvironmentObject var categoryVM: CategoryViewModel
	@EnvironmentObject var subscriptionVM: SubscriptionViewModel
	
	@State var mySubscription: Subscription = Subscription()
	@State var isEditing: Bool = false
//	@State var formState: FormState = .update
	
	var body: some View {
		VStack {
			HStack {
				Text(mySubscription.subscriptionName).font(.title3)
				
				Spacer()
				
				Button {
					isEditing.toggle()
				} label: {
					if isEditing {
						Label("Annuler", systemImage: "pencil.slash")
					} else {
						Label("Modifier", systemImage: "pencil")
					}
				}
				
				Button(role: .destructive) {
					subscriptionVM.removeSubscription(mySubscription)
				} label: {
					Label("Supprimer", systemImage: "trash")
				}
			}.padding()
			
			if isEditing{
				SubscriptionDetailsFormView(
					subscriptionCategoryName:
						Binding(get: {
							categoryVM.categories
						}, set: { _ in }),
					subscriptionName:
						Binding(get: {
							mySubscription.subscriptionName
						}, set: { newValue in
							mySubscription.subscriptionName = newValue
						}),
					subscriptionPrice:
						Binding(get: {
							String(mySubscription.subscriptionPrice)
						}, set: { newValue in
							if let floatValue = Float(newValue) {
								mySubscription.subscriptionPrice = floatValue
							}
						}),
					subscriptionStartDate:
						Binding(get: {
							mySubscription.subscriptionStartDate
						}, set: { _ in }),
					subscriptionIsCommited:
						Binding(
							get: { mySubscription.isSubscriptionCommitted },
							set: { newValue in
								mySubscription.isSubscriptionCommitted = newValue
							}
						),
					subscriptionDuration:
						Binding(get: {
							String(mySubscription.subscriptionDuration)
						}, set: { newValue in
							if let intValue = Int(newValue) {
								mySubscription.subscriptionDuration = intValue
							}
						}),
					subscriptionIsTrialPeriod:
						Binding(get: {
							mySubscription.isSubscriptionTrialPeriod
						}, set: { newValue in
							mySubscription.isSubscriptionTrialPeriod = newValue
						}),
					subscriptionTrialPeriodDuration:
						Binding(get: {
							String(mySubscription.subscriptionTrialPeriodDuration)
						}, set: { newValue in
							if let intValue = Int(newValue) {
								mySubscription.subscriptionTrialPeriodDuration = intValue
							}
						}
							   ),
					selectionPaymentFrequency:
						Binding(
							get: { mySubscription.selectionPaymentFrequency },
							set: { newValue in
								mySubscription.selectionPaymentFrequency = newValue
							}
						),
					subscriptionCancellationNotice:
						Binding(
							get: {
								String(mySubscription.subscriptionCancellationNotice)
							},
							set: { newValue in
								if let intValue = Int(newValue) {
									mySubscription.subscriptionCancellationNotice = intValue
								}
							}
						),
					isFormEditing:
						Binding(get: {
							isEditing
						}, set: { _ in }),
					categoryPickerSelection:
						Binding(get: {
							String(mySubscription.categoryName!)
						}, set: { _ in }),
					subscriptionInformation:
						Binding(get: {
							mySubscription.subscriptionInformations
						}, set: { newValue in
							mySubscription.subscriptionInformations = newValue
						}),
					subscriptionSelected:
						Binding(get: {
							mySubscription
						}, set: { _ in })//,
//					formState: Binding(get: {
//						formState
//					}, set: { _ in})
				)
			} else {
				Form {
					VStack{
						HStack {
							Text("Catégories")
							Spacer()
							Text(mySubscription.categoryName!)
						}
						
						Spacer()
						
						HStack{
							Text("Prix")
							Spacer()
							Text(String(format: "%.2f", mySubscription.subscriptionPrice))
						}
						
						HStack {
							Text("Date de début")
							Spacer()
							Text("\(mySubscription.subscriptionStartDate.displayFormat)")
						}
						
						Spacer()
						
						HStack {
							Text("Date de fin")
							Spacer()
							Text("\(mySubscription.subscriptionEndDate.displayFormat)")
						}
						
						Spacer()
						
						HStack {
							Text("Avec engagement")
							Spacer()
							Text(mySubscription.isSubscriptionCommitted ? "\(mySubscription.subscriptionDuration) mois" : "Non")
						}
						
						Spacer()
						
						HStack {
							Text("Période d'essaie")
							Spacer()
							Text(mySubscription.isSubscriptionTrialPeriod ? "\(mySubscription.subscriptionTrialPeriodDuration) mois" : "Non")
						}
						
						Spacer()
						
						HStack {
							Text("Fréquence de paiement")
							Spacer()
							Text(!mySubscription.selectionPaymentFrequency.isEmpty ? mySubscription.selectionPaymentFrequency : "Mois")
						}
						
						Spacer()
						
						HStack {
							Text("Préavis de résiliation")
							Spacer()
							Text(mySubscription.subscriptionCancellationNotice != 0 ? "\(mySubscription.subscriptionCancellationNotice)" : "0")
						}
					}
					
				}
			}
		}
	}
	
	func checkDateEnd(sub: Subscription) -> Bool {
		let subDate = sub.subscriptionStartDate
		let now = Date()
		let calendar = Calendar.current
		let subDateAtMidnight = calendar.startOfDay(for: subDate)
		let todatAtMidnight =  calendar.startOfDay(for: now)
		
		if todatAtMidnight > subDateAtMidnight {
			// On change la date
		} else {
			// On ne change rien
		}
		return true
	}
}

#Preview {
	MySubscriptionInformationsView()
}

extension Date {
	var displayFormat: String {
		let formatter = DateFormatter()
		formatter.dateStyle = .long
		formatter.timeStyle = .none
		
		if let regionCode = Locale.current.regionCode, regionCode.caseInsensitiveCompare("FR") == .orderedSame {
			formatter.locale = Locale(identifier: "fr_FR")
		} else {
			formatter.locale = Locale(identifier: "en_US")
		}
		
		return formatter.string(from: self)
	}
}
