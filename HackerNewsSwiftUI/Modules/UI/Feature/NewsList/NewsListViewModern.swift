//
//  NewsListViewModern.swift
//  HackerNewsSwiftUI
//
//  Modern design with improved UI/UX
//

import SwiftUI

struct NewsListViewModern: View {
    @ObservedObject var networkManager = NetworkManager()
    @State private var isLoading = true

    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background.ignoresSafeArea()

                if isLoading && networkManager.posts.isEmpty {
                    // Loading State
                    VStack(spacing: 20) {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(AppColors.primary)
                        Text("Loading Hacker News...")
                            .font(.system(size: 16))
                            .foregroundColor(AppColors.textSecondary)
                    }
                } else if networkManager.posts.isEmpty {
                    // Empty State
                    VStack(spacing: 24) {
                        Image(systemName: "newspaper")
                            .font(.system(size: 70))
                            .foregroundColor(AppColors.textLight)

                        VStack(spacing: 8) {
                            Text("No Stories Found")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(AppColors.textPrimary)

                            Text("Pull to refresh")
                                .font(.system(size: 16))
                                .foregroundColor(AppColors.textSecondary)
                        }
                    }
                } else {
                    // News List
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(networkManager.posts) { post in
                                NavigationLink(destination: NewsDetailsView(urlString: post.url)) {
                                    NewsCard(post: post)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(16)
                    }
                    .refreshable {
                        await refreshNews()
                    }
                }
            }
            .navigationTitle("Hacker News")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            loadNews()
        }
    }

    private func loadNews() {
        isLoading = true
        networkManager.fetchdata()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isLoading = false
        }
    }

    private func refreshNews() async {
        networkManager.fetchdata()
        try? await Task.sleep(nanoseconds: 500_000_000)
    }
}

struct NewsListViewModern_Previews: PreviewProvider {
    static var previews: some View {
        NewsListViewModern()
    }
}
