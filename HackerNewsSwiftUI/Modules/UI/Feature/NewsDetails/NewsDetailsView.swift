//
//  NewsDetailsView.swift
//  HackerNewsSwiftUI
//
//  Created by Arnav Maurya on 2024/02/04.
//  Copyright © 2024 Dinakar Prasad Maurya. All rights reserved.
//

import Foundation
import WebKit
import SwiftUI

struct NewsDetailsView: UIViewRepresentable {
    
    let urlString: String?
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let safeString = urlString {
            if let url = URL(string: safeString) {
                let request = URLRequest(url: url)
                uiView.load(request)
            }
        }
    }
    
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        NewsDetailsView(urlString: "www.google.com")
    }
}
