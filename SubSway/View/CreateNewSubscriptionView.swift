//
//  CreateNewSubscriptionView.swift
//  SubSway
//
//  Created by williams saadi on 30/03/2024.
//

import SwiftUI

struct CreateNewSubscriptionView: View {
	@EnvironmentObject var categoryVM: CategoryViewModel
	@EnvironmentObject var subscriptionVM: SubscriptionViewModel
	
	@State var subscriptionCategoryName: String = ""
	@State var subscriptionName: String = ""
	@State var subscriptionPrice: String = ""
	@State var subscriptionStartDate: Date = Date()
	@State var subscriptionIsCommited: Bool = false
	@State var subscriptionDuration: String = ""
	@State var subscriptionIsTrialPeriod: Bool = false
	@State var subscriptionTrialPeriodDuration: String = ""
	@State var selectionPaymentFrequency: String = "Mois"
	@State var subscriptionCancellationNotice: String = ""
	@State var subscriptionInformation: String = ""
	@State var alertMessage = ""
	@State var showAlert = false
	@State var categoryPickerSelection: String = ""
	@State var isFormEditing: Bool = true
	@State var subscriptionWithNilValue: Subscription?
//	@State var formState: FormState = .create
	
	var body: some View {
		VStack {
			SubscriptionDetailsFormView(
				subscriptionCategoryName: $categoryVM.categories,
				subscriptionName: $subscriptionName,
				subscriptionPrice: $subscriptionPrice,
				subscriptionStartDate: $subscriptionStartDate,
				subscriptionIsCommited: $subscriptionIsCommited,
				subscriptionDuration: $subscriptionDuration,
				subscriptionIsTrialPeriod: $subscriptionIsTrialPeriod,
				subscriptionTrialPeriodDuration: $subscriptionTrialPeriodDuration,
				selectionPaymentFrequency: $selectionPaymentFrequency,
				subscriptionCancellationNotice: $subscriptionCancellationNotice,
				isFormEditing: $isFormEditing,
				categoryPickerSelection: $categoryPickerSelection,
				subscriptionInformation: $subscriptionInformation,
				subscriptionSelected: $subscriptionWithNilValue
//				formState: $formState
			)
		}
		.navigationTitle("Nouvel abonnement")
		Spacer()
	}
}

#Preview {
	CreateNewSubscriptionView()
}
