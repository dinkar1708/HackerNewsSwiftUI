//
//  NetworkManager.swift
//  HackerNewsSwiftUI
//
//  Created by Dinakar Prasad Maurya on 2020/09/04.
//  Copyright © 2020 Dinakar Prasad Maurya. All rights reserved.
//

// TODO write common api layer code
import Foundation

class NetworkManager: ObservableObject {

    @Published var posts = [Post]()
    @Published var isLoading = false

    private var hasFetched = false

    func fetchdata() {
        // Only fetch if we haven't already
        guard !hasFetched else { return }

        isLoading = true
        print("Fetching HackerNews data...")

        if let url = URL(string: "https://hn.algolia.com/api/v1/search?tags=front_page") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                DispatchQueue.main.async {
                    self.isLoading = false
                }

                if error == nil {
                    let decoder = JSONDecoder()
                    if let safdata = data {
                        do {
                            let results = try decoder.decode(Results.self, from: safdata)
                            DispatchQueue.main.async {
                                self.posts = results.hits
                                self.hasFetched = true
                                print("Fetched \(results.hits.count) posts")
                            }
                        } catch {
                            print("Decode error: \(error)")
                        }
                    }
                } else {
                    print("Network error: \(error?.localizedDescription ?? "Unknown")")
                }
            }
            task.resume()
        }
    }
}
