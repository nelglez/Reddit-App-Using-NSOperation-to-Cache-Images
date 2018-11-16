//
//  Operations.swift
//  RedditApp
//
//  Created by Perez Willie Nwobu on 11/15/18.
//  Copyright © 2018 Perez Willie Nwobu. All rights reserved.
//

import Foundation
import UIKit

class ConcurrentOperation: Operation {
    
    enum State: String {
        case isReady, isExecuting, isFinished
    }
    
    private var _state = State.isReady
    
    private let stateQueue = DispatchQueue(label: "CSG.ShudderAppInterview.ConcurrentOperationStateQueue")
    
    
    var state: State {
        get {
            var result: State?
            let queue = self.stateQueue
            
            queue.sync {
                result = _state
            }
            return result!
            
            //First time this is run it will return the "isReadyState" then if can change later
        }
        
        set {
            let oldValue = state
            willChangeValue(forKey: newValue.rawValue)
            willChangeValue(forKey: oldValue.rawValue)
            
            stateQueue.sync { self._state = newValue }
            
            didChangeValue(forKey: oldValue.rawValue)
            didChangeValue(forKey: newValue.rawValue)
        }
        
    }
    
    override  dynamic var isReady: Bool {
        return super.isReady && state == .isReady
    }
    
    override dynamic var isExecuting: Bool {
        return state == .isExecuting
    }
    
    override dynamic var  isFinished: Bool {
        return state == .isFinished
    }
    
    override  var isAsynchronous: Bool {
        return true
    }
    
}

class FetchPhotoOperation : ConcurrentOperation {
    
    init(photoRef: RedditData) {
        self.redditData = photoRef
}
    
    var redditData: RedditData
    
   
    var image : UIImage?
    private var dataTask: URLSessionDataTask?
    
    override func start() {
        state = .isExecuting
        
        guard let url = URL(string: redditData.thumbnail)     else { return }
       
        print("This is the Image URL : - \(url)")
        dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            defer { self.state = .isFinished }
            if let error = error {
                NSLog("Error retrieving image from url: \(error), Refer to your dataTast in FetchOperation")
                return
            }
            guard let data = data else { return }
            if let downloadedImage = UIImage(data: data) {
                self.image = downloadedImage
            }
        }
        
        dataTask?.resume()
    }
    
    override func cancel() {
        dataTask?.cancel()
        //I will use this to cancel the dataTask method when the user scrolls off the screen.
    }
    
}
