//
//  ArticleList.swift
//  JustNews
//
//  Created by James Hardwick on 16/05/2022.
//

import SwiftUI

struct ArticleList: View {
    // Environment object enables global access to article manager
    @EnvironmentObject private var articleManager: ArticleManager
    private var category: String
    private var title: String
    private var showDate: Bool = false
    
    init(category: String) {
        self.category = category
        if category == "favourites" {
            self.title = "Favourites"
            self.showDate = true
        } else if category == "general" {
            self.title = "Top Headlines"
        } else if category == "search" {
            self.title = "Search Results"
            self.showDate = true
        } else {
            self.title = "Top \(category.capitalized) Headlines"
        }
    }
    
    var body: some View {
        // Navigation view enables access to full WebView of article content
        NavigationView {
            if articleManager.articles[category] != [] {
                List(articleManager.articles[category]!, id: \.self) {article in
                    NavigationLink {
                        ArticleDetail(article: article)
                            
                    } label: {
                        ArticleRow(article: article, showDate: showDate)
                    }
                    // Enables saving and removing from favourites
                    .swipeActions {
                        if category == "favourites" {
                            Button(action: {
                                if let index = articleManager.articles["favourites"]!.firstIndex(of: article) {
                                    articleManager.removeFavourite(article: article)
                                    articleManager.articles["favourites"]!.remove(at: index)
                                }
                            }) {
                                Image(systemName: "trash")
                            }
                            .tint(.red)
                        } else {
                            Button(action: {
                                if !articleManager.articles["favourites"]!.contains(article) {
                                    articleManager.articles["favourites"]!.insert(article, at: 0)
                                    articleManager.saveFavourite(article: article)
                                }
                            }) {
                                Image(systemName: "star")
                            }
                            .tint(.yellow)
                        }
                    }
                }
                .navigationTitle (title)
                // Enables refreshing of news articles
                .refreshable {
                    if category != "favourites" && category != "search" {
                        articleManager.updateNews(category: category)
                    }
                }
            } else {
                VStack {
                    if category == "favourites" {
                        Text("To add a favourite, swipe on an article")
                    } else if category == "search" {
                        Text("Search for news")
                    } else {
                        Text("No articles to display")
                    }
                }
            }
        }
    }
}

struct ArticleList_Previews: PreviewProvider {
    static var previews: some View {
        ArticleList(category: "general")
    }
}
