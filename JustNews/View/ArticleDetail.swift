//
//  ArticleDetail.swift
//  JustNews
//
//  Created by James Hardwick on 16/05/2022.
//

import SwiftUI
import WebKit
 
// Displays WebView of webpage source of given article
struct ArticleDetail: UIViewRepresentable {
    var article: Article
 
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.load(URLRequest(url: article.url))
    }
}

struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleDetail(article: ArticleManager().getDummyArticles()["general"]![0])
    }
}
