# Hacker News Reader

A modern iOS app for reading Hacker News stories built with SwiftUI. The app fetches the latest front page stories from the Hacker News API and displays them in a clean, native interface.

## Tech Stack

This project is built entirely with native iOS technologies:

SwiftUI is used for the entire UI layer. The declarative approach makes it easy to build responsive interfaces that work across different screen sizes.

URLSession handles all the networking. The app makes simple GET requests to the Hacker News Algolia API to fetch stories.

UserDefaults is used for persistent storage. Theme preferences and bookmarked stories are saved locally so they persist between app launches.

Combine framework powers the reactive data flow. The app uses ObservableObject and Published properties to keep the UI in sync with data changes.

WKWebView is embedded for displaying article content. When you tap a story, it loads the full webpage inside the app.

The architecture follows MVVM patterns with separate layers for UI, data, and business logic.

## Features

The app has three main tabs. Stories shows the current Hacker News front page. Bookmarks lets you save stories to read later. Profile has app settings and information.

Each story card shows the title, source domain, and points. Theres a bookmark button to quickly save stories. Tap anywhere else on the card to read the full article.

Dark mode is fully supported. You can toggle it from the Profile settings and the entire app theme switches instantly. All colors were carefully chosen to look good in both light and dark modes.

The bookmark system lets you save any story with one tap. All your bookmarks sync instantly across tabs and are saved permanently on your device.

Color coded point badges show story popularity at a glance. Low scoring stories get gray badges, medium ones get orange, and high scoring stories get red.

Smooth animations throughout the app. Tab switching uses spring animations and the bookmark button has a nice bounce effect.

The splash screen shows when you first launch the app with an animated logo and gradient background.

## Requirements

iOS 14.0 or later
Xcode 12 or later for building from source

Works on iPhone and iPad

## How to Run

Open the HackerNewsSwiftUI.xcodeproj file in Xcode. Select your target device or simulator from the scheme menu at the top. Hit the run button or press Command R to build and launch the app.

The app will fetch the latest stories from the Hacker News API automatically when it launches. You need an internet connection for the stories to load.

## Project Structure

The codebase is organized into modules:

UI layer contains all the SwiftUI views split by feature. Shared components like the tab bar and theme manager are in the Shared folder.

Data layer has the network manager for API calls and the model structs for decoding JSON responses.

Everything uses the MVVM pattern so views are kept simple and business logic lives in observable view models.

## Screens

<img width="300" height="600" alt="Simulator Screenshot - iPhone 17e - 2026-06-10 at 13 28 40" src="https://github.com/user-attachments/assets/c9405424-324e-437f-a342-5972db6fdc7c" />

<img width="300" height="600" alt="Simulator Screenshot - iPhone 17e - 2026-06-10 at 13 28 43" src="https://github.com/user-attachments/assets/68cd1960-8166-4722-880b-6d15afbae29b" />

<img width="300" height="600" alt="Simulator Screenshot - iPhone 17e - 2026-06-10 at 13 28 59" src="https://github.com/user-attachments/assets/8ac8d213-e301-4f02-bf75-ea35af364661" />

<img width="300" height="600" alt="Simulator Screenshot - iPhone 17e - 2026-06-10 at 13 29 04" src="https://github.com/user-attachments/assets/03711f12-0b19-4255-86b3-815c50613bce" />

<img width="300" height="600" alt="Simulator Screenshot - iPhone 17e - 2026-06-10 at 13 29 14" src="https://github.com/user-attachments/assets/467958a0-062f-4250-88d2-09bcbb692961" />


<img width="300" height="600" alt="Simulator Screenshot - iPhone 17e - 2026-06-10 at 13 29 08" src="https://github.com/user-attachments/assets/b1048ea9-2cb8-4565-915c-b90a0ae6994a" />
<img width="300" height="600" alt="Simulator Screenshot - iPhone 17e - 2026-06-10 at 13 29 11" src="https://github.com/user-attachments/assets/350fa746-89cb-4019-8a1d-177f8bb5a05d" />
