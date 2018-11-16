//
//  RedditViewController.swift
//  RedditApp
//
//  Created by Perez Willie Nwobu on 11/13/18.
//  Copyright © 2018 Perez Willie Nwobu. All rights reserved.
//

import UIKit
import WebKit

class RedditViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
       
    }
    
    func updateViews(){
        
        guard isViewLoaded else {return}
        
        let urlString = redditData?.url
        guard let url = URL(string: urlString!) else {return}
        let request = URLRequest(url: url)
        postWebView.load(request)
    }

    @IBOutlet weak var postWebView: WKWebView!
    var redditData : RedditData? {
        didSet {
            updateViews()
        }
    }
}
