//
//  SharedWebView.swift
//  HackerNewsSwiftUI
//
//  Created by Dinakar Maurya on 2024/02/04.
//  Copyright © 2024 Dinakar Prasad Maurya. All rights reserved.

import Foundation
import WebKit
import SwiftUI

struct SharedWebView: UIViewRepresentable {
    let url: URL?

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = url {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}

struct SharedWebView_Previews: PreviewProvider {
    static var previews: some View {
        SharedWebView(url: URL(string: "https://www.google.com"))
    }
}
