//
//  SubscriptionDetailsFormView.swift
//  SubSway
//
//  Created by williams saadi on 03/04/2024.
//

import SwiftUI
import Combine

struct SubscriptionDetailsFormView: View {
    
    @EnvironmentObject var categoryVM: CategoryViewModel
    @EnvironmentObject var subscriptionVM: SubscriptionViewModel
    
    @Binding var subscriptionCategoryName: [Category]
    @Binding var subscriptionName: String
    @Binding var subscriptionPrice: String
    @Binding var subscriptionStartDate: Date
    @Binding var subscriptionIsCommited: Bool
    @Binding var subscriptionDuration: String
    @Binding var subscriptionIsTrialPeriod: Bool
    @Binding var subscriptionTrialPeriodDuration: String
    @Binding var selectionPaymentFrequency: String
    @Binding var subscriptionCancellationNotice: String
    @Binding var isFormEditing: Bool
    @Binding var categoryPickerSelection: String
    @Binding var subscriptionInformation: String
    @Binding var subscriptionSelected: Subscription?
    
    @State var alertMessage: String = ""
    @State var showAlert = false
    @State private var isCreating = false
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                
                // Header chaleureux
                VStack(spacing: 16) {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.orange.opacity(0.1))
                                .frame(width: 60, height: 60)
                            
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.orange)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Nouvel Abonnement")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("Prenez le contrôle de vos dépenses")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // Barre de progression subtile
                    Rectangle()
                        .fill(Color.orange.opacity(0.3))
                        .frame(height: 3)
                        .cornerRadius(1.5)
                        .padding(.horizontal)
                }
                .padding(.top, 8)
                
                // Informations principales
                FormSection(title: "Informations principales") {
                    // Catégorie
                    if subscriptionSelected == nil {
                        FormField(
                            title: "Catégorie",
                            icon: "folder.fill",
                            content: {
                                Picker("Catégorie", selection: $categoryPickerSelection) {
                                    ForEach(subscriptionCategoryName, id: \.id) { category in
                                        Text(category.categoryName)
                                            .tag("\(category.id)")
                                    }
                                }
                                .pickerStyle(.navigationLink)
                            }
                        )
                    } else {
                        FormField(
                            title: "Catégorie",
                            icon: "folder.fill",
                            content: {
                                Text(subscriptionSelected?.categoryName ?? "")
                                    .foregroundColor(.secondary)
                            }
                        )
                    }
                    
                    // Nom de l'abonnement
                    FormField(
                        title: "Nom de l'abonnement",
                        icon: "textformat",
                        content: {
                            TextField("ex: Netflix Premium", text: $subscriptionName)
                                .textFieldStyle(PlainTextFieldStyle())
                        }
                    )
                    
                    // Prix
                    FormField(
                        title: "Prix",
                        icon: "eurosign.circle.fill",
                        content: {
                            HStack {
                                TextField("0,00", text: $subscriptionPrice)
                                    .keyboardType(.decimalPad)
                                    .onReceive(Just(subscriptionPrice)) { newPrice in
                                        var filtered = newPrice.filter { ",.0123456789".contains($0) }
                                        
                                        let decimalCount = filtered.filter { $0 == "," || $0 == "." }.count
                                        
                                        if decimalCount > 1 {
                                            var hasFoundDecimal = false
                                            filtered = filtered.reduce(into: "") { (result, char) in
                                                if char == "," || result == "." {
                                                    if !hasFoundDecimal {
                                                        result.append(char)
                                                        hasFoundDecimal = true
                                                    }
                                                } else {
                                                    result.append(char)
                                                }
                                            }
                                        }
                                        
                                        if filtered != newPrice {
                                            self.subscriptionPrice = filtered
                                        }
                                    }
                                
                                Text("€")
                                    .foregroundColor(.secondary)
                            }
                        }
                    )
                    
                    // Date de début
                    FormField(
                        title: "Date de début",
                        icon: "calendar",
                        content: {
                            DatePicker("", selection: $subscriptionStartDate, displayedComponents: .date)
                                .labelsHidden()
                                .environment(\.locale, Locale(identifier: "fr_FR"))
                        }
                    )
                }
                
                // Options d'engagement
                FormSection(title: "Options") {
                    // Engagement
                    if !subscriptionIsTrialPeriod {
                        ToggleRow(
                            title: "Avec engagement",
                            icon: "clock.fill",
                            isOn: $subscriptionIsCommited
                        )
                    }
                    
                    // Durée d'engagement
                    if subscriptionIsCommited && !subscriptionIsTrialPeriod {
                        FormField(
                            title: "Durée de l'engagement",
                            icon: "clock",
                            content: {
                                HStack {
                                    TextField("12", text: $subscriptionDuration)
                                        .keyboardType(.numberPad)
                                        .onReceive(Just(subscriptionDuration)) { newDuration in
                                            let filtered = newDuration.filter { "0123456789".contains($0) }
                                            if filtered != newDuration {
                                                self.subscriptionDuration = filtered
                                            }
                                        }
                                    
                                    Text("mois")
                                        .foregroundColor(.secondary)
                                }
                            }
                        )
                    }
                    
                    // Période d'essai
                    if !subscriptionIsCommited {
                        ToggleRow(
                            title: "Période d'essai",
                            icon: "gift.fill",
                            isOn: $subscriptionIsTrialPeriod
                        )
                    }
                    
                    // Durée période d'essai
                    if !subscriptionIsCommited && subscriptionIsTrialPeriod {
                        FormField(
                            title: "Durée de la période d'essai",
                            icon: "gift",
                            content: {
                                HStack {
                                    TextField("1", text: $subscriptionTrialPeriodDuration)
                                        .keyboardType(.numberPad)
                                        .onReceive(Just(subscriptionTrialPeriodDuration)) { newDuration in
                                            let filtered = newDuration.filter { "0123456789".contains($0) }
                                            if filtered != newDuration {
                                                self.subscriptionTrialPeriodDuration = filtered
                                            }
                                        }
                                    
                                    Text("mois")
                                        .foregroundColor(.secondary)
                                }
                            }
                        )
                    }
                }
                
                // Fréquence de paiement
                FormSection(title: "Paiement") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Fréquence de paiement")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Picker("Fréquence", selection: $selectionPaymentFrequency) {
                            ForEach(["Mensuelle", "Trimestrielle", "Annuelle"], id: \.self) { frequency in
                                Text(frequency)
                                    .tag(frequency)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }
                
                // Préavis de résiliation
                FormSection(title: "Résiliation") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Préavis de résiliation")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Picker("Préavis", selection: $subscriptionCancellationNotice) {
                            ForEach(["0", "1", "2", "3"], id: \.self) { notice in
                                Text("\(notice) mois")
                                    .tag(notice)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }
                
                // Informations supplémentaires
                FormSection(title: "Détails supplémentaires") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Informations supplémentaires")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        TextEditor(text: $subscriptionInformation)
                            .frame(height: 100)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                    }
                }
                
                // Bouton de validation avec dégradé
                VStack(spacing: 16) {
                    Button(action: createSubscription) {
                        HStack {
                            if isCreating {
                                ProgressView()
                                    .scaleEffect(0.8)
                                    .tint(.white)
                            } else {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.title3)
                            }
                            
                            Text(isCreating ? "Création en cours..." : "Créer l'abonnement")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.green,
                                    Color.blue
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .disabled(isCreating || !isFormValid)
                    .scaleEffect((isCreating || !isFormValid) ? 0.95 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isCreating || !isFormValid)
                    
                    if !isFormValid {
                        HStack(spacing: 8) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.orange)
                            
                            Text("Veuillez remplir tous les champs obligatoires")
                                .font(.caption)
                                .foregroundColor(.orange)
                                .multilineTextAlignment(.center)
                        }
                        .padding(12)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                
                // Footer avec icône
                VStack(spacing: 12) {
                    Image(systemName: "sparkles")
                        .font(.title3)
                        .foregroundColor(.purple.opacity(0.7))
                    
                    Text("Votre abonnement sera ajouté à votre liste personnelle")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 8)
            }
            .padding(.vertical)
        }
        .background(Color.white)
        .alert("Information", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private var isFormValid: Bool {
        !subscriptionName.isEmpty &&
        !subscriptionPrice.isEmpty &&
        !categoryPickerSelection.isEmpty
    }
    
    private func createSubscription() {
        guard isFormEditing && !isCreating else { return }
        
        isCreating = true
        
        // Simuler un délai pour l'animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let message = subscriptionVM.createSubscription(
                categoryVM: categoryVM,
                categoryPickerSelection: categoryPickerSelection,
                subscriptionSelected: subscriptionSelected,
                subscriptionPrice: subscriptionPrice,
                subscriptionDuration: subscriptionDuration,
                subscriptionCancellationNotice: subscriptionCancellationNotice,
                subscriptionStartDate: subscriptionStartDate,
                subscriptionIsCommited: subscriptionIsCommited,
                subscriptionIsTrialPeriod: subscriptionIsTrialPeriod,
                subscriptionTrialPeriodDuration: subscriptionTrialPeriodDuration,
                subscriptionInformation: subscriptionInformation,
                selectionPaymentFrequency: selectionPaymentFrequency,
                subscriptionName: subscriptionName
            )
            
            if !message.0.contains("Erreur") {
                alertMessage = "\(message.0)\nVotre abonnement a bien été ajouté à votre liste."
            } else {
                alertMessage = "\(message.0)\nVotre abonnement n'a pas été créé."
            }
            
            showAlert = true
            isCreating = false
        }
    }
}

