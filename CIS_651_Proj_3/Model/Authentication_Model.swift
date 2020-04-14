//
//  Authentication_Model.swift
//  CIS_651_Proj_3
//
//  Created by Mengtao Tang on 4/12/20.
//  Copyright © 2020 Mengtao Tang. All rights reserved.
//

import Foundation

class AuthenticationModel {
    
    // check if the password match the requirement
    static func isPasswordValid(_ password : String) -> Bool {
        
        let regularExpression = "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"

        let passwordValidation = NSPredicate.init(format: "SELF MATCHES %@", regularExpression)
        
        return passwordValidation.evaluate(with: password)
    }
    
    // check if the email format is correct
    static func isEmailValid(_ email : String) -> Bool {

          let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

          let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)

          return emailTest.evaluate(with: email)

      }
}
