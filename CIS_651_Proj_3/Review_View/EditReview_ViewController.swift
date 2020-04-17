//
//  AddReview_ViewController.swift
//  CIS_651_Proj_3
//
//  Created by Mengtao Tang on 4/15/20.
//  Copyright © 2020 Mengtao Tang. All rights reserved.
//

import Foundation

import FirebaseAuth
import FirebaseStorage
import FirebaseCore
import FirebaseFirestore

class EditReview_ViewController : UIViewController {
    
    
    @IBOutlet weak var Publish_NavBarButton: UIButton!
    @IBOutlet weak var Nickname_Label: UILabel!
    @IBOutlet weak var Date_Label: UILabel!
    @IBOutlet weak var ReviewContent_TextView: UITextView!
    @IBOutlet weak var DeleteReview_Button: UIButton!
    
    
    // declare the model
    let userProfileFirebaseModel = UserProfileFirebaseModel()
    let movieFirebaseModel = MovieReviewFirebaseModel()
    
    
    // declare variables pass through segue from detail view
    var movieId : Int = -1
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.loadReviewInfoFromFirebase()
    }
    
    // *********************************************************************************
    // fucntion to load review data and display
    // *********************************************************************************
    func loadReviewInfoFromFirebase() {
        let userId = Auth.auth().currentUser!.uid
        movieFirebaseModel.RetrieveReviewByMovieIdByUserId(movieId: self.movieId, userId: userId) { (data, error) in
            
            //print("Review_View/EditReview_ViewController - func loadReviewInfoFromFirebase() - [userId: \(userId), movieId: \(self.movieId)")
            
            if error != nil {
                print(error as Any)
            }
            else{
                
                //print(data)
                
                // check if data is nil
                if data == nil {
                    self.Date_Label.text = self.movieFirebaseModel.GetCurrentDateFormatted()
                }
                else{
                    //let reviewInfo = data![userId] as! [String : Any]
                    //let reviewData = data.map(String.init(describing: )) ?? "nil"
                    let reviewData = data!
                    
                    //print(type(of :reviewData))
                    
                    //self.ReviewContent_TextView.text =
                    // display the data to the view
                    //self.Nickname_Label.text = reviewData[MovieAppFirebaseConstants.UserDatabaseAttribute.NickName] as? String
                    self.ReviewContent_TextView.text = reviewData[MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.Content] as? String
                    self.Date_Label.text = reviewData[MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.Date] as? String
                }
                
                // load nick name
                self.userProfileFirebaseModel.GetNickNameFromFirebaseByUserId(userId: userId) { (nickname, error) in
                    if error != nil {
                        print(error as Any)
                    }
                    else{
                        
                        //print(nickname)
                        
                        if nickname == nil {
                            self.Nickname_Label.text = "Anonymous"
                        }
                        else{
                            self.Nickname_Label.text = nickname
                        }
                    }
                }
            }
        } // Retrieve Function
    }
    
    
    // *********************************************************************************
    // fucntion to publish the review
    // *********************************************************************************
    @IBAction func PublishButton_Tapped(_ sender: Any) {
        
        let userId = Auth.auth().currentUser!.uid
        let movieId = self.movieId
        let content = self.ReviewContent_TextView.text ?? ""
        
        movieFirebaseModel.SetReviewByMovieIdByUserId(movieId: movieId, userId: userId, content: content) {
            self.loadReviewInfoFromFirebase()
        }
    }
    
    @IBAction func DeleteReviewButton_Tapped(_ sender: Any) {
        let userId = Auth.auth().currentUser!.uid
        let movieId = self.movieId
        
        movieFirebaseModel.DeleteReviewByMovieIdByUserId(movieId: movieId, userId: userId) {
            self.ReviewContent_TextView.text = ""
        }
    }
}


// extension for implementation of delegate/layout stuff
extension EditReview_ViewController: UITextFieldDelegate{
    
    // *********************************************************************************
    // fucntion to set the delegate of textfield to view controller
    // *********************************************************************************
    func EnableTextFieldDelegate() {
        //self.Email_TextField.delegate = self
        //self.Password_TextField.delegate = self
    }
    
    // hide the keyboard when click return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //self.view.endEditing(true)
        textField.resignFirstResponder()
        
        return true
    }
    
    // *********************************************************************************
    // hide the keyboard on tap
    // *********************************************************************************
    func EnableHideKeyBoardOnTap() {
        let Tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        view.addGestureRecognizer(Tap)
    }
    
    @objc func DismissKeyboard() {
        view.endEditing(true)
    }
}
