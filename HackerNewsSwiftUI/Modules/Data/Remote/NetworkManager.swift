//
//  NetworkManager.swift
//  HackerNewsSwiftUI
//
//  Created by Dinakar Prasad Maurya on 2020/09/04.
//  Copyright © 2020 Dinakar Prasad Maurya. All rights reserved.
//

// TODO write common api layer code
import Foundation
class NetworkManager :ObservableObject {
    
    @Published var posts = [Post]()
    
    func fetchdata() {
        print("call api")
        if let url = URL(string: "https://hn.algolia.com/api/v1/search?tags=front_page"){
            let session = URLSession(configuration: .default)
            let task  = session.dataTask(with: url){ (data, response, error ) in
                if error == nil {
                    let decoder = JSONDecoder()
                    if let safdata = data{
                        do {
                            let results = try decoder.decode(Results.self, from: safdata)
                            DispatchQueue.main.async {
                                self.posts = results.hits
                                
                            }
                        }catch{
                            print(error)
                        }
                    }
                }
            }
            task.resume()
        }
    }
}
