//
//  SharedWebView.swift
//  HackerNewsSwiftUI
//
//  Created by Dinakar Maurya on 2024/02/04.
//  Copyright © 2024 Dinakar Prasad Maurya. All rights reserved.
//

import Foundation
import WebKit
import SwiftUI

// MARK: - Theme Manager
class ThemeManager: ObservableObject {
    static let shared = ThemeManager()

    @Published var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        }
    }

    private init() {
        self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
    }

    var currentTheme: Theme {
        isDarkMode ? .dark : .light
    }
}

// MARK: - Bookmark Manager
class BookmarkManager: ObservableObject {
    static let shared = BookmarkManager()

    @Published var bookmarkedPosts: [Post] = []
    private let bookmarksKey = "bookmarkedPosts"

    private init() {
        loadBookmarks()
    }

    func isBookmarked(_ post: Post) -> Bool {
        bookmarkedPosts.contains(where: { $0.objectID == post.objectID })
    }

    func toggleBookmark(_ post: Post) {
        if let index = bookmarkedPosts.firstIndex(where: { $0.objectID == post.objectID }) {
            bookmarkedPosts.remove(at: index)
        } else {
            bookmarkedPosts.insert(post, at: 0)
        }
        saveBookmarks()
    }

    private func saveBookmarks() {
        if let encoded = try? JSONEncoder().encode(bookmarkedPosts) {
            UserDefaults.standard.set(encoded, forKey: bookmarksKey)
        }
    }

    private func loadBookmarks() {
        if let data = UserDefaults.standard.data(forKey: bookmarksKey),
           let decoded = try? JSONDecoder().decode([Post].self, from: data) {
            bookmarkedPosts = decoded
        }
    }
}

// MARK: - Theme
struct Theme {
    let primary: Color
    let secondary: Color
    let accent: Color
    let background: Color
    let cardBackground: Color
    let textPrimary: Color
    let textSecondary: Color
    let textLight: Color
    let success: Color
    let warning: Color
    let error: Color
    let info: Color
    let pointsLow: Color
    let pointsMedium: Color
    let pointsHigh: Color

    static let light = Theme(
        primary: Color(hex: "FF6600"),
        secondary: Color(hex: "F6F6EF"),
        accent: Color(hex: "00D9FF"),
        background: Color(hex: "F8F9FA"),
        cardBackground: Color.white,
        textPrimary: Color(hex: "2D3436"),
        textSecondary: Color(hex: "636E72"),
        textLight: Color(hex: "B2BEC3"),
        success: Color(hex: "00B894"),
        warning: Color(hex: "FDCB6E"),
        error: Color(hex: "FF7675"),
        info: Color(hex: "74B9FF"),
        pointsLow: Color(hex: "95A5A6"),
        pointsMedium: Color(hex: "FF6600"),
        pointsHigh: Color(hex: "E74C3C")
    )

    static let dark = Theme(
        primary: Color(hex: "FF6600"),
        secondary: Color(hex: "1A1A1A"),
        accent: Color(hex: "00D9FF"),
        background: Color(hex: "121212"),
        cardBackground: Color(hex: "1E1E1E"),
        textPrimary: Color(hex: "FFFFFF"),
        textSecondary: Color(hex: "B0B0B0"),
        textLight: Color(hex: "6E6E6E"),
        success: Color(hex: "00B894"),
        warning: Color(hex: "FDCB6E"),
        error: Color(hex: "FF7675"),
        info: Color(hex: "74B9FF"),
        pointsLow: Color(hex: "95A5A6"),
        pointsMedium: Color(hex: "FF6600"),
        pointsHigh: Color(hex: "E74C3C")
    )
}

// MARK: - Dynamic App Colors
struct AppColorsProvider {
    static func colors(for theme: Theme) -> AppColorsType {
        AppColorsType(
            primary: theme.primary,
            secondary: theme.secondary,
            accent: theme.accent,
            background: theme.background,
            cardBackground: theme.cardBackground,
            textPrimary: theme.textPrimary,
            textSecondary: theme.textSecondary,
            textLight: theme.textLight,
            success: theme.success,
            warning: theme.warning,
            error: theme.error,
            info: theme.info,
            pointsLow: theme.pointsLow,
            pointsMedium: theme.pointsMedium,
            pointsHigh: theme.pointsHigh
        )
    }
}

struct AppColorsType {
    let primary: Color
    let secondary: Color
    let accent: Color
    let background: Color
    let cardBackground: Color
    let textPrimary: Color
    let textSecondary: Color
    let textLight: Color
    let success: Color
    let warning: Color
    let error: Color
    let info: Color
    let pointsLow: Color
    let pointsMedium: Color
    let pointsHigh: Color
}

// MARK: - Environment Key
struct ThemeKey: EnvironmentKey {
    static let defaultValue: Theme = .light
}

extension EnvironmentValues {
    var theme: Theme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}

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

// MARK: - App Colors (Dynamic Theme Support)
struct AppColors {
    private static var current: AppColorsType {
        let theme = ThemeManager.shared.currentTheme
        return AppColorsProvider.colors(for: theme)
    }

    static var primary: Color { current.primary }
    static var secondary: Color { current.secondary }
    static var accent: Color { current.accent }
    static var background: Color { current.background }
    static var cardBackground: Color { current.cardBackground }
    static var textPrimary: Color { current.textPrimary }
    static var textSecondary: Color { current.textSecondary }
    static var textLight: Color { current.textLight }
    static var success: Color { current.success }
    static var warning: Color { current.warning }
    static var error: Color { current.error }
    static var info: Color { current.info }
    static var pointsLow: Color { current.pointsLow }
    static var pointsMedium: Color { current.pointsMedium }
    static var pointsHigh: Color { current.pointsHigh }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct NewsCard: View {
    let post: Post
    @StateObject private var themeManager = ThemeManager.shared
    @StateObject private var bookmarkManager = BookmarkManager.shared

    var body: some View {
        let _ = themeManager.isDarkMode // Force observation
        return HStack(spacing: 16) {
            PointsBadge(points: post.points)

            VStack(alignment: .leading, spacing: 8) {
                Text(post.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
                    .lineLimit(3)

                HStack(spacing: 8) {
                    if let url = post.url, let domain = extractDomain(from: url) {
                        Text(domain)
                            .font(.system(size: 13))
                            .foregroundColor(AppColors.textSecondary)
                    }

                    Spacer()

                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            bookmarkManager.toggleBookmark(post)
                        }
                    }) {
                        Image(systemName: bookmarkManager.isBookmarked(post) ? "bookmark.fill" : "bookmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(bookmarkManager.isBookmarked(post) ? AppColors.primary : AppColors.textLight)
                    }
                    .buttonStyle(PlainButtonStyle())

                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(AppColors.textLight)
                }
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }

    private func extractDomain(from urlString: String) -> String? {
        guard let url = URL(string: urlString) else { return nil }
        return url.host?.replacingOccurrences(of: "www.", with: "")
    }
}

struct PointsBadge: View {
    let points: Int
    @StateObject private var themeManager = ThemeManager.shared

    var body: some View {
        let _ = themeManager.isDarkMode // Force observation
        return VStack(spacing: 4) {
            Text("\(points)")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)

            Text("pts")
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(width: 60, height: 60)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(badgeColor)
        )
    }

    private var badgeColor: Color {
        if points < 50 {
            return AppColors.pointsLow
        } else if points < 150 {
            return AppColors.pointsMedium
        } else {
            return AppColors.pointsHigh
        }
    }
}
