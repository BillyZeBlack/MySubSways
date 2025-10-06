//
//  CategoriesListView.swift
//  SubSway
//
//  Created by williams saadi on 30/03/2024.
//

import SwiftUI

struct CategoriesListView: View {
    @EnvironmentObject var subscriptionVM: SubscriptionViewModel
    @EnvironmentObject var categoryVM: CategoryViewModel
    
    var body: some View {
        List {
            /*ForEach(categoryVM.categories, id: \.id) { cat in
                Section(header: Text(cat.categoryName).font(.headline)) {
                    ForEach(cat.subscriptions, id: \.id) { sub in
//						NavigationLink(destination: SubscriptionDetailsView(subscriptionDetails: sub, subscriptionVM: subscriptionVM, categoryVM: categoryVM)
						NavigationLink(destination: SubscriptionDetailsView(subscriptionDetails: sub)
							.environmentObject(subscriptionVM)
							.environmentObject(categoryVM)
						){
                            HStack{
                                Image(sub.subsrciptionImageName)
                                    .resizable()
                                    .frame(width: 60, height: 50)
                                    .cornerRadius(10)
                                Spacer()
                                Text(sub.subscriptionName)
                            }
                        }
                    }
                }
            }*/
			ForEach( categoryVM.categories, id: \.id) { cat in
				Section(header: Text(cat.categoryName).font(.headline)) {
					ForEach(subscriptionVM.subscriptionsList, id: \.id) { sub in
						if(sub.categoryName == cat) {
							NavigationLink(destination: SubscriptionDetailsView(subscriptionDetails: sub)
								.environmentObject(subscriptionVM)
								.environmentObject(categoryVM)
							){
								HStack{
									Image(sub.subsrciptionImageName)
										.resizable()
										.frame(width: 60, height: 60)
										.cornerRadius(10)
									Spacer()
									Text(sub.subsrciptionImageName)
								}
							}
						}
					}
				}
			}
        }
        .navigationTitle(Text("Les abonnements"))
        .scrollContentBackground(.hidden)
		
//		List {
//			ForEach(categoryVM.categories, id: \.id) {
//				
//			}
//		}
    }
}

#Preview {
    CategoriesListView()
}