// Composants réutilisables - Interface sobre mais accueillante
struct FormSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .padding(.horizontal)
            
            VStack(spacing: 1) {
                content
            }
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.03), radius: 1, x: 0, y: 1)
            .padding(.horizontal)
        }
    }
}

struct FormField<Content: View>: View {
    let title: String
    let icon: String
    let content: Content
    
    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.subheadline)
                    .foregroundColor(.orange)
                    .frame(width: 20)
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            content
        }
        .padding()
        .background(Color.white)
    }
}

struct ToggleRow: View {
    let title: String
    let icon: String
    @Binding var isOn: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.subheadline)
                    .foregroundColor(.orange)
                    .frame(width: 20)
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Toggle("", isOn: $isOn)
                    .labelsHidden()
                    .tint(.orange)
            }
        }
        .padding()
        .background(Color.white)
    }
}

#Preview {
    SubscriptionDetailsFormView(
        subscriptionCategoryName: .constant([]),
        subscriptionName: .constant(""),
        subscriptionPrice: .constant(""),
        subscriptionStartDate: .constant(Date()),
        subscriptionIsCommited: .constant(false),
        subscriptionDuration: .constant(""),
        subscriptionIsTrialPeriod: .constant(false),
        subscriptionTrialPeriodDuration: .constant(""),
        selectionPaymentFrequency: .constant("Mensuelle"),
        subscriptionCancellationNotice: .constant("0"),
        isFormEditing: .constant(true),
        categoryPickerSelection: .constant(""),
        subscriptionInformation: .constant(""),
        subscriptionSelected: .constant(nil)
    )
    .environmentObject(CategoryViewModel())
    .environmentObject(SubscriptionViewModel(categoryVM: CategoryViewModel()))
}
