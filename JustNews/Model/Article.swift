//
//  Article.swift
//  JustNews
//
//  Created by James Hardwick on 16/05/2022.
//

import Foundation

import Foundation

// Struct representing Article data
struct Article: Hashable, Codable {
    let title: String
    let author: String?
    let url: URL
    let description: String?
    let urlToImage: URL?
    let publishedAt: String
    let content: String?
    let source: Source
}

// Struct representing Source data
struct Source: Hashable, Codable {
    let id: String?
    let name: String?
}

// Struct representing Response data
struct Response: Hashable, Codable {
    let articles: [Article]
}
