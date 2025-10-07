//
//  SubSwayApp.swift
//  SubSway
//
//  Created by williams saadi on 27/03/2024.
//

import SwiftUI
import SwiftData

@main
struct SubSwayApp: App {
    var body: some Scene {
        WindowGroup {
            let categoryVM = CategoryViewModel()
            let subscriptionVM = SubscriptionViewModel(categoryVM: categoryVM)
            let contentVM = ContentViewModel(subscriptionVM: subscriptionVM, categoryVM: categoryVM)
            
            NavigationView{
                ContentView()
                    .environmentObject(contentVM)
                    .environmentObject(subscriptionVM)
                    .environmentObject(categoryVM)
                    .navigationTitle("Tableau de Bord")
            }
        }
        //.modelContainer(sharedModelContainer)
    }
}
