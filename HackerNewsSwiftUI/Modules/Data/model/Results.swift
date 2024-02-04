//
//  Results.swift
//  HackerNewsSwiftUI
//
//  Created by Dinakar Prasad Maurya on 2020/09/04.
//  Copyright © 2020 Dinakar Prasad Maurya. All rights reserved.
//

import Foundation

struct Results :Decodable{
    let hits : [Post]
}

struct Post:Decodable, Identifiable {
    var id : String{
        return objectID
    }
    let objectID: String
    let points:Int
    let title:String
    let url : String?
}
