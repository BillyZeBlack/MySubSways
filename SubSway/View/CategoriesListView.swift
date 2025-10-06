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
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(categoryVM.categories, id: \.id) { category in
                        CategorySectionView(
                            category: category,
                            subscriptionVM: subscriptionVM,
                            categoryVM: categoryVM
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.top)
            }
            .navigationTitle("Toutes les Catégories")
            .navigationBarTitleDisplayMode(.large)
            .background(Color(.systemGroupedBackground))
        }
    }
}

struct CategorySectionView: View {
    let category: Category
    @ObservedObject var subscriptionVM: SubscriptionViewModel
    @ObservedObject var categoryVM: CategoryViewModel
    
    private var categorySubscriptions: [Subscription] {
        subscriptionVM.subscriptionsList.filter { $0.categoryName == category.categoryName }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header de la catégorie
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(category.categoryName)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("\(categorySubscriptions.count) abonnement\(categorySubscriptions.count > 1 ? "s" : "")")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 16)
            
            // Grille des abonnements de la catégorie
            if !categorySubscriptions.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 12) {
                        ForEach(categorySubscriptions, id: \.id) { subscription in
                            NavigationLink(destination: SubscriptionDetailsView(subscriptionDetails: subscription)
                                .environmentObject(subscriptionVM)
                                .environmentObject(categoryVM)
                            ) {
                                SubscriptionCard(subscription: subscription)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 16)
                }
            } else {
                // État vide
                VStack(spacing: 12) {
                    Image(systemName: "tray")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                    
                    Text("Aucun abonnement")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Cette catégorie ne contient pas encore d'abonnements")
                        .font(.caption)
                        .foregroundColor(.secondary.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32)
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .padding(.horizontal, 16)
            }
        }
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
}

struct SubscriptionCard: View {
    let subscription: Subscription
    
    var body: some View {
        VStack(spacing: 12) {
            // Image de l'abonnement
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .frame(width: 80, height: 80)
                
                Image(subscription.subsrciptionImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .cornerRadius(8)
            }
            
            // Informations
            VStack(spacing: 4) {
                Text(subscription.subscriptionName)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                if subscription.subscriptionPrice > 0 {
                    Text(String(format: "%.2f€", subscription.subscriptionPrice))
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 80)
        }
        .padding(.vertical, 12)
        .frame(width: 100)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    CategoriesListView()
        .environmentObject(SubscriptionViewModel(categoryVM: CategoryViewModel()))
        .environmentObject(CategoryViewModel())
}
