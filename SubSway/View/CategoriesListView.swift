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
    
    // Utilise la méthode de CategoryViewModel pour obtenir les catégories avec abonnements
    private var categoriesWithSubscriptions: [Category] {
        categoryVM.getCategoriesWithSubscriptions()
    }
    
    var body: some View {
        Group {
            if categoriesWithSubscriptions.isEmpty {
                // État vide - aucune catégorie avec abonnements
                VStack(spacing: 20) {
                    Image(systemName: "tray")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary)
                        .padding(.bottom, 8)
                    
                    Text("Aucun abonnement")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("Vous n'avez pas encore d'abonnements dans vos catégories")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemGroupedBackground))
            } else {
                // Liste des catégories avec abonnements - Design conforme Apple
                List {
                    ForEach(categoriesWithSubscriptions, id: \.id) { category in
                        Section {
                            ForEach(category.subcriptions, id: \.id) { subscription in
                                NavigationLink(
                                    destination: MySubscriptionInformationsView(mySubscription: subscription)
                                        .environmentObject(subscriptionVM)
                                        .environmentObject(categoryVM)
                                ) {
                                    SubscriptionRow(subscription: subscription)
                                }
                                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            }
                        } header: {
                            HStack {
                                Text(category.categoryName)
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                    .textCase(nil) // Désactive la majuscule automatique
                                
                                Spacer()
                                
                                Text("\(category.subcriptions.count)")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle("Mes Abonnements")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: SubViews
// Composant réutilisable pour afficher une ligne d'abonnement - Design vibrant et engageant
struct SubscriptionRow: View {
    let subscription: Subscription
    
    private var monthlyAmount: Double {
        let price = Double(subscription.subscriptionPrice)
        switch subscription.selectionPaymentFrequency.lowercased() {
        case "trimestrielle", "trimestriel":
            return price / 3.0
        case "annuelle", "annuel":
            return price / 12.0
        default:
            return price
        }
    }
    
    // Couleur basée sur la catégorie pour un design cohérent
    private var categoryColor: Color {
        switch subscription.categoryName?.lowercased() {
        case "fournisseur d'énergie":
            return .blue
        case "fournisseur internet":
            return .green
        case "streamig vidéo", "streaming vidéo":
            return .purple
        case "streamig musical", "streaming musical":
            return .orange
        case "téléphonie mobile":
            return .red
        case "chaine tv":
            return .pink
        case "assurance":
            return .brown
        case "sport":
            return .cyan
        default:
            return .indigo
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Informations principales avec design moderne
            VStack(alignment: .leading, spacing: 6) {
                Text(subscription.subscriptionName)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                HStack(spacing: 8) {
                    // Indicateur de fréquence
                    Text(getFrequencyBadge())
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(categoryColor)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(categoryColor.opacity(0.1))
                        .cornerRadius(6)
                }
            }
            
            Spacer()
            
            // Prix avec design accrocheur
            VStack(alignment: .trailing, spacing: 4) {
                Text(String(format: "%.2f€", subscription.subscriptionPrice))
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(categoryColor)
                
                Text("Dépense \(subscription.selectionPaymentFrequency)")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(categoryColor.opacity(0.1))
            )
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 4)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
        )
        .contentShape(Rectangle())
    }
    
    private func getFrequencyBadge() -> String {
        let frequency = subscription.selectionPaymentFrequency.lowercased()
        switch frequency {
        case "mensuelle", "mensuel":
            return "M"
        case "trimestrielle", "trimestriel":
            return "T"
        case "annuelle", "annuel":
            return "A"
        default:
            return "M"
        }
    }
}

#Preview {
    CategoriesListView()
        .environmentObject(SubscriptionViewModel(categoryVM: CategoryViewModel()))
        .environmentObject(CategoryViewModel())
}
