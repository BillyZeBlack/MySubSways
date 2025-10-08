//
//  MySubscriptionInformationsView.swift
//  SubSway
//
//  Created by williams saadi on 08/04/2024.
//

import SwiftUI
import Combine

struct MySubscriptionInformationsView: View {
    
    @EnvironmentObject var categoryVM: CategoryViewModel
    @EnvironmentObject var subscriptionVM: SubscriptionViewModel
    
    @State var mySubscription: Subscription = Subscription()
    @State var isEditing: Bool = false
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Header avec image et actions
                    VStack(spacing: 20) {
                        // Titre et catégorie
                        VStack(spacing: 8) {
                            Text(mySubscription.subscriptionName)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)
                            
                            if let categoryName = mySubscription.categoryName {
                                Text(categoryName)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }
                        }
                        
                        // Actions principales
                        HStack(spacing: 16) {
                            Button {
                                isEditing.toggle()
                            } label: {
                                HStack {
                                    Image(systemName: isEditing ? "xmark.circle.fill" : "pencil.circle.fill")
                                    Text(isEditing ? "Annuler" : "Modifier")
                                }
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.green)
                                .cornerRadius(10)
                            }
                            
                            Button(role: .destructive) {
                                showDeleteConfirmation = true
                            } label: {
                                HStack {
                                    Image(systemName: "trash.circle.fill")
                                    Text("Supprimer")
                                }
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.red)
                                .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 24)
                    .background(Color(.systemBackground))
                    
                    // Informations détaillées
                    if !isEditing {
                        VStack(spacing: 16) {
                            // Section Prix et Fréquence
                            FormSection(title: "Détails financiers") {
                                InfoRow(
                                    title: "Prix",
                                    value: String(format: "%.2f€", mySubscription.subscriptionPrice),
                                    icon: "eurosign.circle.fill",
                                    iconColor: .green
                                )
                                
                                InfoRow(
                                    title: "Fréquence",
                                    value: mySubscription.selectionPaymentFrequency.isEmpty ? "Mensuelle" : mySubscription.selectionPaymentFrequency,
                                    icon: "calendar.circle.fill",
                                    iconColor: .blue
                                )
                                
                                InfoRow(
                                    title: "Prochain paiement",
                                    value: calculateNextPaymentDate(),
                                    icon: "clock.fill",
                                    iconColor: .orange
                                )
                            }
                            
                            // Section Dates
                            FormSection(title: "Dates") {
                                InfoRow(
                                    title: "Date de début",
                                    value: mySubscription.subscriptionStartDate.displayFormat,
                                    icon: "calendar",
                                    iconColor: .purple
                                )
                                
                                InfoRow(
                                    title: "Date de fin",
                                    value: mySubscription.subscriptionEndDate.displayFormat,
                                    icon: "calendar",
                                    iconColor: .purple
                                )
                            }
                            
                            // Section Engagement
                            FormSection(title: "Engagement") {
                                InfoRow(
                                    title: "Avec engagement",
                                    value: mySubscription.isSubscriptionCommitted ? "Oui" : "Non",
                                    icon: "clock.fill",
                                    iconColor: .brown
                                )
                                
                                if mySubscription.isSubscriptionCommitted {
                                    InfoRow(
                                        title: "Durée engagement",
                                        value: "\(mySubscription.subscriptionDuration) mois",
                                        icon: "clock",
                                        iconColor: .brown
                                    )
                                }
                                
                                InfoRow(
                                    title: "Période d'essai",
                                    value: mySubscription.isSubscriptionTrialPeriod ? "Oui" : "Non",
                                    icon: "gift.fill",
                                    iconColor: .pink
                                )
                                
                                if mySubscription.isSubscriptionTrialPeriod {
                                    InfoRow(
                                        title: "Durée essai",
                                        value: "\(mySubscription.subscriptionTrialPeriodDuration) mois",
                                        icon: "gift",
                                        iconColor: .pink
                                    )
                                }
                            }
                            
                            // Section Résiliation
                            FormSection(title: "Résiliation") {
                                InfoRow(
                                    title: "Préavis",
                                    value: "\(mySubscription.subscriptionCancellationNotice) mois",
                                    icon: "exclamationmark.triangle.fill",
                                    iconColor: .red
                                )
                            }
                            
                            // Informations supplémentaires
                            FormSection(title: "Informations supplémentaires") {
                                VStack(alignment: .leading, spacing: 8) {
                                    if mySubscription.subscriptionInformations.isEmpty {
                                        Text("Aucune information supplémentaire")
                                            .font(.body)
                                            .foregroundColor(.secondary)
                                            .italic()
                                    } else {
                                        Text(mySubscription.subscriptionInformations)
                                            .font(.body)
                                            .foregroundColor(.primary)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(.horizontal)
                    } else {
                        // Formulaire d'édition
                        SubscriptionDetailsFormView(
                            subscriptionCategoryName: Binding(get: { categoryVM.categories }, set: { _ in }),
                            subscriptionName: Binding(get: { mySubscription.subscriptionName }, set: { newValue in mySubscription.subscriptionName = newValue }),
                            subscriptionPrice: Binding(get: { String(mySubscription.subscriptionPrice) }, set: { newValue in
                                if let floatValue = Float(newValue) { mySubscription.subscriptionPrice = floatValue }
                            }),
                            subscriptionStartDate: Binding(get: { mySubscription.subscriptionStartDate }, set: { _ in }),
                            subscriptionIsCommited: Binding(get: { mySubscription.isSubscriptionCommitted }, set: { newValue in mySubscription.isSubscriptionCommitted = newValue }),
                            subscriptionDuration: Binding(get: { String(mySubscription.subscriptionDuration) }, set: { newValue in
                                if let intValue = Int(newValue) { mySubscription.subscriptionDuration = intValue }
                            }),
                            subscriptionIsTrialPeriod: Binding(get: { mySubscription.isSubscriptionTrialPeriod }, set: { newValue in mySubscription.isSubscriptionTrialPeriod = newValue }),
                            subscriptionTrialPeriodDuration: Binding(get: { String(mySubscription.subscriptionTrialPeriodDuration) }, set: { newValue in
                                if let intValue = Int(newValue) { mySubscription.subscriptionTrialPeriodDuration = intValue }
                            }),
                            selectionPaymentFrequency: Binding(get: { mySubscription.selectionPaymentFrequency }, set: { newValue in mySubscription.selectionPaymentFrequency = newValue }),
                            subscriptionCancellationNotice: Binding(get: { String(mySubscription.subscriptionCancellationNotice) }, set: { newValue in
                                if let intValue = Int(newValue) { mySubscription.subscriptionCancellationNotice = intValue }
                            }),
                            isFormEditing: Binding(get: { isEditing }, set: { _ in }),
                            categoryPickerSelection: Binding(get: { String(mySubscription.categoryName ?? "") }, set: { _ in }),
                            subscriptionInformation: Binding(get: { mySubscription.subscriptionInformations }, set: { newValue in mySubscription.subscriptionInformations = newValue }),
                            subscriptionSelected: Binding(get: { mySubscription }, set: { _ in })
                        )
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Mon Abonnement")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Supprimer l'abonnement", isPresented: $showDeleteConfirmation) {
                Button("Annuler", role: .cancel) { }
                Button("Supprimer", role: .destructive) {
                    subscriptionVM.removeSubscription(mySubscription)
                }
            } message: {
                Text("Êtes-vous sûr de vouloir supprimer cet abonnement ? Cette action est irréversible.")
            }
        }
    }
    
    private func calculateNextPaymentDate() -> String {
        let calendar = Calendar.current
        let nextDate = calendar.date(byAdding: .month, value: 1, to: Date()) ?? Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter.string(from: nextDate)
    }
}

// Composant réutilisable pour afficher une ligne d'information
struct InfoRow: View {
    let title: String
    let value: String
    let icon: String
    let iconColor: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundColor(iconColor)
                .frame(width: 20)
                .padding(.leading, 8)
            
            Text(title)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(value)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.trailing)
                .padding(.trailing, 8)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    MySubscriptionInformationsView()
        .environmentObject(CategoryViewModel())
        .environmentObject(SubscriptionViewModel(categoryVM: CategoryViewModel()))
}

extension Date {
    var displayFormat: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        
        if let regionCode = Locale.current.regionCode, regionCode.caseInsensitiveCompare("FR") == .orderedSame {
            formatter.locale = Locale(identifier: "fr_FR")
        } else {
            formatter.locale = Locale(identifier: "en_US")
        }
        
        return formatter.string(from: self)
    }
}
