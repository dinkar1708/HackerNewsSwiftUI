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

// MARK: - App Colors
struct AppColors {
    static let primary = Color(hex: "FF6600")
    static let secondary = Color(hex: "F6F6EF")
    static let accent = Color(hex: "00D9FF")
    static let background = Color(hex: "F8F9FA")
    static let cardBackground = Color.white
    static let textPrimary = Color(hex: "2D3436")
    static let textSecondary = Color(hex: "636E72")
    static let textLight = Color(hex: "B2BEC3")
    static let success = Color(hex: "00B894")
    static let warning = Color(hex: "FDCB6E")
    static let error = Color(hex: "FF7675")
    static let info = Color(hex: "74B9FF")
    static let pointsLow = Color(hex: "95A5A6")
    static let pointsMedium = Color(hex: "FF6600")
    static let pointsHigh = Color(hex: "E74C3C")
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

    var body: some View {
        HStack(spacing: 16) {
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

    var body: some View {
        VStack(spacing: 4) {
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
