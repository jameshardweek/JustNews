//
//  ContentView.swift
//  JustNews
//
//  Created by James Hardwick on 16/05/2022.
//

import SwiftUI

struct ContentView: View {
    // Environment object enables global access to article manager
    @EnvironmentObject private var articleManager: ArticleManager
    @State private var selection = 0
    
    var body: some View {
        // VStack contains persistent top bar, along with appropriate view
        VStack{
            HStack {
                Image(uiImage: UIImage(named: "AppIcon")!)
                    .resizable()
                    .frame(width: 25,height: 25)
                    .padding(.leading)
                Text("Just News")
                    .font(.headline)
                Spacer()
            }
            // TabView used for main navigation
            // Uses appropriate icons and text to represent its corresponding view
            TabView (selection: $selection) {
                ArticleList(category: "general")
                    .tabItem {
                        if selection == 0 {
                            Image(uiImage: UIImage(systemName: "flame.fill")!.withRenderingMode(.alwaysOriginal).withTintColor(.systemRed))
                        } else {
                            Image(uiImage: UIImage(systemName: "flame")!)
                        }
                        Text("Top Headlines")
                    } .tag(0)
                SearchView()
                    .tabItem {
                        if selection == 1 {
                            Image(uiImage: UIImage(systemName: "magnifyingglass.circle.fill")!.withRenderingMode(.alwaysOriginal).withTintColor(.systemBlue))
                        } else {
                            Image(uiImage: UIImage(systemName: "magnifyingglass.circle")!)
                        }
                        Text("Search")
                    } .tag(1)
                CategoriesList()
                    .tabItem {
                        if selection == 2 {
                            Image(uiImage: UIImage(systemName: "newspaper.fill")!.withRenderingMode(.alwaysOriginal).withTintColor(UIColor(Color("BackgroundColor"))))
                        } else {
                            Image(uiImage: UIImage(systemName: "newspaper")!)
                        }
                        Text("Categories")
                    } .tag(2)
                ArticleList(category: "favourites")
                    .tabItem {
                        if selection == 3 {
                            Image(uiImage: UIImage(systemName: "star.fill")!.withRenderingMode(.alwaysOriginal).withTintColor(.systemYellow))
                        } else {
                            Image(uiImage: UIImage(systemName: "star")!)
                        }
                        Text("Favourites")
                    } .tag(3)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
