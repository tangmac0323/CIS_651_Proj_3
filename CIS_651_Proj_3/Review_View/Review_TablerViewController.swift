//
//  Review_TablerViewController.swift
//  CIS_651_Proj_3
//
//  Created by Mengtao Tang on 4/12/20.
//  Copyright © 2020 Mengtao Tang. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class Review_TablerViewController: UITableViewController {
    
    // declare reusable identifier
    let ReusableCellIdentifier = "ReviewTableReuseCell"
    
    // declare the model
    let userProfileFirebaseModel = UserProfileFirebaseModel()
    let movieFirebaseModel = MovieFirebaseModel()
    
    // declare variables pass through segue from detail view
    var movieId : Int = -1
    
    // declare variables preload before reload the data
    var NumOfRowInSection : Int = 0
    var ReviewDict : [String: [String : Any]] = [:]
    var ReviewKeyArr : [String] = []
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.loadNumOfRowInSectionFromFirebase() {
            self.loadReviewDictFromFirebase {
                
                self.tableView.reloadData()
            }
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    /*
    override func viewWillAppear(_ animated: Bool) {
        movieFirebaseModel.RetrieveReviewNumByMovieId(movieId: self.movieId, revCompletionHandler: { counts, error in
            if let counts = counts {
                self.numOfRowInSection = counts
                //self.performSegue(withIdentifier: "MovieDetailToReview", sender: self)
                //print(self.numOfRowInSection)
                super.viewWillAppear(true)
            }
        })
    }
    */
    
    // *********************************************************************************
    // fucntion to preload the number of review for the movie id
    // *********************************************************************************
    func loadNumOfRowInSectionFromFirebase(CompletionHandler: @escaping () -> Void) {
        
        // get the number of row in section
        self.movieFirebaseModel.RetrieveReviewNumByMovieId(movieId: self.movieId, revCompletionHandler: { counts, error in
            if let counts = counts {
                self.NumOfRowInSection = counts
                CompletionHandler()
            }
        })
    }
    
    func loadReviewDictFromFirebase(CompletionHandler: @escaping () -> Void) {
        // create the data bundle for each table view cell
        self.movieFirebaseModel.RetrieveAllReviewsByMovieId(movieId: self.movieId, CompletionHandler: { querySnapshot, error in
            
            // check if there is error
            if error != nil {
                print(error as Any)
            }
            else {
                // read from the querySnapshot and build a dict to contain these data
                self.ReviewDict = self.buildLocalReviewDictFromQuery(reviewQuerySnapshot: querySnapshot!)
                print(self.ReviewDict)
                CompletionHandler()
            }
            
        })
    }
    
    
    // *********************************************************************************
    // fucntion to build the local review dictionary from firebase
    // *********************************************************************************
    func buildLocalReviewDictFromQuery(reviewQuerySnapshot : QuerySnapshot) -> [String : [String : Any]] {
        //var reviewDict : [String : [String : Any]] = [:]
        
        // clear the dict and arr
        self.ReviewDict.removeAll()
        self.ReviewKeyArr.removeAll()
        
        // loop through the query snapshot
        for document in reviewQuerySnapshot.documents {
            self.ReviewDict[document.documentID] = document.data()
            self.ReviewKeyArr.append(document.documentID)
        }
        
        return self.ReviewDict
    }
    
    // *********************************************************************************
    // fucntion to load data into cell
    // *********************************************************************************
    func loadDataIntoTableViewCell(cell: ReviewTableViewCell, indexPath: IndexPath){
        
        let userId = self.ReviewKeyArr[indexPath.row]
        let dataSet = self.ReviewDict[userId]!
        
        cell.ReviewContent_TextView.text = dataSet[MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.Content] as! String
        
        cell.Date_Label.text = dataSet[MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.Date] as! String
        
        userProfileFirebaseModel.DownloadImageFromFirebaseStorage(userId: userId, imageView: cell.UserPortrait_ImageView)
    }

    ///--------------------------------------------------------------------------
    /// Extension of the tableview
    ///--------------------------------------------------------------------------
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    // function to decide the total row of the table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        //print("Review_TableViewController - func numOfSections() - movieId: \(self.movieId) numOfRowInSection: \(self.numOfRowInSection)")
        
        return self.NumOfRowInSection
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.ReusableCellIdentifier, for: indexPath) as! ReviewTableViewCell
        
        
        // Configure the cell...
        loadDataIntoTableViewCell(cell: cell, indexPath: indexPath)
        //cell.backgroundColor = UIColor(white: 1, alpha: 0.3)
        return cell
    }
    
    /*
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return       // set the height of each cell to 15% of the main screen
    }
    */

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
