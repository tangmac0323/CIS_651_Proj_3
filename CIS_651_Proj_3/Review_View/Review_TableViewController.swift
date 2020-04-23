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
import FirebaseAuth

class Review_TablerViewController: UITableViewController {
    
    @IBOutlet weak var EditReview_NavBar: UIButton!
    
    // declare reusable identifier
    let ReusableCellIdentifier = "ReviewTableReuseCell"
    
    // declare the model
    let userProfileFirebaseModel = UserProfileFirebaseModel()
    let movieFirebaseModel = MovieReviewFirebaseModel()
    
    // declare variables pass through segue from detail view
    var movieId : Int = -1
    
    // declare variables preload before reload the data
    var NumOfRowInSection : Int = 0
    var ReviewDict : [String: [String : Any]] = [:]
    var ReviewKeyArr : [String] = []
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //self.viewWillAppear(true)
        self.loadReviewDictFromFirebase {
            super.viewWillAppear(true)
            self.tableView.reloadData()
            //print("hi")
        }
    }
     
    
    
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
        
        
        // docRef = db.collection("movies").document(movied).collection("reviews").document(userid)
        
        
        // create the data bundle for each table view cell
        self.movieFirebaseModel.RetrieveAllReviewsByMovieId(movieId: self.movieId, CompletionHandler: { querySnapshot, error in
            
            // check if there is error
            if error != nil {
                print(error as Any)
            }
            else {
                // read from the querySnapshot and build a dict to contain these data
                self.ReviewDict = self.buildLocalReviewDictFromQuery(reviewQuerySnapshot: querySnapshot!)
                //print(self.ReviewDict)
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
        
        self.NumOfRowInSection = ReviewKeyArr.count
        
        //print("Review_View/Review_TableViewController - func buildLocalReviewDictFromQuery - \n\(ReviewKeyArr)")
        
        return self.ReviewDict
    }
    
    // *********************************************************************************
    // fucntion to load data into cell
    // *********************************************************************************
    func loadDataIntoTableViewCell(cell: ReviewTableViewCell, indexPath: IndexPath){
        
        let userId = Auth.auth().currentUser!.uid
        let ownerId = self.ReviewKeyArr[indexPath.row]
        let dataSet = self.ReviewDict[ownerId]!
        
        //print("Review_View/Review_TableViewController.swift - func loadDataIntoTableViewCell() - userId=\(userId)")
        
        cell.ReviewContent_TextView.text = dataSet[MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.Content] as? String
        
        cell.Date_Label.text = dataSet[MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.Date] as? String
        
        userProfileFirebaseModel.DownloadImageFromFirebaseStorage(userId: ownerId, imageView: cell.UserPortrait_ImageView)
        
        // load nickname
        self.userProfileFirebaseModel.GetNickNameFromFirebaseByUserId(userId: ownerId) { (nickname, error) in
            if error != nil {
                print(error as Any)
            }
            else{
                if nickname == nil {
                    cell.Nickname_Label.text = "Anonymous"
                }
                else if nickname == "" {
                    cell.Nickname_Label.text = "Anonymous"
                }
                else{
                    cell.Nickname_Label.text = nickname
                }
            }
        }
        
        // load review status
        self.movieFirebaseModel.getStatusOfReviewByMovieIdByOwnerIdByUserId(userId: userId, movieId: self.movieId, ownerId: ownerId) { (reviewStatus, reviewRatingCountArray) in
            
            // load the review into cell display
            if let reviewStatus = reviewStatus {
                cell.setRatingImageByReviewStatus(reviewStatus: reviewStatus)
                cell.setReviewRatingCount(countArray: reviewRatingCountArray)
            }
        }
    }
    
    // *********************************************************************************
    // add action to like button tapped
    // *********************************************************************************
    func enableLikeReviewOnTap(cell : ReviewTableViewCell) {
        let tap = UITapGestureRecognizer(target : self, action : #selector(LikeImageTapped(tap:)))
        //self.UserProfilePortrait_ImageView.addGestureRecognizer(tap)
        cell.RatingLike_ImageView.addGestureRecognizer(tap)
        cell.RatingLike_ImageView.isUserInteractionEnabled = true
    }
    
    @objc func LikeImageTapped(tap: UITapGestureRecognizer){
        let tapLocation = tap.location(in : self.tableView)
        if let tapIndexPath = self.tableView.indexPathForRow(at: tapLocation) {
            if let tappedCell = self.tableView.cellForRow(at: tapIndexPath) as? ReviewTableViewCell {
                
                //print("Review_View/Review_TableViewController - func LikeImageTapped() - OwnerId: \(self.ReviewKeyArr[tapIndexPath.row])")
                
                let userId = Auth.auth().currentUser!.uid
                let ownerId = self.ReviewKeyArr[tapIndexPath.row]
                
                // process like tapped action and set the image
                self.processLikeRequestByUserId(userId: userId, movieId: self.movieId, ownerId: ownerId) { (reviewStatus) in
                    
                    // check if status if valid and reload the table
                    if let reviewStatus = reviewStatus {
                        //tappedCell.setRatingImageByReviewStatus(reviewStatus: reviewStatus)
                        self.loadReviewDictFromFirebase {
                            self.tableView.reloadData()
                            //print("hi")
                        }
                    }
                }
            }
        }
    }
    
    // *********************************************************************************
    // process the like request from user
    // *********************************************************************************
    func processLikeRequestByUserId(userId : String, movieId : Int, ownerId : String, CompletionHandler : @escaping (MovieAppFirebaseConstants.ReviewRatingStatus?) -> Void) {
        // check if user has already like this review
        self.movieFirebaseModel.isUserIdInLikelistOfReviewByMovieIdByOwnerId(userId: userId, movieId: movieId, ownerId: ownerId) { (isExist) in
            
            // if user already like this review, cancel the like
            if (isExist == true) {
                //print("Review_View/Review_TableViewController - func processLikeRequestByUserId() - userId:\(userId) is in LikeList of review:\(ownerId)")
                self.movieFirebaseModel.DecrementLikeFromUserIdToReviewByMovieIdByOwnerId(userId: userId, ownerId: ownerId, movieId: self.movieId) {
                    CompletionHandler(MovieAppFirebaseConstants.ReviewRatingStatus.UNRATED)
                }
            }
            // if user has not like this review yet, add the user to the like list of the review
            else{
                self.movieFirebaseModel.IncrementLikeFromUserIdToReviewByMovieIdByOwnerId(userId: userId, ownerId: ownerId, movieId: self.movieId) {
                    CompletionHandler(MovieAppFirebaseConstants.ReviewRatingStatus.LIKE)
                }
            }
        }
    }
    
    
    // *********************************************************************************
    // add action to dislike button tapped
    // *********************************************************************************
    func enableDislikeReviewOnTap(cell : ReviewTableViewCell) {
        let tap = UITapGestureRecognizer(target : self, action : #selector(DislikeImageTapped(tap:)))
        //self.UserProfilePortrait_ImageView.addGestureRecognizer(tap)
        cell.RatingDislike_ImageView.addGestureRecognizer(tap)
        cell.RatingDislike_ImageView.isUserInteractionEnabled = true
    }
    
    @objc func DislikeImageTapped(tap: UITapGestureRecognizer){
        let tapLocation = tap.location(in : self.tableView)
        if let tapIndexPath = self.tableView.indexPathForRow(at: tapLocation) {
            if let tappedCell = self.tableView.cellForRow(at: tapIndexPath) as? ReviewTableViewCell {
                
                //print("Review_View/Review_TableViewController - func DislikeImageTapped() - OwnerId: \(self.ReviewKeyArr[tapIndexPath.row])")
                
                let userId = Auth.auth().currentUser!.uid
                let ownerId = self.ReviewKeyArr[tapIndexPath.row]
                
                // process the dislike tapped action
                self.processDislikeRequestByUserId(userId: userId, movieId: self.movieId, ownerId: ownerId) { (reviewStatus) in
                    
                    // check if status if valid and reload the table
                    if let reviewStatus = reviewStatus {
                        //tappedCell.setRatingImageByReviewStatus(reviewStatus: reviewStatus)
                        self.loadReviewDictFromFirebase {
                            self.tableView.reloadData()
                            //print("hi")
                        }
                    }
                }
            }
        }
    }
    
    // *********************************************************************************
    // process the dislike request from user
    // *********************************************************************************
    func processDislikeRequestByUserId(userId : String, movieId : Int, ownerId : String, CompletionHandler : @escaping (MovieAppFirebaseConstants.ReviewRatingStatus?) -> Void) {
        // check if user has already like this review
        self.movieFirebaseModel.isUserIdInDislikelistOfReviewByMovieIdByOwnerId(userId: userId, movieId: movieId, ownerId: ownerId) { (isExist) in
            // if user already dislike this review, cancel the dislike
            if (isExist == true) {
                //print("Review_View/Review_TableViewController - func processLikeRequestByUserId() - userId:\(userId) is in LikeList of review:\(ownerId)")
                self.movieFirebaseModel.DecrementDislikeFromUserIdToReviewByMovieIdByOwnerId(userId: userId, ownerId: ownerId, movieId: self.movieId) {
                    CompletionHandler(MovieAppFirebaseConstants.ReviewRatingStatus.UNRATED)
                }
            }
                // if user has not like this review yet, add the user to the like list of the review
            else{
                self.movieFirebaseModel.IncrementDislikeFromUserIdToReviewByMovieIdByOwnerId(userId: userId, ownerId: ownerId, movieId: self.movieId) {
                    CompletionHandler(MovieAppFirebaseConstants.ReviewRatingStatus.DISLIKE)
                }
            }
        }
    }
    
    // *********************************************************************************
    // fucntion to modify the displayed rating by user
    // *********************************************************************************
    
    // *********************************************************************************
    // fucntion to transit to review view
    // *********************************************************************************
    @IBAction func EditReviewNavBarButton_Tapped(_ sender: Any) {
        self.performSegue(withIdentifier: "ReviewToEditReview", sender: self)
    }
    
    // prepare for transfer movie id from detail view to review view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ReviewToEditReview"){
            if let destVC = segue.destination as? EditReview_ViewController{
                destVC.movieId = self.movieId

            }
        }
    
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
        
        self.enableLikeReviewOnTap(cell: cell)
        self.enableDislikeReviewOnTap(cell: cell)
        
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
