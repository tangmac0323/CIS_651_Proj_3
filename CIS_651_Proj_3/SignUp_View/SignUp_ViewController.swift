//
//  SignUp_ViewController.swift
//  CIS_651_Proj_3
//
//  Created by Mengtao Tang on 4/12/20.
//  Copyright © 2020 Mengtao Tang. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUp_ViewController: UIViewController{

    @IBOutlet weak var FirstName_TextField: UITextField!
    @IBOutlet weak var LastName_TextField: UITextField!
    @IBOutlet weak var Email_TextField: UITextField!
    @IBOutlet weak var Password_TextField: UITextField!
    @IBOutlet weak var PasswordCheck_TextField: UITextField!
    @IBOutlet weak var ErrorMsg_Label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.EnableTextFieldDelegate()
        self.EnableHideKeyBoardOnTap()
        self.setUpElement()
    }
    
    // Set up element properties before done loading the view
    func setUpElement(){
        
        // make the error msg invisible at start
        self.ErrorMsg_Label.alpha = 0
    }

    // *********************************************************************************
    // check if the fields are valid. if everything is correct, this method return nil
    // or it will return error message
    // *********************************************************************************
    func validateSignUpTextFields() -> String? {
        
        // check if all the fields are filled
        if (FirstName_TextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            LastName_TextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            Email_TextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            Password_TextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            PasswordCheck_TextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            
            return "Please fill all fields"
        }
        
        // check if password is valid
        let cleanedPassword = Password_TextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if AuthenticationModel.isPasswordValid(cleanedPassword) == false {
            return "Please make sure your password is at least 8 characaters, contains a special character and a number."
        }
        
        // check if password is valid
        if (Password_TextField.text != PasswordCheck_TextField.text){
            return "Please re-check your password"
        }
        
        // check if the email is valid
        let cleanEmail = Email_TextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if AuthenticationModel.isEmailValid(cleanEmail) == false {
            return "Please enter a valid email address"
        }
        
        
        
        return nil
    }
    
    // *********************************************************************************
    // fucntion to display the error message
    // *********************************************************************************
    func showErrorMsgLabel(_ message : String) {
        self.ErrorMsg_Label.text = message
        self.ErrorMsg_Label.alpha = 1
    }
    
    // *********************************************************************************
    // fucntion to make segue transition to login screen from sign up screen
    // *********************************************************************************
    func SignUpScreenToLoginScreen() {
        /*
        let loginVC = storyboard?.instantiateViewController(identifier:MovieAppFirebaseConstants.StoryboardId.LoginViewController) as? LoginMenu_ViewController
        
        
        self.view.window?.rootViewController = loginVC
        self.view.window?.makeKeyAndVisible()
         */
        
        navigationController?.popToRootViewController(animated: true)
        
    }
    
    @IBAction func SignUp_Tapped(_ sender: Any) {
        
        // check the sign up text fields
        let error = validateSignUpTextFields()
        
        // check the return value of the validation function
        if error != nil {
            showErrorMsgLabel(error!)
        }
        // create user and add into the firebase authentication database
        else{
            
            // create reference to text field
            let firstname = FirstName_TextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastname = LastName_TextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = Email_TextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = Password_TextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // create user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                // check for errors
                if err != nil {
                    // there is an error when creating user
                    self.showErrorMsgLabel("Error creating user")
                }
                else{
                    let db = Firestore.firestore()
                    //var ref: DocumentReference? = nil
                    
                    // set the document id to be user id
                    db.collection("users").document(result!.user.uid).setData([MovieAppFirebaseConstants.UserDatabaseAttribute.FirstName:firstname, MovieAppFirebaseConstants.UserDatabaseAttribute.LastName:lastname, MovieAppFirebaseConstants.UserDatabaseAttribute.UserID:result!.user.uid, MovieAppFirebaseConstants.UserDatabaseAttribute.EmailAddress:email]) {
                        
                        (error) in
                        
                        // print the error
                        if error != nil {
                            
                            // show error message
                            self.showErrorMsgLabel("Invalid user data")
                        }
                        // go to the master view
                        else{
                            // perform segue to transist to login page
                            self.SignUpScreenToLoginScreen()
                        }
                    }
                    
                    /*
                    db.collection("users").addDocument(data: [Constants.UserDatabaseAttribute.FirstName:firstname, Constants.UserDatabaseAttribute.LastName:lastname, Constants.UserDatabaseAttribute.UserID:result!.user.uid]) {
                        (error) in
                        
                        // print the error
                        if error != nil {
                            
                            // show error message
                            self.showErrorMsgLabel("Invalid user data")
                        }
                        // go to the master view
                        else{
                            // perform segue to transist to login page
                            self.SignUpScreenToLoginScreen()
                        }
                    }
                    */
                    
                }
                
            }
        }
    }
}

// extension for implementation of delegate/layout stuff
extension SignUp_ViewController: UITextFieldDelegate{
    
    // *********************************************************************************
    // fucntion to set the delegate of textfield to view controller
    // *********************************************************************************
    func EnableTextFieldDelegate() {
        self.FirstName_TextField.delegate = self
        self.LastName_TextField.delegate = self
        self.Email_TextField.delegate = self
        self.Password_TextField.delegate = self
        self.PasswordCheck_TextField.delegate = self
    }
    
    // hide the keyboard when click return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
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
