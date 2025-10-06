//
//  ContentView.swift
//  SubSway
//
//  Created by williams saadi on 27/03/2024.
//

import SwiftUI
//import SwiftData

struct ContentView: View {
    @EnvironmentObject var subscriptionVM: SubscriptionViewModel
    @EnvironmentObject var categoryVM: CategoryViewModel

    var body: some View {
        VStack{
            HStack {
                if subscriptionVM.mySubscriptionsList.isEmpty {
                    Image(systemName: "list.bullet.circle")
                            .disabled(subscriptionVM.mySubscriptionsList.isEmpty)
                            .padding()
                } else {
                    NavigationLink(destination: MySubscriptionsListView()
                        .environmentObject(subscriptionVM)
                        .environmentObject(categoryVM)) {
                        Image(systemName: "list.bullet.circle")
                                .padding()
                    }
                }
                
                Spacer()
				
                NavigationLink(destination: CreateNewSubscriptionView(subscriptionName: "", subscriptionStartDate: Date())
                    .environmentObject(subscriptionVM)
                    .environmentObject(categoryVM)) {
                    Image(systemName: "plus.circle")
                        .padding()
                }
            }
            CategoriesListView()
                .environmentObject(subscriptionVM)
                .environmentObject(categoryVM)
        }
        /*NavigationSplitView {
         List {
         ForEach(items) { item in
         NavigationLink {
         Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
         } label: {
         Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
         }
         }
         .onDelete(perform: deleteItems)
         }
         .toolbar {
         ToolbarItem(placement: .navigationBarTrailing) {
         EditButton()
         }
         ToolbarItem {
         Button(action: addItem) {
         Label("Add Item", systemImage: "plus")
         }
         }
         }
         } detail: {
         Text("Select an item")
         }
         }
         
         private func addItem() {
         withAnimation {
         let newItem = Item(timestamp: Date())
         modelContext.insert(newItem)
         }
         }
         
         private func deleteItems(offsets: IndexSet) {
         withAnimation {
         for index in offsets {
         modelContext.delete(items[index])
         }
         }
         }*/
    }
}

#Preview {
    ContentView()
        //.modelContainer(for: Item.self, inMemory: true)
}
