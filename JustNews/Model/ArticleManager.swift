//
//  ArticleManager.swift
//  JustNews
//
//  Created by James Hardwick on 16/05/2022.
//

import Foundation

// ArticleManager class
// Used for updating stored articles
// Also used for loading, saving, and removing favourites

class ArticleManager : ObservableObject {
    let categories: [String] = ["business", "entertainment", "general", "health", "science", "sports", "technology"]
    
    // Dictionary containing all stored articles
    // Keys are categories
    // Values are list of Articles for that category
    @Published var articles: Dictionary<String, [Article]>! = [:]
    
    public init() {
        self.articles = getDummyArticles()
        self.articles["search"] = []
        
//      UNCOMMENT TO RETRIEVE LATEST NEWS ON LAUNCH
//        for category in categories {
//            updateNews(category: category)
//        }
    }
    
    // Function to load dummy articles from resources folder
    func getDummyArticles() -> Dictionary<String, [Article]> {
        var articles: Dictionary<String, [Article]> = [:]

        for category in categories {
            do {
                guard let file = Bundle.main.url(forResource: category, withExtension: ".json") else { return [:] }
                var content = try String(contentsOf: file)
                content = content.replacingOccurrences(of: ":\"\"", with: ":null")
                let jsonData = content.data(using: .utf8)!
                let response = try JSONDecoder().decode(Response.self, from: jsonData)
                articles[category] = response.articles
            } catch {
                articles[category] = []
            }
        }
        
        // Load favourites
        articles["favourites"] = getFavourites()
        return articles
    }

    // Function that attempts to load stored favourite articles
    // Returns list of Articles sorted by the published date/time
    func getFavourites() -> [Article] {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dirContents = try! FileManager.default.contentsOfDirectory(
                at: dir,
                includingPropertiesForKeys: [.localizedNameKey]
        )

        var articles: [Article] = []

        for url in dirContents.filter({$0.pathExtension == "json"}) {
            do {
                var content = try String(contentsOf: url)
                content = content.replacingOccurrences(of: ":\"\"", with: ":null")
                let jsonData = content.data(using: .utf8)!
                try articles.append(JSONDecoder().decode(Article.self, from: jsonData))
            } catch {
                print(error)
            }
        }
        articles = articles.sorted(by: { $0.publishedAt > $1.publishedAt })
        
        return articles
    }
    
    // Function that removes a saved favourite
    func removeFavourite(article: Article) {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let file = dir.appendingPathComponent(article.title + ".json")
        
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: file)
        } catch {
            print(error)
        }
    }
    
    // Saves an article as a favourite
    func saveFavourite(article: Article) {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let file = dir.appendingPathComponent(article.title + ".json")

        do {
            let articleString = try String(data: JSONEncoder().encode(article), encoding: .utf8)
            try articleString!.write(to: file, atomically: true, encoding: .utf8)
        } catch {
            print(error)
        }
    }
    
    // Updates articles for a given category
    func updateNews(category: String) {
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?country=gb&apiKey=708ad74a333343d78c544425e5cb85cd&pageSize=50&category=\(category)") else { return }
        do {
            var content = try String(contentsOf: url)
            content = content.replacingOccurrences(of: ":\"\"", with: ":null")
            guard let jsonData = content.data(using: .utf8) else { return }
            let response: Response = try JSONDecoder().decode(Response.self, from: jsonData)
            articles[category] = response.articles
        } catch {
            print(error)
//            articles[category] = []
        }
    }
    
    // Retrieves a list of articles from a given search text
    func searchNews(search: String) {
        // Text is escaped in an attempt to minimise potential errors
        let escapedString = search.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? search
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=\(escapedString)&apiKey=708ad74a333343d78c544425e5cb85cd") else { return }
        do {
            var content = try String(contentsOf: url)
            content = content.replacingOccurrences(of: ":\"\"", with: ":null")
            guard let jsonData = content.data(using: .utf8) else { return }
            let response: Response = try JSONDecoder().decode(Response.self, from: jsonData)
            articles["search"] = response.articles.sorted(by: {$0.publishedAt > $1.publishedAt })
        } catch {
            print(error)
//            articles["search"] = []
        }
    }
}
