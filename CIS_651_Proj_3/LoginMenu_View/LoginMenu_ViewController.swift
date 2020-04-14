//
//  LoginMenu_ViewController.swift
//  CIS_651_Proj_3
//
//  Created by Mengtao Tang on 4/12/20.
//  Copyright © 2020 Mengtao Tang. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginMenu_ViewController: UIViewController {

    // Declare outlets
    @IBOutlet weak var Email_TextField: UITextField!
    @IBOutlet weak var Password_TextField: UITextField!
    @IBOutlet weak var Login_Button: UIButton!
    @IBOutlet weak var SignUp_Button: UIButton!
    @IBOutlet weak var ErrorMsg_Label: UILabel!
    
    // overDidLoad function
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
    // fucntion to make segue transition to master screen from login screen
    // *********************************************************************************
    func LoginScreenToMasterScreen() {
        let masterViewTBController = self.storyboard?.instantiateViewController(identifier: Constants.StoryboardId.MasterViewTabBarController) as? UITabBarController
        
        self.view.window?.rootViewController = masterViewTBController
        self.view.window?.makeKeyAndVisible()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func LoginButton_Tapped(_ sender: Any) {
        
        // extract the user input
        let email = Email_TextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = Password_TextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            // handle when failed login
            if error != nil {
                self.ErrorMsg_Label.text = "Invalid email/password match"
                self.Password_TextField.text = ""
                self.ErrorMsg_Label.alpha = 1
            }
                // login the user if everything is right
            else{
                self.LoginScreenToMasterScreen()
            }
        }
        
    }
    
    @IBAction func SignUpButton_Tapped(_ sender: Any) {
    }
}


// extension for implementation of delegate/layout stuff
extension LoginMenu_ViewController: UITextFieldDelegate{
    
    // *********************************************************************************
    // fucntion to set the delegate of textfield to view controller
    // *********************************************************************************
    func EnableTextFieldDelegate() {
        self.Email_TextField.delegate = self
        self.Password_TextField.delegate = self
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
