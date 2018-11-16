//
//  RedditTableViewController.swift
//  RedditApp
//
//  Created by Perez Willie Nwobu on 11/13/18.
//  Copyright © 2018 Perez Willie Nwobu. All rights reserved.
//

import UIKit

class RedditTableViewController: UITableViewController, UISearchBarDelegate {

    
    let postController = PostController()
    override func viewDidLoad() {
        super.viewDidLoad()
     searchBar.delegate = self
        postController.getRedditReddit(searchTerm: "Obama") { (sucess) in
            if sucess {
                DispatchQueue.main.async {
                    
                    print(self.postController.redditData.count)
                    self.tableView.reloadData()
                }
            
            }
        }
   
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print( postController.redditData.count)
        return postController.redditData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RedditTableViewCell
        
        let post = postController.redditData[indexPath.row]
        
        cell.redditTextView.text = post.title
        
        loadImage(forCell: cell, forItemAt: indexPath, redditData: post)
       return cell
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     return 150.0
    }
    
    //function to lead images with operations
    private func loadImage(forCell cell: RedditTableViewCell, forItemAt indexPath: IndexPath, redditData: RedditData ) {
        
        if let image = cache[redditData.id] {
            cell.redditImageView?.image = image
            
        }
        else {
            //Operation1 : Get Photo
            let op1 = FetchPhotoOperation(photoRef: redditData)
            
            //Operation2 : SavePhoto
            let op2 = BlockOperation {
                guard let image = op1.image else { return }
                self.cache.cache(value: image, for: redditData.id)
            }
            
            let op3 = BlockOperation {
                
                guard let image = op1.image else { print("Something went wrong PEREZ")
                    ;return }
                
                //making sure we on the right cell
                if indexPath == self.tableView.indexPath(for: cell) {
                    cell.redditImageView?.image = image

                }else {
                    //Soon as we get off the cell we cancel
                    self.fetchRequests[redditData.id]?.cancel()
                    
                }
            }
            op3.addDependency(op1)
            op2.addDependency(op1)
            OperationQueue.main.addOperation(op3)
            photoFetchQueue.addOperations([op1, op2], waitUntilFinished: false)
            
            //fetchOperationtrigger
            fetchRequests[redditData.id] = op1
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //define initial state(before animation)
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 100, 0)
        cell.layer.transform = rotationTransform
        
        //define the final state (after animation)
        UIView.animate(withDuration: 1, animations: {
            cell.layer.transform = CATransform3DIdentity })
        
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let post = searchBar.text, !post.isEmpty else { return }
        
        searchBar.resignFirstResponder()
        
        postController.getRedditReddit(searchTerm: post) { (sucess) in
            if sucess {
                DispatchQueue.main.async {
                    
                    print(self.postController.redditData.count)
                    self.tableView.reloadData()
                }
               
            }
        }
        DispatchQueue.main.async {
            self.searchBar.text = ""
        }
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        
        textFieldInsideSearchBar?.textColor = .black
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "cellToDetail" {
            let detailVC = segue.destination as! RedditViewController
            if let indexPath = tableView.indexPathForSelectedRow {
              let redditData = postController.redditData[indexPath.row]
                detailVC.redditData = redditData
            }
        }
        
    }
 
   
    @IBOutlet weak var searchBar: UISearchBar!
    private var cache: Cache<String, UIImage> = Cache()
    private var photoFetchQueue = OperationQueue()
    private var fetchRequests: [String : FetchPhotoOperation] = [:] {
        didSet{
            print("Start fetching Images")
        }
    }
   
}
