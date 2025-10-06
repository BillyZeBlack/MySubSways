//
//  SubscriptionDetailsFormView.swift
//  SubSway
//
//  Created by williams saadi on 03/04/2024.
//

import SwiftUI
import Combine

struct SubscriptionDetailsFormView: View {
	
	@EnvironmentObject var categoryVM: CategoryViewModel
	@EnvironmentObject var subscriptionVM: SubscriptionViewModel
	
	@Binding var subscriptionCategoryName: [Category]
	@Binding var subscriptionName: String
	@Binding var subscriptionPrice: String
	@Binding var subscriptionStartDate: Date
	@Binding var subscriptionIsCommited: Bool
	@Binding var subscriptionDuration: String
	@Binding var subscriptionIsTrialPeriod: Bool
	@Binding var subscriptionTrialPeriodDuration: String
	@Binding var selectionPaymentFrequency: String
	@Binding var subscriptionCancellationNotice: String
	@Binding var isFormEditing: Bool
	@Binding var categoryPickerSelection: String
	@Binding var subscriptionInformation: String
	@Binding var subscriptionSelected: Subscription?
//	@Binding var formState: FormState
	
	@State var alertMessage: String = ""
	@State var showAlert = false
	
	
	var body: some View {
		VStack {
			Form {
				Section(header: Text("Informations principales")) {
					if subscriptionSelected == nil {
						Picker(
							selection: $categoryPickerSelection,
							label: Text("Catégories"),
							content: {
								ForEach(subscriptionCategoryName, id: \.id) { category in
									Text(category.categoryName)
										.tag("\(category.id)")
								}
							}
						)
						.pickerStyle(.menu)
						
					} else {
						Text("Catégorie : \(subscriptionSelected?.categoryName ?? "")")
					}
					
					VStack {
						HStack {
							Text("Nom ")
							Spacer()
							TextField(subscriptionSelected?.subscriptionName ?? "ex : Mon abonnement poterie", text: $subscriptionName)
						}
						HStack {
							TextField("Prix de l'abonnement", text: $subscriptionPrice)
								.disabled(!isFormEditing)
								.keyboardType(.decimalPad)
							/* ceci empêche la saisie d'une valeur non numérique*/
								.onReceive(Just(subscriptionPrice), perform: { newPrice in
									var filtered = newPrice.filter { ",.0123456789".contains($0) }
									
									// Compte le nombre de séparateurs décimaux
									let decimalCount = filtered.filter { $0 == "," || $0 == "." }.count
									
									// S'il y a plus d'un séparateur décimal, réduisez à un seul
									if decimalCount > 1 {
										var hasFoundDecimal = false
										filtered = filtered.reduce(into: "") { (result, char) in
											if char == "," || char == "." {
												if !hasFoundDecimal {
													result.append(char) // Ajoute le premier séparateur décimal trouvé
													hasFoundDecimal = true
												}
												// Ignore les séparateurs décimaux supplémentaires
											} else {
												result.append(char) // Ajoute les autres caractères normalement
											}
										}
									}
									
									if filtered != newPrice {
										self.subscriptionPrice = filtered
									}
								}).toolbar{
									ToolbarItemGroup(placement: .keyboard) {
										Spacer()
										Button("Ok"){
											hideKeyboard()
										}
									}
								}
							
							Spacer()
							
							if let regionCode = Locale.current.regionCode, regionCode.caseInsensitiveCompare("FR") == .orderedSame {
								Image(systemName: "eurosign")
							} else {
								Image(systemName: "dollarsign")
							}
						}
					}
					
					DatePicker("Date de début", selection: $subscriptionStartDate, displayedComponents:  .date)
						.environment(\.locale, Locale(identifier: Locale.current.regionCode ?? "FR"))
					
					if !subscriptionIsTrialPeriod {
						Toggle(isOn: $subscriptionIsCommited) {
							Text("Avec engagement")
						}
					}
					
					if subscriptionIsCommited && !subscriptionIsTrialPeriod {
						HStack {
							TextField("Durée de l'engagement", text: $subscriptionDuration)
								.keyboardType(.numberPad)
								.onReceive(Just(subscriptionDuration), perform: { newPrice in
									let filtered = newPrice.filter {"0123456789".contains($0)}
									if filtered != newPrice {
										self.subscriptionDuration = filtered
									}
								})
								.disabled(subscriptionIsTrialPeriod)
							Text("mois")
						}
					}
					
					if !subscriptionIsCommited {
						Toggle(isOn: $subscriptionIsTrialPeriod) {
							Text("Période d'essaie")
						}
					}
					
					if !subscriptionIsCommited && subscriptionIsTrialPeriod {
						HStack {
							TextField("Durée de la période d'essaie", text: $subscriptionTrialPeriodDuration)
								.keyboardType(.numberPad)
								.onReceive(Just(subscriptionTrialPeriodDuration), perform: { newPrice in
									let filtered = newPrice.filter {"0123456789".contains($0)}
									if filtered != newPrice {
										self.subscriptionTrialPeriodDuration = filtered
									}
								})
							Text("mois")
						}
					}
				}
				
				Section(header: Text("Fréquence de paiement")) {
					Picker("PaimentFrequency", selection: $selectionPaymentFrequency) {
						ForEach([
							"Mensuelle",
							"Trimestrielle",
							"Annuelle"
						], id: \.self) { sel in
							Text(sel)
						}
					}
					.pickerStyle(.segmented)
				}
				
				Section (header: Text("Préavis de résiliation")){
					Picker("Alert", selection: $subscriptionCancellationNotice) {
						ForEach(["0", "1", "2", "3"], id: \.self) { selAlert in
							Text(selAlert)
						}
					}
					.pickerStyle(.segmented)
				}
				
				Section(header: Text("Details")) {
					TextField("Informations supplémentaires", text: $subscriptionInformation)
						.keyboardType(.default)
				}
				
				Section {
					Button{
						if isFormEditing {
							createSubscription()
						}
					} label: {
						Text("Valider")
					}
					.frame(maxWidth: .infinity, alignment: .center)
					.alert(isPresented: $showAlert) {
						Alert(
							title: Text("Information"),
							message: Text("\(alertMessage)"),
							dismissButton: .default(Text("OK"))
						)
					}
					.padding(.bottom, 250)
				}
				
			}.scrollContentBackground(.hidden)
		}
	}
	
	
	private func createSubscription()
	{
		var message = subscriptionVM.createSubscription(categoryVM: categoryVM, categoryPickerSelection: categoryPickerSelection, subscriptionSelected: subscriptionSelected, subscriptionPrice: subscriptionPrice, subscriptionDuration: subscriptionDuration, subscriptionCancellationNotice: subscriptionCancellationNotice, subscriptionStartDate: subscriptionStartDate, subscriptionIsCommited: subscriptionIsCommited, subscriptionIsTrialPeriod: subscriptionIsTrialPeriod, subscriptionTrialPeriodDuration: subscriptionTrialPeriodDuration, subscriptionInformation: subscriptionInformation, selectionPaymentFrequency: selectionPaymentFrequency, subscriptionName: subscriptionName)
		
		if !message.0.contains("Erreur") {
			alertMessage = "\(message.0)\n Votre abonnement a bien été ajouté à votre liste."
		} else {
			alertMessage = "\(message.0)\n Votre abonnement n'a pas été créé."
		}
		
		showAlert = true
	}
}

/*#Preview {
    SubscriptionDetailsFormView()
}*/

extension SubscriptionDetailsFormView {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}
