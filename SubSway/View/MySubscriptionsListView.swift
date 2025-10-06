//
//  MySubscriptionsListView.swift
//  SubSway
//
//  Created by williams saadi on 08/04/2024.
//

import SwiftUI

struct MySubscriptionsListView: View {
	@EnvironmentObject var categoryVM: CategoryViewModel
	@EnvironmentObject var subscriptionVM: SubscriptionViewModel
	
	var body: some View {
		List {
			ForEach(categoryVM.categories, id: \.id) { cat in
				let matchingSubscriptions = subscriptionVM.mySubscriptionsList.filter { 
					guard let subCategoryName = $0.categoryName else { return false }
					return subCategoryName == cat.categoryName 
				}
				if !matchingSubscriptions.isEmpty {
					Section(header: Text(cat.categoryName)) {
						ForEach(matchingSubscriptions, id: \.id) { sub in
							NavigationLink(destination: MySubscriptionInformationsView(mySubscription: sub)
								.environmentObject(subscriptionVM)
								.environmentObject(categoryVM)) {
									HStack {
										Image(sub.subsrciptionImageName)
											.resizable()
											.frame(width: 60, height: 50)
											.cornerRadius(10)
										Spacer()
										Text(sub.subscriptionName)
									}
								}
						}
						.onDelete { indexSet in
							deleteSubscription(at: indexSet, in: matchingSubscriptions)
						}
					}
				}
			}
		}
		.navigationTitle(Text("Mes abonnements"))
		.toolbar {
			EditButton()
		}
	}
	
	private func deleteSubscription(at offsets: IndexSet, in subscriptions: [Subscription]) {
			for index in offsets {
				let subscriptionToDelete = subscriptions[index]
				subscriptionVM.removeSubscription(subscriptionToDelete)
			}
		}
}

#Preview {
	MySubscriptionsListView()
}
