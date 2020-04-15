//
//  ReviewFirebaseModel.swift
//  CIS_651_Proj_3
//
//  Created by Mengtao Tang on 4/14/20.
//  Copyright © 2020 Mengtao Tang. All rights reserved.
//

import Foundation
import Firebase

class MovieFirebaseModel {
    
    
    // *********************************************************************************
    // function to retrieve the number of reviews by movieId
    // *********************************************************************************
    func RetrieveReviewNumByMovieId(movieId : Int) -> Int {
        
        var revCount : Int = 0
        let db = Firestore.firestore()
        
        // get the reference of the document
        let docRef = db.collection(MovieAppFirebaseConstants.MovieDatabaseAttribute.CollectionID).document(String(movieId))
        
        docRef.getDocument { ( document, error ) in
            // catch the error
            if error != nil {
                print(error as Any)
            }
            else{
                // check if the document exist
                if let document = document, document.exists {
                    // try to retrieve the data
                    if let reviewInfo = document.data(){
                        // try to get the counts field value
                        if let counts = reviewInfo[MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewCounts]{
                            revCount = counts as! Int
                        }
                    }
                }
            }
            
        }
        
        return revCount
    }
    
    
    // *********************************************************************************
    // function to retrieve all the reviews document from the database by movieId
    // *********************************************************************************
    func RetrieveAllReviewsByMovieId(movieId : Int) -> QuerySnapshot {
        
        
        // declare the return object
        var docQuery : QuerySnapshot!
        
        // createa a reference to the database
        let db = Firestore.firestore()
        let docRef = db.collection(MovieAppFirebaseConstants.MovieDatabaseAttribute.CollectionID).document(String(movieId)).collection(MovieAppFirebaseConstants.MovieDatabaseAttribute.SubCollectionID_Review)
        
        docRef.getDocuments{ ( querySnapshot, error ) in
            // catch the error
            if error != nil {
                print(error as Any)
            }
            else{
                // check if the document exist
                if let querySnapshot = querySnapshot {
                    // try to retrieve the data
                    docQuery = querySnapshot
                }
            }
        }
        
        return docQuery
        
    }
    
    // *********************************************************************************
    // function to add a new review to movie by movieId and userId
    // *********************************************************************************
    func AddReviewByMovieIdByUserId(movieId : Int, userId : String, content : String) {
        // createa a reference to the database
        let db = Firestore.firestore()
        
        // get current date
        let dateTime = GetCurrentDateFormatted()
        let likeUserIdList = [Int]()
        let dislikeUserIdList = [Int]()

        let docRef = db.collection(MovieAppFirebaseConstants.MovieDatabaseAttribute.CollectionID).document(String(movieId)).collection(MovieAppFirebaseConstants.MovieDatabaseAttribute.SubCollectionID_Review).document(userId).setData([
            MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.Content : content,
            MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.Date : dateTime,
            MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.UserId : userId,
            MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.LikeUserList : likeUserIdList,
            MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.DisUserlikeList: dislikeUserIdList]) { error in
                if let error = error {
                    print("Model/ReviewFirebaseModel.swift - func SetReviewToMovie() - Set Data Failed\(error)")
                }
                else {
                    // success
                }
        }
    }
    
    // *********************************************************************************
    // function to update a review to movie by movieId and userId
    // *********************************************************************************
    func UpdateReviewByMovieIdByUserId(movieId : Int, userId : String, content : String) {
        
        // create a refernece to the database
        let db = Firestore.firestore()
        
        // get current date
        let dateTime = GetCurrentDateFormatted()
        
        
        
    }
    
    // *********************************************************************************
    // function to add/update review depending on existence by movieId and userId
    // *********************************************************************************
    func SetReviewByMovieIdByUserId(movieId : Int, userId : String) -> [String : Any] {
        
        var reviewDocData : [String : Any]!
        
        // create a reference to the database
        let db = Firestore.firestore()
        
        // create a reference
        let movieDocRef = db.collection(MovieAppFirebaseConstants.MovieDatabaseAttribute.CollectionID).document(String(movieId))
        
        movieDocRef.getDocument { (movieDoc, error) in
            
            // check if movie document exist by id
            if let movieDoc = movieDoc, movieDoc.exists {
                
                // check if review collection exist
                let reviewDocRef = movieDocRef.collection(MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.CollectionID).document(userId)
                
                reviewDocRef.getDocument { (reviewDoc, reviewError) in
                    
                    // check if review exist
                    if let reviewDoc = reviewDoc, reviewDoc.exists {
                        reviewDocData = reviewDoc.data()
                    }
                }
            }
        }
        
        return reviewDocData
    }
    
    
    // *********************************************************************************
    // function to retrieve review by movied and userid
    // *********************************************************************************
    func RetrieveReviewByMovieIdByUserId(movieId : Int, userId : String) -> [String : Any] {
        
        var reviewDocData : [String : Any]!
        
        // create a reference to the database
        let db = Firestore.firestore()
        
        // create a reference
        let movieDocRef = db.collection(MovieAppFirebaseConstants.MovieDatabaseAttribute.CollectionID).document(String(movieId))
        
        movieDocRef.getDocument { (movieDoc, error) in
            
            // check if movie document exist by id
            if let movieDoc = movieDoc, movieDoc.exists {
                
                // check if review collection exist
                let reviewDocRef = movieDocRef.collection(MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.CollectionID).document(userId)
                
                reviewDocRef.getDocument { (reviewDoc, reviewError) in
                    
                    // check if review exist
                    if let reviewDoc = reviewDoc, reviewDoc.exists {
                        reviewDocData = reviewDoc.data()
                    }
                }
            }
        }
        
        return reviewDocData
    }
    
    // *********************************************************************************
    // function to get current date in format string
    // *********************************************************************************
    func GetCurrentDateFormatted() -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "MM-dd-yyyy HH:mm:ss"
        let formattedDate = format.string(from : date)
        
        return formattedDate
    }
}
