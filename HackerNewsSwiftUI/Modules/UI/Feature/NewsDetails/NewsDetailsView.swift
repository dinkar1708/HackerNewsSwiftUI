//
//  NewsDetailsView.swift
//  HackerNewsSwiftUI
//
//  Created by Dinakar Maurya on 2024/02/04.
//  Copyright © 2024 Dinakar Prasad Maurya. All rights reserved.
//

import Foundation
import SwiftUI

struct NewsDetailsView: View {
    let urlString: String?

    var body: some View {
        VStack {
            Text(urlString ?? "")
            if let urlString = urlString, let url = URL(string: urlString) {
                SharedWebView(url: url)
                    .padding(.top, 0)
                    .navigationBarTitle("New Details")
                    .navigationBarTitleDisplayMode(.inline)
            } else {
                Text("Invalid URL")
            }
        }
    }
}
