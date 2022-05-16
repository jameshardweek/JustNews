//
//  CategoriesList.swift
//  JustNews
//
//  Created by James Hardwick on 16/05/2022.
//

import SwiftUI

struct CategoriesList: View {
    // Environment object enables global access to article manager
    @EnvironmentObject private var articleManager: ArticleManager
    
    var body: some View {
        // Display all available categories in a list
        // When category is pressed, display articles for the selected category
        NavigationView {
            List(articleManager.categories.filter({$0 != "general"}), id: \.self) { category in
                NavigationLink {
                    ArticleList(category: category)
                        .navigationBarTitleDisplayMode(.inline)
                } label: {
                    Text(category.capitalized)
                }
            }
            .navigationTitle("Categories")
        }
    }
}

struct CategoriesList_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesList()
    }
}
