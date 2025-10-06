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
            let subscriptionVM = SubscriptionViewModel()
            let categoryVM = CategoryViewModel()
            NavigationView{
                ContentView()
                    .navigationTitle("Titre")
                    .environmentObject(subscriptionVM)
                    .environmentObject(categoryVM)
            }
        }
        //.modelContainer(sharedModelContainer)
    }
}
