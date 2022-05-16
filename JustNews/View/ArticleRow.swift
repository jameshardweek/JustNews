//
//  ArticleRow.swift
//  JustNews
//
//  Created by James Hardwick on 16/05/2022.
//

import SwiftUI

struct ArticleRow: View {
    // Variable containing data of the current article
    @State var article: Article
    
    // Environment object enables global access to article manager
    @EnvironmentObject private var articleManager: ArticleManager
    
    // Date is shown on favourites and search views
    var showDate: Bool = false
    
    var body: some View {
        // Display important article information
        // Includes thumbnail, headline, publisher, and optionally the date
        HStack {
            AsyncImage(url: article.urlToImage) { image in
                image.resizable()
            } placeholder: {
                Image("noimage")
                    .resizable()
            }
            .aspectRatio(contentMode: .fit)
            .frame(width: 75, height: 75)
            
            VStack (alignment: .leading) {
                Text(article.title)
                    .font(.headline)
                    .padding([.top,.bottom], 1.0)
                    .dynamicTypeSize(/*@START_MENU_TOKEN@*/.small/*@END_MENU_TOKEN@*/)
                // If Article is a favourite, display a star next to the article
                if articleManager.articles["favourites"]!.contains(article) {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size:10))
                        Text("\(article.source.name ?? "Error")" )
                            .font(.caption)
                            .foregroundColor(.blue)
                        if showDate {
                            Spacer()
                            Text((article.publishedAt.components(separatedBy: "T")[0]))
                                .font(.caption)
                        }
                    }
                } else {
                    HStack {
                        Text(article.source.name ?? "Error")
                            .font(.caption)
                            .foregroundColor(.blue)
                        if showDate {
                            Spacer()
                            Text((article.publishedAt.components(separatedBy: "T")[0]))
                                .font(.caption)
                        }
                    }
                }
            }
        }
    }
}

struct ArticleRow_Previews: PreviewProvider {
    static var previews: some View {
        ArticleRow(article: ArticleManager().getDummyArticles()["general"]![0])
    }
}
