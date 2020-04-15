//
//  StoryboardIdConst.swift
//  CIS_651_Proj_3
//
//  Created by Mengtao Tang on 4/12/20.
//  Copyright © 2020 Mengtao Tang. All rights reserved.
//

import Foundation

struct MovieAppFirebaseConstants {
    struct StoryboardId {
        static let LoginViewController = "LoginVC"
        static let SignUpViewController = "SignUpVC"
        static let MasterViewController = "MovieListScreenController"
        static let MasterViewTabBarController = "MasterViewTBC"
    }
    
    
    struct UserDatabaseAttribute {
        // title of the collection
        static let CollectionID = "users"
        
        // attribute for each item
        static let EmailAddress = "email"
        static let FirstName = "first_name"
        static let LastName = "last_name"
        static let NickName = "nickname"
        static let UserID = "uid"
        static let MobileNum = "mobile_num"
        
        static let UserProfilePortraitPathPrefix = "UserPortraitImages/"
        static let UserProfilePortraitFilePrefix = "UserProfilePortraitImage_"
        static let UserProfilePortraitFileType = ".jpeg"
        
        static let MaxUploadImageSize = 15 * 1024 * 1024   // maximum upload image size is 15MB
    }
    
    
    struct MovieDatabaseAttribute {
        
        static let CollectionID = "movies"
        
        static let SubCollectionID_Review = "reviews"
        static let ReviewCounts = "review_counts"
        
        // struct for sub collection
        struct ReviewDatabaseAttribute {
            
            static let CollectionID = "reviews"
            
            static let Date = "date"
            static let Content = "content"
            static let UserId = "userId"
            //static let Counts = "counts"
            static let LikeUserList = "like_user_list"
            static let DisUserlikeList = "dislike_user_list"
        }
    }
}
