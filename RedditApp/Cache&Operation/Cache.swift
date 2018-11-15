//
//  Cache.swift
//  RedditApp
//
//  Created by Perez Willie Nwobu on 11/15/18.
//  Copyright © 2018 Perez Willie Nwobu. All rights reserved.
//

import Foundation

class Cache<Key, Value> where Key : Hashable {
    //Custom Queue's
    private var queue = DispatchQueue(label: "CSG.RedditApp.CacheSerialQueue")
    
    //Array of dictionaries
    private var cachedItems: [Key: Value] = [:]
    
    subscript(_ key: Key) -> Value? {
        get {
            
            return queue.sync { cachedItems[key] ?? nil }
            //returns the value for the key entered.
            
            // queue.sync waits for synchronous task to complete before going on to other tasks
        }
        
    }
    
    func cache(value: Value, for key: Key) {
        queue.async { self.cachedItems[key] = value }
    }
}
