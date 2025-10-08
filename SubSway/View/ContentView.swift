//
//  ContentView.swift
//  SubSway
//
//  Created by williams saadi on 27/03/2024.
//

import SwiftUI
import Charts
//import SwiftData

struct ContentView: View {
    @EnvironmentObject var contentVM: ContentViewModel
    @EnvironmentObject var subscriptionVM: SubscriptionViewModel
    @EnvironmentObject var categoryVM: CategoryViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Header avec statistiques
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Synthèse")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 16) {
                            StatCard(
                                title: "Total",
                                value: "\(contentVM.subscriptionCount)",
                                icon: "creditcard.fill",
                                color: .blue
                            )
                            
                            StatCard(
                                title: "Mensuel",
                                value: String(format: "%.2f€", contentVM.totalMonthlyCost()),
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
                            
                            NavigationLink(destination: CategoriesListView()
                                .environmentObject(subscriptionVM)
                                .environmentObject(categoryVM)) {
                                QuickActionButton(
                                    title: "Mes Abonnements",
                                    icon: "list.bullet.circle.fill",
                                    color: .orange,
                                    isDisabled: !contentVM.hasSubscriptions
                                )
                            }
                            .disabled(!contentVM.hasSubscriptions)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Graphique des dépenses par catégorie
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Dépenses par Catégorie")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                        }
                        
                        if contentVM.hasSubscriptions {
                            CategoryBarChart(categoryVM: categoryVM, subscriptionVM: subscriptionVM)
                                .frame(height: 200)
                        } else {
                            VStack(spacing: 16) {
                                Image(systemName: "chart.bar.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.secondary)
                                
                                Text("Aucune donnée")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Text("Ajoutez des abonnements pour voir les statistiques")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(.separator), lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            //.navigationTitle("Tableau de Bord")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGroupedBackground))
        }
    }
}

// MARK: SubViews
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
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.separator), lineWidth: 1)
        )
        .shadow(color: .primary.opacity(0.05), radius: 1, x: 0, y: 1)
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
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.separator), lineWidth: 1)
        )
        .shadow(color: .primary.opacity(0.05), radius: 1, x: 0, y: 1)
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
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.separator), lineWidth: 1)
        )
        .shadow(color: .primary.opacity(0.05), radius: 1, x: 0, y: 1)
    }
}

// Graphique en barres pour les dépenses par catégorie avec Charts
struct CategoryBarChart: View {
    @ObservedObject var categoryVM: CategoryViewModel
    @ObservedObject var subscriptionVM: SubscriptionViewModel
    
    private var categoryData: [CategoryChartData] {
        var data: [CategoryChartData] = []
        
        for category in categoryVM.getCategoriesWithSubscriptions() {
            var totalAmount: Double = 0
            
            for subscription in category.subcriptions {
                // Convertir le prix selon la fréquence de paiement
                let monthlyAmount = convertToMonthlyAmount(
                    price: Double(subscription.subscriptionPrice),
                    frequency: subscription.selectionPaymentFrequency
                )
                totalAmount += monthlyAmount
            }
            
            if totalAmount > 0 {
                data.append(CategoryChartData(
                    id: UUID(),
                    categoryName: category.categoryName,
                    amount: totalAmount
                ))
            }
        }
        
        // Trier par montant décroissant
        return data.sorted { $0.amount > $1.amount }
    }
    
    private func convertToMonthlyAmount(price: Double, frequency: String) -> Double {
        switch frequency.lowercased() {
        case "trimestrielle", "trimestriel":
            return price / 3.0
        case "annuelle", "annuel":
            return price / 12.0
        default: // mensuelle
            return price
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            if categoryData.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "chart.bar.doc.horizontal")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    
                    Text("Aucune donnée disponible")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(height: 200)
            } else {
                // Graphique en barres avec Charts
                Chart {
                    ForEach(categoryData) { data in
                        BarMark(
                            x: .value("Catégorie", data.categoryName),
                            y: .value("Montant", data.amount)
                        )
                        .foregroundStyle(by: .value("Catégorie", data.categoryName))
                        .cornerRadius(6)
                        .annotation(position: .top) {
                            Text(String(format: "%.1f€", data.amount))
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                        }
                    }
                }
                .chartForegroundStyleScale([
                    "Fournisseur d'énergie": .blue,
                    "Fournisseur internet": .green,
                    "Streamig vidéo": .purple,
                    "Streamig musical": .orange,
                    "Téléphonie mobile": .red,
                    "Chaine TV": .pink,
                    "Assurance": .brown,
                    "Sport": .cyan
                ])
                .chartYAxis {
                    AxisMarks(position: .leading) { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel {
                            if let doubleValue = value.as(Double.self) {
                                Text(String(format: "%.0f€", doubleValue))
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .chartXAxis(.hidden)
                .frame(height: 200)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.separator), lineWidth: 1)
        )
        .shadow(color: .primary.opacity(0.05), radius: 1, x: 0, y: 1)
    }
    
    private func truncateCategoryName(_ name: String) -> String {
        if name.count > 12 {
            return String(name.prefix(10)) + "..."
        }
        return name
    }
}

// Structure de données pour le graphique
struct CategoryChartData: Identifiable {
    let id: UUID
    let categoryName: String
    let amount: Double
}

#Preview {
    ContentView()
        //.modelContainer(for: Item.self, inMemory: true)
}
