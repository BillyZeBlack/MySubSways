//
//  CategoryViewModel.swift
//  SubSway
//
//  Created by williams saadi on 28/03/2024.
//

import Foundation
import SwiftUI

class CategoryViewModel: ObservableObject {
    @Published var selectedCategory: Category? = nil
    @Published var categories: [Category] = []
    
    // Catégories par défaut
    private let defaultCategories = [
        Category(categoryName: "Fournisseur d'énergie", categoryImageName: "Fournisseur d'énergie", subcriptions: []),
        Category(categoryName: "Fournisseur internet", categoryImageName: "Fournisseur Internet", subcriptions: []),
        Category(categoryName: "Streamig vidéo", categoryImageName: "Streaming vidéo", subcriptions: []),
        Category(categoryName: "Streamig musical", categoryImageName: "Streaming Musical", subcriptions: []),
        Category(categoryName: "Téléphonie mobile", categoryImageName: "Téléphonie Mobile", subcriptions: []),
        Category(categoryName: "Chaine TV", categoryImageName: "Chaine TV", subcriptions: []),
        Category(categoryName: "Assurance", categoryImageName: "Assurance", subcriptions: []),
        Category(categoryName: "Sport", categoryImageName: "Sport", subcriptions: [])
    ]
    
    init() {
        loadCategories()
    }
    
    // MARK: - Gestion des Catégories
    
    /// Charge les catégories (par défaut ou depuis CoreData)
    private func loadCategories() {
        // Pour l'instant, on utilise les catégories par défaut
        // Plus tard, on pourra charger depuis CoreData
        self.categories = defaultCategories
    }
    
    /// Retourne toutes les catégories
    func getAllCategories() -> [Category] {
        return categories
    }
    
    /// Retourne les catégories qui ont des abonnements
    func getCategoriesWithSubscriptions() -> [Category] {
        return categories.filter { !$0.subcriptions.isEmpty }
    }
    
    /// Retourne les catégories sans abonnements
    func getEmptyCategories() -> [Category] {
        return categories.filter { $0.subcriptions.isEmpty }
    }
    
    /// Retourne une catégorie par son UUID
    func getCategoryByUUID(uuid: String) -> Category? {
        if let selectedUUID = UUID(uuidString: uuid) {
            return categories.first(where: { $0.id == selectedUUID })
        }
        return nil
    }
    
    /// Retourne une catégorie par son nom
    func getCategoryByName(_ name: String) -> Category? {
        return categories.first(where: { 
            $0.categoryName.trimmingCharacters(in: .whitespacesAndNewlines) == 
            name.trimmingCharacters(in: .whitespacesAndNewlines)
        })
    }
    
    // MARK: - Création de Catégories
    
    /// Crée une nouvelle catégorie
    func createCategory(name: String, imageName: String = "folder.fill") -> Bool {
        // Vérifier si la catégorie existe déjà
        guard getCategoryByName(name) == nil else {
            print("Catégorie '\(name)' existe déjà")
            return false
        }
        
        // Créer la nouvelle catégorie
        let newCategory = Category(
            categoryName: name,
            categoryImageName: imageName,
            subcriptions: []
        )
        
        // Ajouter à la liste
        categories.append(newCategory)
        
        // Sauvegarder (plus tard dans CoreData)
        saveCategories()
        
        print("Catégorie '\(name)' créée avec succès")
        return true
    }
    
    /// Sauvegarde les catégories (placeholder pour CoreData)
    private func saveCategories() {
        // TODO: Implémenter la sauvegarde dans CoreData
        print("Catégories sauvegardées (à implémenter dans CoreData)")
    }
    
    // MARK: - Gestion des Abonnements par Catégorie
    
