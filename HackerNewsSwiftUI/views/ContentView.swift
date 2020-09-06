//
//  ContentView.swift
//  HackerNewsSwiftUI
//
//  Created by Dinakar Prasad Maurya on 2020/09/04.
//  Copyright © 2020 Dinakar Prasad Maurya. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var networkManger = NetworkManager()
    
    var body: some View {
        NavigationView{
            
            List(networkManger.posts) { post in
                
                NavigationLink(destination: WebView(urlString: post.url)) {
                    HStack{
                        Text(String(post.points)).background(Color.gray).padding()
                        Text(post.title)
                    }
                }
            }
                
            .navigationBarTitle(LocalizedStringKey("AppName"))
        }
        .onAppear {
            self.networkManger.fetchdata()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
