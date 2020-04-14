//
//  UserProfile_ViewController.swift
//  CIS_651_Proj_3
//
//  Created by Mengtao Tang on 4/11/20.
//  Copyright © 2020 Mengtao Tang. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class UserProfile_ViewController: UIViewController {
    
    @IBOutlet weak var FirstName_TextField: UITextField!
    @IBOutlet weak var LastName_TextField: UITextField!
    @IBOutlet weak var NickName_TextField: UITextField!
    @IBOutlet weak var MobileNum_TextField: UITextField!
    @IBOutlet weak var Email_TextField: UITextField!
    
    @IBOutlet weak var SignOut_Button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //loadUserInfoFromDB()
        self.EnableTextFieldDelegate()
        self.EnableHideKeyBoardOnTap()
        self.MakeAllTextFieldUnEditable()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        loadUserInfoFromDB()
    }
    
    
    // *********************************************************************************
    // fucntion to load user information from the database on loading
    // *********************************************************************************
    func loadUserInfoFromDB() {
        
        // create a reference to the firestore
        let db = Firestore.firestore()
        
        // check if logged in
        if let userId = Auth.auth().currentUser?.uid{
            
            // get the document reference
            let docRef = db.collection(Constants.UserDatabaseAttribute.Users).document(userId)
            
            // access the document
            docRef.getDocument { (document, error) in
                
                // catch the error
                if error != nil {
                    print(error as Any)
                }
                else{
                    // extract the user information from the query
                    if let document = document, document.exists {
                        
                        // check if there is data in the document
                        if let userInfo = document.data() {
                            // display first name
                            if let firstName = userInfo[Constants.UserDatabaseAttribute.FirstName] {
                                self.FirstName_TextField.text? = firstName as! String
                            }
                            
                            // display last name
                            if let lastName = userInfo[Constants.UserDatabaseAttribute.LastName] {
                                self.LastName_TextField.text? = lastName as! String
                            }
                            
                            // display nickname
                            if let nickName = userInfo[Constants.UserDatabaseAttribute.NickName] {
                                self.NickName_TextField.text? = nickName as! String
                            }
                            // display mobile number
                                if let mobileNum = userInfo[Constants.UserDatabaseAttribute.CellPhoneNum] {
                                self.MobileNum_TextField.text? = mobileNum as! String
                            }
                            // display email
                            if let emailAddr = userInfo[Constants.UserDatabaseAttribute.NickName] {
                                self.Email_TextField.text? = emailAddr as! String
                            }
                        }
                    }
                }

            }   // docRef
            
        }

        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func SignOutButton_Tapped(_ sender: Any) {
        let userId = Auth.auth().currentUser?.uid
        print(userId!)
    }
    
    
    
    
}



// extension for implementation of delegate/layout stuff
extension UserProfile_ViewController: UITextFieldDelegate{
    
    // *********************************************************************************
    // fucntion to set the delegate of textfield to view controller
    // *********************************************************************************
    func EnableTextFieldDelegate() {
        self.Email_TextField.delegate = self
        self.FirstName_TextField.delegate = self
        self.LastName_TextField.delegate = self
        self.NickName_TextField.delegate = self
        self.MobileNum_TextField.delegate = self
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
    
    
    // *********************************************************************************
    // fucntion to make all textfield un-editable at the start
    // *********************************************************************************
    func MakeAllTextFieldUnEditable() {
        self.FirstName_TextField.isUserInteractionEnabled = false
        self.LastName_TextField.isUserInteractionEnabled = false
        self.Email_TextField.isUserInteractionEnabled = false
        self.NickName_TextField.isUserInteractionEnabled = false
        self.MobileNum_TextField.isUserInteractionEnabled = false
    }
}
