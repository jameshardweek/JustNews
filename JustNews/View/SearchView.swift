//
//  SearchView.swift
//  JustNews
//
//  Created by James Hardwick on 16/05/2022.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    
    // Environment object enables global access to article manager
    @EnvironmentObject private var articleManager: ArticleManager
    
    private var title: String = "Search News"
    
    var body: some View {
        VStack {
            // When enter is pressed, get articles containing search term
            TextField("Search News", text: $searchText, onCommit: {  articleManager.searchNews(search: searchText)
            })
            .textFieldStyle(.roundedBorder)
            .padding()
            
            ArticleList(category: "search")
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
