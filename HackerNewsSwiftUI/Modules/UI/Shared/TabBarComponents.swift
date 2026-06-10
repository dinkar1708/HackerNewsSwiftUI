//
//  TabBarComponents.swift
//  HackerNewsSwiftUI
//
//  Custom tab bar with modern design
//

import SwiftUI

// MARK: - Tab Items
enum TabItem: String, CaseIterable {
    case stories = "Stories"
    case bookmarks = "Bookmarks"
    case profile = "Profile"

    var icon: String {
        switch self {
        case .stories: return "flame.fill"
        case .bookmarks: return "bookmark.fill"
        case .profile: return "person.fill"
        }
    }

    var iconUnselected: String {
        switch self {
        case .stories: return "flame"
        case .bookmarks: return "bookmark"
        case .profile: return "person"
        }
    }
}

// MARK: - Custom Tab Bar
struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    @ObservedObject var themeManager: ThemeManager
    @Namespace private var animation

    var body: some View {
        let _ = themeManager.isDarkMode // Force observation
        return VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(TabItem.allCases, id: \.self) { tab in
                    TabBarButton(tab: tab, isSelected: selectedTab == tab, animation: animation, themeManager: themeManager) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTab = tab
                        }
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.top, 12)
            .padding(.bottom, 8)

            Rectangle()
                .fill(AppColors.cardBackground)
                .frame(height: 34)
        }
        .background(AppColors.cardBackground)
        .cornerRadius(24, corners: [.topLeft, .topRight])
        .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: -5)
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let animation: Namespace.ID
    @ObservedObject var themeManager: ThemeManager
    let action: () -> Void

    var body: some View {
        let _ = themeManager.isDarkMode // Force observation
        return Button(action: action) {
            VStack(spacing: 6) {
                ZStack {
                    if isSelected {
                        Capsule()
                            .fill(AppColors.primary.opacity(0.15))
                            .frame(width: 60, height: 36)
                            .matchedGeometryEffect(id: "TAB", in: animation)
                    }
                    Image(systemName: isSelected ? tab.icon : tab.iconUnselected)
                        .font(.system(size: 22, weight: isSelected ? .semibold : .regular))
                        .foregroundColor(isSelected ? AppColors.primary : AppColors.textLight)
                        .frame(width: 60, height: 36)
                }
                Text(tab.rawValue)
                    .font(.system(size: 11, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? AppColors.primary : AppColors.textLight)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Main Tab View
struct MainTabView: View {
    @State private var selectedTab: TabItem = .stories
    @StateObject private var networkManager = NetworkManager()
    @StateObject private var themeManager = ThemeManager.shared

    var body: some View {
        let _ = themeManager.isDarkMode // Force observation
        return ZStack(alignment: .bottom) {
            AppColors.background.ignoresSafeArea()

            VStack(spacing: 0) {
                tabContent.frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            CustomTabBar(selectedTab: $selectedTab, themeManager: themeManager)
        }
        .onAppear {
            networkManager.fetchdata()
        }
        .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
    }

    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case .stories:
            StoriesTabView(networkManager: networkManager)
        case .bookmarks:
            BookmarksView()
        case .profile:
            ProfileView()
        }
    }
}

// MARK: - Stories Tab
struct StoriesTabView: View {
    @ObservedObject var networkManager: NetworkManager
    @StateObject private var themeManager = ThemeManager.shared

    var body: some View {
        let _ = themeManager.isDarkMode // Force observation
        return NavigationView {
            ZStack {
                AppColors.background.ignoresSafeArea()

                if networkManager.isLoading && networkManager.posts.isEmpty {
                    VStack(spacing: 20) {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Loading stories...")
                            .font(.system(size: 16))
                            .foregroundColor(AppColors.textSecondary)
                    }
                } else if networkManager.posts.isEmpty {
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
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationTitle("Top Stories")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Bookmarks View
struct BookmarksView: View {
    @StateObject private var themeManager = ThemeManager.shared
    @StateObject private var bookmarkManager = BookmarkManager.shared

    var body: some View {
        let _ = themeManager.isDarkMode // Force observation
        return NavigationView {
            ZStack {
                AppColors.background.ignoresSafeArea()

                if bookmarkManager.bookmarkedPosts.isEmpty {
                    VStack(spacing: 24) {
                        Image(systemName: "bookmark")
                            .font(.system(size: 70))
                            .foregroundColor(AppColors.textLight)

                        VStack(spacing: 8) {
                            Text("No Bookmarks Yet")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(AppColors.textPrimary)

                            Text("Save stories to read later")
                                .font(.system(size: 16))
                                .foregroundColor(AppColors.textSecondary)
                        }
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(bookmarkManager.bookmarkedPosts) { post in
                                NavigationLink(destination: NewsDetailsView(urlString: post.url)) {
                                    NewsCard(post: post)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(16)
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationTitle("Bookmarks")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Profile View
struct ProfileView: View {
    @StateObject private var themeManager = ThemeManager.shared

    var body: some View {
        let _ = themeManager.isDarkMode // Force observation
        return NavigationView {
            ZStack {
                AppColors.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // Profile Header
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(AppColors.primary.opacity(0.2))
                                    .frame(width: 100, height: 100)

                                Text("HN")
                                    .font(.system(size: 36, weight: .bold))
                                    .foregroundColor(AppColors.primary)
                            }

                            VStack(spacing: 4) {
                                Text("Hacker News Reader")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(AppColors.textPrimary)

                                Text("Stay updated with tech news")
                                    .font(.system(size: 15))
                                    .foregroundColor(AppColors.textSecondary)
                            }
                        }
                        .padding(.top, 40)

                        // Settings Section
                        VStack(spacing: 12) {
                            Text("Appearance")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(AppColors.textSecondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 20)
                                .padding(.top, 8)

                            ProfileMenuToggleItem(
                                icon: "moon.fill",
                                title: "Dark Mode",
                                color: AppColors.info,
                                isOn: $themeManager.isDarkMode
                            )
                            .padding(.horizontal, 20)
                        }

                        // Menu Items
                        VStack(spacing: 12) {
                            Text("General")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(AppColors.textSecondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 20)
                                .padding(.top, 8)

                            VStack(spacing: 16) {
                                ProfileMenuItem(icon: "bell.fill", title: "Notifications", color: AppColors.warning)
                                ProfileMenuItem(icon: "info.circle", title: "About", color: AppColors.info)
                                ProfileMenuItem(icon: "questionmark.circle", title: "Help & Support", color: AppColors.textSecondary)
                            }
                            .padding(.horizontal, 20)
                        }

                        // App Version
                        VStack(spacing: 8) {
                            Text("Hacker News Reader")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(AppColors.textSecondary)

                            Text("Version \(appVersion)")
                                .font(.system(size: 12))
                                .foregroundColor(AppColors.textLight)
                        }
                        .padding(.top, 24)
                    }
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var appVersion: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return "\(version) (\(build))"
        }
        return "1.0.0"
    }
}

struct ProfileMenuItem: View {
    let icon: String
    let title: String
    let color: Color
    @StateObject private var themeManager = ThemeManager.shared

    var body: some View {
        let _ = themeManager.isDarkMode // Force observation
        return HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.1))
                .cornerRadius(10)

            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(AppColors.textPrimary)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(AppColors.textLight)
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
}

struct ProfileMenuToggleItem: View {
    let icon: String
    let title: String
    let color: Color
    @Binding var isOn: Bool
    @StateObject private var themeManager = ThemeManager.shared

    var body: some View {
        let _ = themeManager.isDarkMode // Force observation
        return HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.1))
                .cornerRadius(10)

            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(AppColors.textPrimary)

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
}
