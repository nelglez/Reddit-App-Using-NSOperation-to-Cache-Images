//
//  Post.swift
//  RedditApp
//
//  Created by Perez Willie Nwobu on 11/13/18.
//  Copyright © 2018 Perez Willie Nwobu. All rights reserved.
//

import Foundation


struct JSONData : Codable{
    let data : FirstData
}

struct  FirstData : Codable {
    let children : [Child]
}

struct Child : Codable {
    let data : RedditData
}

struct RedditData: Codable {
    let title : String
    let thumbnail : String
    let url : String
    let id : String
}
