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
    @State private var isLoading = true

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            if let urlString = urlString, let url = URL(string: urlString) {
                ZStack {
                    SharedWebView(url: url)

                    if isLoading {
                        VStack(spacing: 20) {
                            ProgressView()
                                .scaleEffect(1.5)
                            Text("Loading article...")
                                .font(.system(size: 16))
                                .foregroundColor(AppColors.textSecondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(AppColors.background)
                    }
                }
                .navigationBarTitle("Article", displayMode: .inline)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        isLoading = false
                    }
                }
            } else {
                // Invalid URL State
                VStack(spacing: 24) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 70))
                        .foregroundColor(AppColors.warning)

                    VStack(spacing: 8) {
                        Text("Invalid URL")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)

                        Text("This story doesn't have a valid link")
                            .font(.system(size: 16))
                            .foregroundColor(AppColors.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                }
                .navigationBarTitle("Error", displayMode: .inline)
            }
        }
    }
}
