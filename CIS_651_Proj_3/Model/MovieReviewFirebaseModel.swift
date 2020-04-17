//
//  ReviewFirebaseModel.swift
//  CIS_651_Proj_3
//
//  Created by Mengtao Tang on 4/14/20.
//  Copyright © 2020 Mengtao Tang. All rights reserved.
//

import Foundation
import Firebase

class MovieReviewFirebaseModel {
    
    
    // *********************************************************************************
    // function to retrieve the number of reviews by movieId
    // *********************************************************************************
    func RetrieveReviewNumByMovieId(movieId : Int, revCompletionHandler: @escaping (Int?, Error?) -> Void){
        
        var revCount : Int = 0
        let db = Firestore.firestore()
        
        // get the reference of the document
        let docRef = db.collection(MovieAppFirebaseConstants.MovieDatabaseAttribute.CollectionID).document(String(movieId))
        
        docRef.getDocument { ( document, error ) in
            // catch the error
            if error != nil {
                print(error as Any)
                revCompletionHandler(nil, error)
            }
            else{
                // check if the document exist
                if let document = document, document.exists {
                    // try to retrieve the data
                    if let reviewInfo = document.data(){
                        // try to get the counts field value
                        if let counts = reviewInfo[MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewCounts]{
                            revCount = counts as! Int
                            //print("revCount: \(revCount)")
                            revCompletionHandler(revCount, nil)
                        }
                    }
                    else{
                        print("MovieFirebasemodel - RetrieveReviewNumByMovieId() - Movies.Document.Data Failed to Retrieve")
                    }
                }
                else{
                    print("MovieFirebasemodel - RetrieveReviewNumByMovieId() - Movies.Document Does Not Exist")
                }
            }
            
        }
        //print("revCount Return: \(revCount)")
        //return revCount
    }
    
    
    // *********************************************************************************
    // function to retrieve all the reviews document from the database by movieId
    // *********************************************************************************
    func RetrieveAllReviewsByMovieId(movieId : Int, CompletionHandler: @escaping (QuerySnapshot?, Error?) -> Void) {
        
        // declare the return object
        //var docQuery : QuerySnapshot!
        
        // createa a reference to the database
        let db = Firestore.firestore()
        let docRef = db.collection(MovieAppFirebaseConstants.MovieDatabaseAttribute.CollectionID).document(String(movieId)).collection(MovieAppFirebaseConstants.MovieDatabaseAttribute.SubCollectionID_Review)
        
        docRef.getDocuments{ ( querySnapshot, error ) in
            // catch the error
            if error != nil {
                print(error as Any)
                CompletionHandler(nil, error)
            }
            else{
                // check if the document exist
                if let querySnapshot = querySnapshot {
                    // try to retrieve the data
                    //docQuery = querySnapshot
                    CompletionHandler(querySnapshot, nil)
                }
            }
        }
        
        //return docQuery
        
    }
    
    // *********************************************************************************
    // function to add a new review to movie by movieId and userId
    // *********************************************************************************
    func AddReviewByMovieIdByUserId(movieId : Int, userId : String, content : String, CompletionHandler : @escaping () -> Void ) {
        // createa a reference to the database
        let db = Firestore.firestore()
        
        // get current date
        let dateTime = GetCurrentDateFormatted()
        
        let likeUserIdList = [String]()
        let dislikeUserIdList = [String]()
        
        let docRef = db.collection(MovieAppFirebaseConstants.MovieDatabaseAttribute.CollectionID).document(String(movieId)).collection(MovieAppFirebaseConstants.MovieDatabaseAttribute.SubCollectionID_Review).document(userId).setData([
            MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.Content : content,
            MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.Date : dateTime,
            MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.UserId : userId,
            MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.LikeUserList : likeUserIdList,
            MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.DislikeUserList: dislikeUserIdList]) { error in
                if let error = error {
                    print("Model/ReviewFirebaseModel.swift - func SetReviewToMovie() - Set Data Failed\(error)")
                    CompletionHandler()
                }
                else {
                    // success
                    CompletionHandler()
                }
        }
        
        /*
        let docRef = db.collection(MovieAppFirebaseConstants.MovieDatabaseAttribute.CollectionID).document(String(movieId)).collection(MovieAppFirebaseConstants.MovieDatabaseAttribute.SubCollectionID_Review).document(userId).setData([
            MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.Content : content,
            MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.Date : dateTime,
            MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.UserId : userId]) { error in
                if let error = error {
                    print("Model/ReviewFirebaseModel.swift - func SetReviewToMovie() - Set Data Failed\(error)")
                    CompletionHandler()
                }
                else {
                    // success
                    CompletionHandler()
                }
        }
        */
    }
    
