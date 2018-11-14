//
//  PostController.swift
//  RedditApp
//
//  Created by Perez Willie Nwobu on 11/13/18.
//  Copyright © 2018 Perez Willie Nwobu. All rights reserved.
//

import Foundation

class PostController  {
    
    var redditData : [RedditData] = []
    let redditUrl = "https://www.reddit.com/r/trump.json"
    
    func getRedditReddit(searchTerm : String, completion : @escaping ((Bool)->Void) ){
        let newURL = redditUrl.replacingOccurrences(of: "trump", with: searchTerm)
        
        guard let url = URL(string: newURL) else {return}
        
        let dataTask = URLSession.shared.dataTask(with: url) {  (data, _, error) in
            guard let data = data else { print("there was a problem decoding this JSON"); completion(false); return}
            
            if let error = error { print(error.localizedDescription); completion(false); return}
            
            let decoder = JSONDecoder()
            

            guard  let arrayOFReddits = try? decoder.decode(JSONData.self , from: data) else {
                print("there was a problem decoding JSON data into an array") ; return
            }
            
           // let tempReddits : [RedditData]  = []
            
             //self.subreddits = responseModel.data.children.compactMap({$0.data})
            self.redditData = arrayOFReddits.data.childrem.compactMap({$0.data})
            print(self.redditData[0].title)
            
        }
            dataTask.resume()
        
    }
    
}
