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
	
	@Published var categories = [
		Category(categoryName: "Fournisseur d'énergie", categoryImageName: "Fournisseur d'énergie", subcriptions: []),
		Category(categoryName: "Fournisseur internet", categoryImageName: "Fournisseur Internet", subcriptions: []),
		Category(categoryName: "Streamig vidéo", categoryImageName: "Streaming vidéo", subcriptions: []),
		Category(categoryName: "Streamig musical", categoryImageName: "Streaming Musical", subcriptions: []),
		Category(categoryName: "Téléphonie mobile", categoryImageName: "Téléphonie Mobile", subcriptions: []),
		Category(categoryName: "Chaine TV", categoryImageName: "Chaine TV", subcriptions: []),
		Category(categoryName: "Assurance", categoryImageName: "Assurance", subcriptions: []),
		Category(categoryName: "Sport", categoryImageName: "Sport", subcriptions: [])
    ]
    
	func getCategoryByUUID(uuid: String)-> Category?
	{
		if let selectedUUID = UUID(uuidString: uuid) {
			return categories.first(where: {$0.id == selectedUUID})
		}
		
		return nil
	}
	
//    func addcategoryIntoCategoriesList(category: Category)
//    {
//        categories.append(category)
//    }
	
//	func addNewSubIntoCategoriesList(sub: Subscription)
//	{
//		for cat in categories {
//			if sub.categoryName == "" {
//				sub.categoryName = "Fournisseur d'énergie"
//				sub.subsrciptionImageName = "Fournisseur d'énergie"
//			}
//			
//			if cat.categoryName == sub.categoryName && !cat.subscriptions.contains(where: { $0.id == sub.id }){
//				if let index = categories.firstIndex(where: {$0.categoryName == cat.categoryName}) {
//					categories[index].subscriptions.append(sub)
//				}
//				return
//			}
//		}
//	}
}