    // *********************************************************************************
    // function to update a review to movie by movieId and userId
    // *********************************************************************************
    func UpdateReviewByMovieIdByUserId(movieId : Int, userId : String, content : String, CompletionHandler : @escaping () -> Void) {
        
        // create a refernece to the database
        let db = Firestore.firestore()
        
        // get current date
        let dateTime = GetCurrentDateFormatted()
        
        let docRef = db.collection(MovieAppFirebaseConstants.MovieDatabaseAttribute.CollectionID).document(String(movieId)).collection(MovieAppFirebaseConstants.MovieDatabaseAttribute.SubCollectionID_Review).document(userId)
        
        docRef.updateData([
            MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.Date : dateTime,
            MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.Content : content
        ]) { error in
            if let error = error {
                print(error as Any)
            }
            else{
                CompletionHandler()
            }
        }
        
        
        
    }
    
    // *********************************************************************************
    // function to add/update review depending on existence by movieId and userId
    // *********************************************************************************
    func SetReviewByMovieIdByUserId(movieId : Int, userId : String, content: String, CompletionHandler : @escaping () -> Void){
        
        //var reviewDocData : [String : Any]!
        
        // create a reference to the database
        let db = Firestore.firestore()
        
        // create a reference
        let movieDocRef = db.collection(MovieAppFirebaseConstants.MovieDatabaseAttribute.CollectionID).document(String(movieId))
        
        movieDocRef.getDocument { (movieDoc, error) in
            
            if error != nil {
                print("Model/MovieFirebaseModel.swift - func SetReviewByMovieIdByUserId() - Get Movie Document Faield\(error)")
                CompletionHandler()
            }
            else{
                // check if movie document exist by id
                if let movieDoc = movieDoc, movieDoc.exists {
                    
                    // check if reviews collection exist
                    let reviewDocRef = movieDocRef.collection(MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.CollectionID).document(userId)
                    
                    reviewDocRef.getDocument { (reviewDoc, reviewError) in
                        if reviewError != nil {
                            CompletionHandler()
                        }
                        else{
                            // check if review exist
                            // if exist, update the review
                            if let reviewDoc = reviewDoc, reviewDoc.exists {
                                self.UpdateReviewByMovieIdByUserId(movieId: movieId, userId: userId, content: content) {
                                    print("Model/MovieFirebaseModel.swift - func SetReviewByMovieIdByUserId() - Update Review Done")
                                    CompletionHandler()
                                }
                            }
                            // if not exist, add a new review
                            else{
                                self.AddReviewByMovieIdByUserId(movieId: movieId, userId: userId, content: content) {
                                    print("Model/MovieFirebaseModel.swift - func SetReviewByMovieIdByUserId() - Add Review When Review Not Exist")
                                    CompletionHandler()
                                }
                            }
                        }
                    }
                }   // if let movieDoc = movieDoc, movieDoc does not exist
                else{
                    movieDocRef.setData(["dummyField":"dummy"])
                    self.AddReviewByMovieIdByUserId(movieId: movieId, userId: userId, content: content) {
                        print("Model/MovieFirebaseModel.swift - func SetReviewByMovieIdByUserId() - Add Review When Movie Doc Not Exist")
                        CompletionHandler()
                    }
                }
            }
        }
        
    }
    
    
    // *********************************************************************************
    // function to retrieve review by movied and userid
    // *********************************************************************************
    func RetrieveReviewByMovieIdByUserId(movieId : Int, userId : String, CompletionHandler : @escaping ([String : Any]?, Error?) -> Void){
        
        //print("Model/MovieReviewFirebaseModel.swift - func RetrieveReviewByMovieIdByUserId() - [movieId: \(movieId), userId: \(userId)]")
        
        var reviewDocData : [String : Any]!
        
        // create a reference to the database
        let db = Firestore.firestore()
        
        // create a reference
        let movieDocRef = db.collection(MovieAppFirebaseConstants.MovieDatabaseAttribute.CollectionID).document(String(movieId))
                
        movieDocRef.getDocument { (movieDoc, error) in
            
            if error != nil {
                CompletionHandler(nil, error)
                //print(error as! String)
            }
            else {
                // check if movie document exist by id
                if let movieDoc = movieDoc, movieDoc.exists {
                    
                    // check if review collection exist
                    let reviewDocRef = movieDocRef.collection(MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.CollectionID).document(userId)
                    
                    reviewDocRef.getDocument { (reviewDoc, reviewError) in
                        
                        if reviewError != nil {
                            print("Model/MovieReviewFirebaseModel.swift - func RetrieveReviewByMovieIdByUserId() - \(reviewError)")
                            CompletionHandler(nil, reviewError)
                        }
                        else{
                            // check if review exist
                            if let reviewDoc = reviewDoc, reviewDoc.exists {
                                reviewDocData = reviewDoc.data()
                                CompletionHandler(reviewDocData, nil)
                            }
                                // review does not exist
                            else{
                                print("Model/MovieReviewFirebaseModel - func RetrieveReviewByMovieIdByUserId() - Review Not Exist")
                                CompletionHandler(nil, nil)
                            }
                        }
                    }
                }   // if let movieDoc = movieDoc
                else {
                    print("Model/MovieReviewFirebaseModel - func RetrieveReviewByMovieIdByUserId() - MovieDoc Not Exist")
                    CompletionHandler(nil, nil)
                }
            }
        }
        
        //print(reviewDocData)
        
        //return reviewDocData
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
    
    // *********************************************************************************
    // function to delete a review
    // *********************************************************************************
    func DeleteReviewByMovieIdByUserId(movieId: Int, userId: String, CompletionHandler : @escaping () -> Void) {
        // create a reference to the database
        let db = Firestore.firestore()
        
        // create a reference
        let movieIdStr = String(movieId)
        
        db.collection(MovieAppFirebaseConstants.MovieDatabaseAttribute.CollectionID).document(movieIdStr).collection(MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.CollectionID).document(userId).delete() { error in
            
            if let error = error {
                print("Model/MovieReviewFirebaseModel.swift - func DeleteReviewByMovieIdByUserId() - Delete Failed\n\(error)")
                CompletionHandler()
            }
            else{
                // success
                CompletionHandler()
            }
        }
    }
    
    // *********************************************************************************
    // function to increment like to review by adding user id into review like list
    // *********************************************************************************
    func IncrementLikeFromUserIdToReviewByMovieIdByOwnerId(userId: String, ownerId: String, movieId: Int, CompletionHandler : @escaping () -> Void) {
        
        // create a reference to the database
        let db = Firestore.firestore()
        
        // create a reference of the review
        let reviewDocRef = db.collection(MovieAppFirebaseConstants.MovieDatabaseAttribute.CollectionID).document(String(movieId)).collection(MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.CollectionID).document(ownerId)
        
        // try to get the data from the review document
        reviewDocRef.getDocument(completion: { (document, error) in
            
            // check if there is error
            if error != nil {
                print("Model/MovieReviewFirebaseModel.swift - func IncrementLikeFromUserIdToReviewByMovieId() - \(error)")
            }
            // try to extract the data
            else{
                if let document = document, document.exists {
                    if let reviewDocData = document.data() {
                        let likeList = reviewDocData[MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.LikeUserList] as! [String]
                        
                        //print("Model/MovieReviewFirebaseModel.swift - func IncrementLikeFromUserIdToReviewByMovieId() - LikeList:\(likeList)")
                        
                        let tempLikeList = Array(Set(self.addUserIdToLikeList(userId: userId, likeList: likeList)))
                        
                        // update the like list
                        reviewDocRef.updateData([
                            MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.LikeUserList : tempLikeList
                        ]) { error in
                            if error != nil {
                                print(error)
                            }
                            else {
                                CompletionHandler()
                            }
                        }
                    }
                }   // if let document = document, document.exists
            }
        })

    }
    
    // *********************************************************************************
    // function to decrement like to review by removing user id into review like list
    // *********************************************************************************
    func DecrementLikeFromUserIdToReviewByMovieIdByOwnerId(userId: String, ownerId: String, movieId: Int, CompletionHandler : @escaping () -> Void) {
        
        // create a reference to the database
        let db = Firestore.firestore()
        
        // create a reference of the review
        let reviewDocRef = db.collection(MovieAppFirebaseConstants.MovieDatabaseAttribute.CollectionID).document(String(movieId)).collection(MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.CollectionID).document(ownerId)
        
        // try to get the data from the review document
        reviewDocRef.getDocument(completion: { (document, error) in
            
            // check if there is error
            if error != nil {
                print("Model/MovieReviewFirebaseModel.swift - func IncrementLikeFromUserIdToReviewByMovieIdByOwnerId()  - \(error)")
            }
            // try to extract the data
            else{
                if let document = document, document.exists {
                    if let reviewDocData = document.data() {
                        let likeList = reviewDocData[MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.LikeUserList] as! [String]
                        
                        //print("Model/MovieReviewFirebaseModel.swift - func IncrementLikeFromUserIdToReviewByMovieIdByOwnerId()  - LikeList:\(likeList)")
                        
                        let tempLikeList = self.removeUserIdFromLikeList(userId: userId, likeList: likeList)
                        
                        // update the like list
                        reviewDocRef.updateData([
                            MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.LikeUserList : tempLikeList
                        ]) { error in
                            if error != nil {
                                print(error)
                            }
                            else{
                                CompletionHandler()
                            }
                        }
                    }
                }   // if let document = document, document.exists
            }
        })  // reviewDocRef.getDocument()
    }
    
    
    // *********************************************************************************
    // function to increment dislike to review by adding user id into review dislike list
    // *********************************************************************************
    func IncrementDislikeFromUserIdToReviewByMovieIdByOwnerId(userId: String, ownerId: String, movieId: Int, CompletionHandler : @escaping () -> Void) {
        
        // create a reference to the database
        let db = Firestore.firestore()
        
        // create a reference of the review
        let reviewDocRef = db.collection(MovieAppFirebaseConstants.MovieDatabaseAttribute.CollectionID).document(String(movieId)).collection(MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.CollectionID).document(ownerId)
        
        // try to get the data from the review document
        reviewDocRef.getDocument(completion: { (document, error) in
            
            // check if there is error
            if error != nil {
                print("Model/MovieReviewFirebaseModel.swift - func IncrementDislikeFromUserIdToReviewByMovieIdByOwnerId() - \(error)")
            }
            // try to extract the data
            else{
                if let document = document, document.exists {
                    if let reviewDocData = document.data() {
                        let dislikeList = reviewDocData[MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.DislikeUserList] as! [String]
                        
                        //print("Model/MovieReviewFirebaseModel.swift - func IncrementDislikeFromUserIdToReviewByMovieIdByOwnerId()  - DislikeList:\(dislikeList)")
                        
                        let tempDislikeList = Array(Set(self.addUserIdToDislikeList(userId: userId, dislikeList: dislikeList)))
                        
                        // update the dislike list
                        reviewDocRef.updateData([
                            MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.DislikeUserList : tempDislikeList
                        ]) { error in
                            if error != nil {
                                print(error)
                            }
                            else{
                                CompletionHandler()
                            }
                        }
                    }
                }   // if let document = document, document.exists
            }
        })

    }
    
    // *********************************************************************************
    // function to decrement dislike to review by removing user id into review dislike list
    // *********************************************************************************
    func DecrementDislikeFromUserIdToReviewByMovieIdByOwnerId(userId: String, ownerId: String, movieId: Int, CompletionHandler : @escaping () -> Void) {
        
        // create a reference to the database
        let db = Firestore.firestore()
        
        // create a reference of the review
        let reviewDocRef = db.collection(MovieAppFirebaseConstants.MovieDatabaseAttribute.CollectionID).document(String(movieId)).collection(MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.CollectionID).document(ownerId)
        
        // try to get the data from the review document
        reviewDocRef.getDocument(completion: { (document, error) in
            
            // check if there is error
            if error != nil {
                print("Model/MovieReviewFirebaseModel.swift - func DecrementDislikeFromUserIdToReviewByMovieIdByOwnerId() - \(error)")
            }
            // try to extract the data
            else{
                if let document = document, document.exists {
                    if let reviewDocData = document.data() {
                        let dislikeList = reviewDocData[MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.DislikeUserList] as! [String]
                        
                        //print("Model/MovieReviewFirebaseModel.swift - func IncrementLikeFromUserIdToReviewByMovieIdByOwnerId() - DislikeList:\(dislikeList)")
                        
                        let tempDislikeList = self.removeUserIdFromDislikeList(userId: userId, dislikeList: dislikeList)
                        
                        // update the like list
                        reviewDocRef.updateData([
                            MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.DislikeUserList : tempDislikeList
                        ]) { error in
                            if error != nil {
                                print(error)
                            }
                        }
                        CompletionHandler()
                    }
                }   // if let document = document, document.exists
            }
        })  // reviewDocRef.getDocument()
    }
    
    // *********************************************************************************
    // function to remove userId from like list
    // *********************************************************************************
    func removeUserIdFromLikeList(userId : String, likeList : [String]) -> [String]{
        let returnList = likeList.filter { $0 != userId }
        return returnList
    }
    
    // *********************************************************************************
    // function to add userId to like list
    // *********************************************************************************
    func addUserIdToLikeList(userId : String, likeList : [String]) -> [String]{
        var returnList : [String] = likeList
        returnList.append(userId)
        returnList = Array(Set(returnList))
        return returnList
    }
    
    
    // *********************************************************************************
    // function to remove userId from dislike list
    // *********************************************************************************
    func removeUserIdFromDislikeList(userId : String, dislikeList : [String]) -> [String]{
        let returnList = dislikeList.filter { $0 != userId }
        return returnList
    }
    
    // *********************************************************************************
    // function to add userId to like dislist
    // *********************************************************************************
    func addUserIdToDislikeList(userId : String, dislikeList : [String]) -> [String]{
        var returnList : [String] = dislikeList
        returnList.append(userId)
        returnList = Array(Set(returnList))
        return returnList
    }
    
    // *********************************************************************************
    // function to check if review is like by user
    // *********************************************************************************
    func isUserIdInLikelistOfReviewByMovieIdByOwnerId(userId : String, movieId : Int, ownerId : String, CompletionHandler : @escaping (Bool?) -> Void) {
        
        // create a reference to database
        let db = Firestore.firestore()
        
        // create a reference of the review
        let reviewDocRef = db.collection(MovieAppFirebaseConstants.MovieDatabaseAttribute.CollectionID).document(String(movieId)).collection(MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.CollectionID).document(ownerId)
        
        // try to get the data from the review document
        reviewDocRef.getDocument(completion: { (document, error) in
            
            // check if there is error
            if error != nil {
                print("Model/MovieReviewFirebaseModel.swift - func isUserIdInLikelistOfReviewByMovieIdByOwnerId() - \(error)")
            }
            // try to extract the data
            else{
                if let document = document, document.exists {
                    if let reviewDocData = document.data() {
                        let likeList = reviewDocData[MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.LikeUserList] as! [String]
                        
                        //print("Model/MovieReviewFirebaseModel.swift - func isUserIdInLikelistOfReviewByMovieIdByOwnerId() -  [userId:\(userId) likeList:\(likeList)]")
                        
                        let isExist = likeList.contains(userId)
                        
                        CompletionHandler(isExist)
                    }
                }   // if let document = document, document.exists
            }
        })  // reviewDocRef.getDocument()
        
    }   // func isUserIdInLikelistOfReviewByMovieIdByOwnerId()
    
    // *********************************************************************************
    // function to check if review is dislike by user
    // *********************************************************************************
    func isUserIdInDislikelistOfReviewByMovieIdByOwnerId(userId : String, movieId : Int, ownerId : String, CompletionHandler : @escaping (Bool?) -> Void) {
        
        // create a reference to database
        let db = Firestore.firestore()
        
        // create a reference of the review
        let reviewDocRef = db.collection(MovieAppFirebaseConstants.MovieDatabaseAttribute.CollectionID).document(String(movieId)).collection(MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.CollectionID).document(ownerId)
        
        // try to get the data from the review document
        reviewDocRef.getDocument(completion: { (document, error) in
            
            // check if there is error
            if error != nil {
                print("Model/MovieReviewFirebaseModel.swift - func isUserIdInDislikelistOfReviewByMovieIdByOwnerId() - \(error)")
            }
            // try to extract the data
            else{
                if let document = document, document.exists {
                    if let reviewDocData = document.data() {
                        let dislikeList = reviewDocData[MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.DislikeUserList] as! [String]
                        
                        //print("Model/MovieReviewFirebaseModel.swift - func isUserIdInDislikelistOfReviewByMovieIdByOwnerId() - [userId:\(userId) dislikeList:\(dislikeList)]")
                        
                        let isExist = dislikeList.contains(userId)
                        
                        CompletionHandler(isExist)
                    }
                }   // if let document = document, document.exists
            }
        })  // reviewDocRef.getDocument()
        
    }   // func isUserIdInLikelistOfReviewByMovieIdByOwnerId()
    
    
    // *********************************************************************************
    // function to get the rating status of a review by userid
    // *********************************************************************************
    func getStatusOfReviewByMovieIdByOwnerIdByUserId(userId : String, movieId : Int, ownerId : String, CompletionHandler : @escaping (MovieAppFirebaseConstants.ReviewRatingStatus?, [Int]) -> Void) {
        
        // create a reference to database
        let db = Firestore.firestore()
        
        // create a reference of the review
        let reviewDocRef = db.collection(MovieAppFirebaseConstants.MovieDatabaseAttribute.CollectionID).document(String(movieId)).collection(MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.CollectionID).document(ownerId)
        
        // try to get the data from the review document
        reviewDocRef.getDocument(completion: { (document, error) in
            
            // check if there is error
            if error != nil {
                print("Model/MovieReviewFirebaseModel.swift - func getStatusOfReviewByMovieIdByOwnerIdByUserId() - \(error)")
            }
            // try to extract the data
            else{
                if let document = document, document.exists {
                    if let reviewDocData = document.data() {
                        
                        // check the status of dislike list
                        let dislikeList = reviewDocData[MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.DislikeUserList] as! [String]
                        let isDislike = dislikeList.contains(userId)
                        let dislikeCount = dislikeList.count
                        
                        // check the status of like list
                        let likeList = reviewDocData[MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.LikeUserList] as! [String]
                        let isLike = likeList.contains(userId)
                        let likeCount = likeList.count
                        
                        // declare the status variable
                        var reviewStatus : MovieAppFirebaseConstants.ReviewRatingStatus!
                        
                        if (isLike == true){
                            reviewStatus = MovieAppFirebaseConstants.ReviewRatingStatus.LIKE
                        }
                        else if (isDislike == true){
                            reviewStatus = MovieAppFirebaseConstants.ReviewRatingStatus.DISLIKE
                        }
                        else if ( isLike == false && isDislike == false) {
                            reviewStatus = MovieAppFirebaseConstants.ReviewRatingStatus.UNRATED
                        }
                        else{
                            // this should never happen
                            print("Model/MovieReviewFirebaseModel.swift - func getStatusOfReviewByMovieIdByOwnerIdByUserId() - ReviewRatingStatus Failed")
                            CompletionHandler(nil, [])
                        }
                        
                        // return the status
                        CompletionHandler(reviewStatus,[likeCount, dislikeCount])
                    }
                }   // if let document = document, document.exists
            }
        })  // reviewDocRef.getDocument()
        
    }   // func isUserIdInLikelistOfReviewByMovieIdByOwnerId()
    
    
    // *********************************************************************************
    // function to get the rating status of a review by userid
    // *********************************************************************************
    func getReviewCountByMovieId(movieId : Int, CompletionHandler : @escaping (Int?) -> Void) {
        // create a reference to database
        let db = Firestore.firestore()
        
        db.collection(MovieAppFirebaseConstants.MovieDatabaseAttribute.CollectionID).document(String(movieId)).collection(MovieAppFirebaseConstants.MovieDatabaseAttribute.ReviewDatabaseAttribute.CollectionID).getDocuments { (querySnapshot, error) in
            
            // check if there is error
            if let error = error {
                print("Model/MovieReviewFirebaseModel.swift - func getReviewCountByMovieId() - \(error)")
                CompletionHandler(0)
            }
            else{
                CompletionHandler(querySnapshot?.count)
            }
        }
    }
    
}
