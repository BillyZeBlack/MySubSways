//
//  SubscriptionDetailsView.swift
//  SubSway
//
//  Created by williams saadi on 08/04/2024.
//

import SwiftUI

struct SubscriptionDetailsView: View {
    
    @State var subscriptionDetails: Subscription?
    
//    @StateObject var subscriptionVM: SubscriptionViewModel
//	@StateObject var categoryVM: CategoryViewModel
	@EnvironmentObject var subscriptionVM: SubscriptionViewModel
	@EnvironmentObject var categoryVM: CategoryViewModel
    
    @State var subscriptionCategoryName: [Category] = []
    @State var subscriptionName: String = ""
    @State var subscriptionPrice: String = ""
    @State var subscriptionStartDate: Date = Date()
    @State var subscriptionIsCommited: Bool = false
    @State var subscriptionDuration: String = ""
    @State var subscriptionIsTrialPeriod: Bool = false
    @State var subscriptionTrialPeriodDuration: String = ""
    @State var selectionPaymentFrequency: String = ""
    @State var subscriptionCancellationNotice: String = ""
    @State var isFormEditing: Bool = true
    @State var categoryPickerSelection: String = ""
    @State var subscriptionInformation: String = ""
    @State var selection: String = ""
    @State var alertMessage: String = ""
    @State var showAlert: Bool = false
//	@State var formState: FormState = .read
    
    var body: some View {
        VStack{
            HStack {
				Image(subscriptionDetails!.subscriptionName)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .cornerRadius(10)
            }
            Spacer()
            
            SubscriptionDetailsFormView(
                subscriptionCategoryName: $subscriptionCategoryName,
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
                categoryPickerSelection: $selection,
				subscriptionInformation: $subscriptionInformation, 
				subscriptionSelected: $subscriptionDetails//,
//				formState: $formState
			)
			.environmentObject(subscriptionVM)
			.environmentObject(categoryVM)
        }
        .navigationTitle("Mon abonnement")
    }
}

/*#Preview {
    SubscriptionDetailsView(
        subscriptionDetails: Subscription(),
        subscriptionVM: SubscriptionViewModel(),
        categoryVM: CategoryViewModel()
    )
}*/
