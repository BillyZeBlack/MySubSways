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
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Header avec statistiques
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Mes Abonnements")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        HStack(spacing: 16) {
                            StatCard(
                                title: "Total",
                                value: "\(subscriptionVM.mySubscriptionsList.count)",
                                icon: "creditcard.fill",
                                color: .blue
                            )
                            
                            StatCard(
                                title: "Mensuel",
                                value: String(format: "%.2f€", totalMonthlyCost()),
                                icon: "eurosign.circle.fill",
                                color: .green
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // Actions rapides
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Actions Rapides")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 16) {
                            NavigationLink(destination: CreateNewSubscriptionView(
                                subscriptionName: "",
                                subscriptionStartDate: Date()
                            )
                            .environmentObject(subscriptionVM)
                            .environmentObject(categoryVM)) {
                                QuickActionButton(
                                    title: "Ajouter",
                                    icon: "plus.circle.fill",
                                    color: .blue
                                )
                            }
                            
                            NavigationLink(destination: MySubscriptionsListView()
                                .environmentObject(subscriptionVM)
                                .environmentObject(categoryVM)) {
                                QuickActionButton(
                                    title: "Mes Abonnements",
                                    icon: "list.bullet.circle.fill",
                                    color: .orange,
                                    isDisabled: subscriptionVM.mySubscriptionsList.isEmpty
                                )
                            }
                            .disabled(subscriptionVM.mySubscriptionsList.isEmpty)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Catégories
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Catégories")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            NavigationLink("Voir tout", destination: CategoriesListView()
                                .environmentObject(subscriptionVM)
                                .environmentObject(categoryVM))
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            ForEach(Array(categoryVM.categories.prefix(4)), id: \.id) { category in
                                CategoryCard(category: category)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Abonnements récents (si disponibles)
                    if !subscriptionVM.mySubscriptionsList.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Derniers Abonnements")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                
                                Spacer()
                                
                                NavigationLink("Voir tout", destination: MySubscriptionsListView()
                                    .environmentObject(subscriptionVM)
                                    .environmentObject(categoryVM))
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                            
                            LazyVStack(spacing: 12) {
                                ForEach(Array(subscriptionVM.mySubscriptionsList.prefix(3)), id: \.id) { subscription in
                                    SubscriptionRow(subscription: subscription)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGroupedBackground))
        }
    }
    
    private func totalMonthlyCost() -> Float {
        subscriptionVM.mySubscriptionsList.reduce(0) { $0 + $1.subscriptionPrice }
    }
}

// Composants réutilisables
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                Spacer()
            }
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    var isDisabled: Bool = false
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(isDisabled ? .gray : color)
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(isDisabled ? .gray : .primary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        .opacity(isDisabled ? 0.6 : 1.0)
    }
}

struct CategoryCard: View {
    let category: Category
    
    var body: some View {
        VStack(spacing: 8) {
            Image(category.categoryImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .foregroundColor(.blue)
            
            Text(category.categoryName)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct SubscriptionRow: View {
    let subscription: Subscription
    
    var body: some View {
        HStack(spacing: 12) {
            Image(subscription.subsrciptionImageName)
                .resizable()
                .frame(width: 40, height: 40)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(subscription.subscriptionName)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(String(format: "%.2f€/mois", subscription.subscriptionPrice))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    ContentView()
        //.modelContainer(for: Item.self, inMemory: true)
}
