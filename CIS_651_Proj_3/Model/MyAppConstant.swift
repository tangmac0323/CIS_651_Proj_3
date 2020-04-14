//
//  StoryboardIdConst.swift
//  CIS_651_Proj_3
//
//  Created by Mengtao Tang on 4/12/20.
//  Copyright © 2020 Mengtao Tang. All rights reserved.
//

import Foundation

struct Constants {
    struct StoryboardId {
        static let LoginViewController = "LoginVC"
        static let SignUpViewController = "SignUpVC"
        static let MasterViewController = "MovieListScreenController"
        static let MasterViewTabBarController = "MasterViewTBC"
    }
    
    
    struct UserDatabaseAttribute {
        // title of the collection
        static let Users = "users"
        
        // attribute for each item
        static let EmailAddress = "email"
        static let FirstName = "first_name"
        static let LastName = "last_name"
        static let NickName = "nickname"
        static let UserID = "uid"
        static let CellPhoneNum = "cell_phone_num"
    }
    
}