    /// Ajoute un abonnement à la catégorie correspondante
    func addNewSubIntoCategoriesList(sub: Subscription) {
        // Si l'abonnement n'a pas de catégorie, on utilise la première par défaut
        if sub.categoryName?.isEmpty ?? true {
            sub.categoryName = defaultCategories.first?.categoryName ?? "Fournisseur d'énergie"
            sub.subsrciptionImageName = defaultCategories.first?.categoryImageName ?? "Fournisseur d'énergie"
        }
        
        // Trouver la catégorie correspondante
        for category in categories {
            if let subCategoryName = sub.categoryName,
               category.categoryName.trimmingCharacters(in: .whitespacesAndNewlines) == 
               subCategoryName.trimmingCharacters(in: .whitespacesAndNewlines) {
                
                // Vérifier que l'abonnement n'existe pas déjà
                if !category.subcriptions.contains(where: { $0.id == sub.id }) {
                    if let index = categories.firstIndex(where: { $0.id == category.id }) {
                        categories[index].subcriptions.append(sub)
                        print("Abonnement '\(sub.subscriptionName)' ajouté à la catégorie '\(category.categoryName)'")
                    }
                } else {
                    print("Abonnement '\(sub.subscriptionName)' existe déjà dans la catégorie '\(category.categoryName)'")
                }
                return
            }
        }
        
        // Si on arrive ici, la catégorie n'a pas été trouvée
        print("Catégorie '\(sub.categoryName ?? "inconnue")' non trouvée pour l'abonnement '\(sub.subscriptionName)'")
    }
    
    /// Retire un abonnement de sa catégorie
    func removeSubscriptionFromCategory(_ subscription: Subscription) {
        for category in categories {
            if let index = category.subcriptions.firstIndex(where: { $0.id == subscription.id }) {
                if let categoryIndex = categories.firstIndex(where: { $0.id == category.id }) {
                    categories[categoryIndex].subcriptions.remove(at: index)
                    print("Abonnement '\(subscription.subscriptionName)' retiré de la catégorie '\(category.categoryName)'")
                }
                return
            }
        }
    }
    
    /// Retourne tous les abonnements d'une catégorie spécifique
    func getSubscriptionsForCategory(_ categoryName: String) -> [Subscription] {
        return getCategoryByName(categoryName)?.subcriptions ?? []
    }
    
    /// Retourne le nombre d'abonnements par catégorie
    func getSubscriptionCountForCategory(_ categoryName: String) -> Int {
        return getSubscriptionsForCategory(categoryName).count
    }
    
    // MARK: - Utilitaires pour les Vues
    
    /// Retourne les noms de toutes les catégories (pour les pickers)
    func getAllCategoryNames() -> [String] {
        return categories.map { $0.categoryName }
    }
    
    /// Retourne les catégories avec leur nombre d'abonnements (pour les statistiques)
    func getCategoriesWithCounts() -> [(category: Category, count: Int)] {
        return categories.map { ($0, $0.subcriptions.count) }
    }
    
    /// Vérifie si une catégorie existe
    func categoryExists(_ name: String) -> Bool {
        return getCategoryByName(name) != nil
    }
    
    /// Retourne les catégories triées par nombre d'abonnements (décroissant)
    func getCategoriesSortedBySubscriptionCount() -> [Category] {
        return categories.sorted { $0.subcriptions.count > $1.subcriptions.count }
    }
    
    /// Retourne les catégories triées par nom
    func getCategoriesSortedByName() -> [Category] {
        return categories.sorted { $0.categoryName < $1.categoryName }
    }
    
    // MARK: - Gestion des Images
    
    /// Retourne le nom de l'image pour une catégorie
    func getImageNameForCategory(_ categoryName: String) -> String {
        return getCategoryByName(categoryName)?.categoryImageName ?? "folder.fill"
    }
    
    /// Met à jour l'image d'une catégorie
    func updateCategoryImage(_ categoryName: String, imageName: String) -> Bool {
        if let category = getCategoryByName(categoryName),
           let index = categories.firstIndex(where: { $0.id == category.id }) {
            categories[index].categoryImageName = imageName
            saveCategories()
            return true
        }
        return false
    }
}
