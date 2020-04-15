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
import FirebaseStorage

class UserProfile_ViewController: UIViewController {
    
    @IBOutlet weak var FirstName_TextField: UITextField!
    @IBOutlet weak var LastName_TextField: UITextField!
    @IBOutlet weak var NickName_TextField: UITextField!
    @IBOutlet weak var MobileNum_TextField: UITextField!
    @IBOutlet weak var Email_TextField: UITextField!
    @IBOutlet weak var UserProfilePortrait_ImageView: UIImageView!
    
    @IBOutlet weak var EditProfile_Button: UIButton!
    @IBOutlet weak var SignOut_Button: UIButton!
    
    
    // flag to show if in editing mode
    var EditingTextFieldFlag : Bool = false {
        didSet {
            FirstName_TextField.backgroundColor = EditingTextFieldFlag ? UIColor.white : UIColor.lightGray
            LastName_TextField.backgroundColor = EditingTextFieldFlag ? UIColor.white : UIColor.lightGray
            NickName_TextField.backgroundColor = EditingTextFieldFlag ? UIColor.white : UIColor.lightGray
            MobileNum_TextField.backgroundColor = EditingTextFieldFlag ? UIColor.white : UIColor.lightGray
        }
    } // change the background color of the text field
    
    let EditProfileButtonTitleText = "Edit Profile"     // text to show for edit profile button when in reading mode
    let SaveProfileButtonTittleText = "Save Profile"    // text to show for edit profile button when in editing mode
    
    var GlobalUploadImageURL : URL!    // store the upload image URL
    var GlobalUserPortraitChangeFlag : Int = 0
    
    let userProfileFirebaseModel = UserProfileFirebaseModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.EnableTextFieldDelegate()
        
        self.EnableHideKeyBoardOnTap()
        self.EnableUploadImageOnTap(targetView : self.UserProfilePortrait_ImageView)
        
        self.DisableAllTextFieldEditable()
        
        //loadUserInfoFromDB()
        //DownloadImageFromFirebaseStorage(userId: Auth.auth().currentUser!.uid, imageView: self.UserProfilePortrait_ImageView)
        self.reloadViewData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    // *********************************************************************************
    // fucntion to reload the view data
    // *********************************************************************************
    func reloadViewData() {
        loadUserInfoFromDB()
        self.userProfileFirebaseModel.DownloadImageFromFirebaseStorage(userId: Auth.auth().currentUser!.uid, imageView: self.UserProfilePortrait_ImageView)
        
        // lay down the upload flag
        self.GlobalUserPortraitChangeFlag = 0
    }
    
    // *********************************************************************************
    // fucntion to upload the view data
    // *********************************************************************************
    func uploadViewData(completionHandler: (_ success:Bool) -> Void) {
        self.updateTextFieldContentToDatabase()
        
        if (self.GlobalUserPortraitChangeFlag == 1) {
            self.userProfileFirebaseModel.UploadImageToFirebaseStorage(userId: Auth.auth().currentUser!.uid, imageURL: self.GlobalUploadImageURL)
        }

        
        let flag = true
        completionHandler(flag)
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
            let docRef = db.collection(MovieAppFirebaseConstants.UserDatabaseAttribute.CollectionID).document(userId)
            
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
                            if let firstName = userInfo[MovieAppFirebaseConstants.UserDatabaseAttribute.FirstName] {
                                self.FirstName_TextField.text? = firstName as! String
                            }
                            
                            // display last name
                            if let lastName = userInfo[MovieAppFirebaseConstants.UserDatabaseAttribute.LastName] {
                                self.LastName_TextField.text? = lastName as! String
                            }
                            
                            // display nickname
                            if let nickName = userInfo[MovieAppFirebaseConstants.UserDatabaseAttribute.NickName] {
                                self.NickName_TextField.text? = nickName as! String
                            }
                            // display mobile number
                                if let mobileNum = userInfo[MovieAppFirebaseConstants.UserDatabaseAttribute.MobileNum] {
                                self.MobileNum_TextField.text? = mobileNum as! String
                            }
                            // display email
                            if let emailAddr = userInfo[MovieAppFirebaseConstants.UserDatabaseAttribute.EmailAddress] {
                                self.Email_TextField.text? = emailAddr as! String
                            }
                        }
                    }
                }

            }   // docRef
            
        }
    }
    
    // *********************************************************************************
    // fucntion to make transition from user profile view to login view
    // *********************************************************************************
    func UserProfileScreenToLoginScreen() {
        let loginVC = storyboard?.instantiateViewController(identifier:MovieAppFirebaseConstants.StoryboardId.LoginViewController) as? LoginMenu_ViewController
        
        
        self.view.window?.rootViewController = loginVC
        self.view.window?.makeKeyAndVisible()
    }
    
    
    
    // *********************************************************************************
    // update the database with the content of the textfield
    // *********************************************************************************
    func updateTextFieldContentToDatabase() {
        
        let collectionToUpdate = MovieAppFirebaseConstants.UserDatabaseAttribute.CollectionID
        
        let docToUpdate = Auth.auth().currentUser!.uid
        
        let dataChangeList = [MovieAppFirebaseConstants.UserDatabaseAttribute.FirstName : self.FirstName_TextField.text!,
                          MovieAppFirebaseConstants.UserDatabaseAttribute.LastName : self.LastName_TextField.text!,
                          MovieAppFirebaseConstants.UserDatabaseAttribute.MobileNum : self.MobileNum_TextField.text!,
                          MovieAppFirebaseConstants.UserDatabaseAttribute.NickName : self.NickName_TextField.text!]
        
        self.userProfileFirebaseModel.UpdateTextFieldContentToDatabase(data: dataChangeList, collection: collectionToUpdate, document: docToUpdate)
        
        /*
        // update first name
        self.movieAppFirebaseModel.UpdateTextFieldContentToDatabase(textField: self.FirstName_TextField, collection: collectionToUpdate, document: docToUpdate, field: MovieAppFirebaseConstants.UserDatabaseAttribute.FirstName)
        
        // update last name
        self.movieAppFirebaseModel.UpdateTextFieldContentToDatabase(textField: self.LastName_TextField, collection: collectionToUpdate, document: docToUpdate, field: MovieAppFirebaseConstants.UserDatabaseAttribute.LastName)
        
        // update mobile number
        self.movieAppFirebaseModel.UpdateTextFieldContentToDatabase(textField: self.MobileNum_TextField, collection: collectionToUpdate, document: docToUpdate, field: MovieAppFirebaseConstants.UserDatabaseAttribute.MobileNum)
        
        // update nickname
        self.movieAppFirebaseModel.UpdateTextFieldContentToDatabase(textField: self.MobileNum_TextField, collection: collectionToUpdate, document: docToUpdate, field: MovieAppFirebaseConstants.UserDatabaseAttribute.NickName)
         */
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
        
        //let userId = Auth.auth().currentUser?.uid
        
        let firebaseAuth = Auth.auth()
        
        do {
            // sign out
            try firebaseAuth.signOut()
            // navigate back to login menu
            self.UserProfileScreenToLoginScreen()
            
            //print(Auth.auth().currentUser?.uid)
            
        }catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
    }
    
    
    @IBAction func EditProfileButton_Tapped(_ sender: Any) {
        
        // check the editing flag
        // raise the editing flag if not in edit mode
        if (self.EditingTextFieldFlag == false ){
            
            self.EditingTextFieldFlag = true
            
            // turn on edit mode for user profile view
            self.EnableAllTextFieldEditable()
            
            // change the text of the button to Save
            self.EditProfile_Button.setTitle(self.SaveProfileButtonTittleText, for: .normal)
        }
        // lay the flag when the editing is done
        else{
            
            self.EditingTextFieldFlag = false
            
            // turn off the edit mode
            self.DisableAllTextFieldEditable()
            
            // change the text of the button to Edit Profile
            self.EditProfile_Button.setTitle(self.EditProfileButtonTitleText, for: .normal)
            
            // save all the change to the firebase database
            //movieAppFirebaseModel.UploadImageToFirebaseStorage(userId: Auth.auth().currentUser!.uid, imageURL: self.GlobalUploadImageURL)
            self.uploadViewData(completionHandler: { _ in
                
                //reload the view data by downloading them from the db
                self.reloadViewData()
                
            })
            
        }
        // make all the textfield except email editable
    }
    
    
    
}



// extension for implementation of delegate/layout stuff
extension UserProfile_ViewController: UITextFieldDelegate {
    
    // *********************************************************************************
    // fucntion to set the delegate of textfield to view controller
    // *********************************************************************************
    func EnableTextFieldDelegate() {
        self.Email_TextField.delegate = self
        self.FirstName_TextField.delegate = self
        self.LastName_TextField.delegate = self
        self.NickName_TextField.delegate = self
        self.MobileNum_TextField.delegate = self
        
        Email_TextField.backgroundColor = UIColor.lightGray
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
    func DisableAllTextFieldEditable() {
        self.FirstName_TextField.isUserInteractionEnabled = false
        self.LastName_TextField.isUserInteractionEnabled = false
        self.Email_TextField.isUserInteractionEnabled = false
        self.NickName_TextField.isUserInteractionEnabled = false
        self.MobileNum_TextField.isUserInteractionEnabled = false
        self.UserProfilePortrait_ImageView.isUserInteractionEnabled = false
    }
    
    // *********************************************************************************
    // fucntion to make all textfield editable
    // *********************************************************************************
    func EnableAllTextFieldEditable() {
        self.FirstName_TextField.isUserInteractionEnabled = true
        self.LastName_TextField.isUserInteractionEnabled = true
        self.Email_TextField.isUserInteractionEnabled = false
        self.NickName_TextField.isUserInteractionEnabled = true
        self.MobileNum_TextField.isUserInteractionEnabled = true
        self.UserProfilePortrait_ImageView.isUserInteractionEnabled = true
    }
    
}

// extension for UIImagePicker
extension UserProfile_ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // *********************************************************************************
    // add action to image view tapped
    // *********************************************************************************
    func EnableUploadImageOnTap(targetView : UIView) {
        let tap = UITapGestureRecognizer(target : self, action : #selector(UserPortraitImageTapped(tap:)))
        //self.UserProfilePortrait_ImageView.addGestureRecognizer(tap)
        targetView.addGestureRecognizer(tap)
    }
    
    // argument is the tap action, which could allow to reach the tapped view
    @objc func UserPortraitImageTapped(tap: UITapGestureRecognizer){
        
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    // *********************************************************************************
    // pick the image from camera roll
    // *********************************************************************************
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        guard let imageURL = info[.imageURL] as? URL else { return }
        //print(imageURL)
        dismiss(animated: true) {
            
            // check if the image is oversize
            if (Int(self.userProfileFirebaseModel.GetImageSizeInKB(info: info)) >= MovieAppFirebaseConstants.UserDatabaseAttribute.MaxUploadImageSize) {
                print("UserProfile_View/UserProfile_ViewController.swift - func imagePickerController() - Upload Image Oversize")
                return
            }
            
            // upload the image into fire store with correct name
            //self.UploadImageToFirebaseStorage(userId: Auth.auth().currentUser!.uid, imageURL: imageURL)
            // update the global image url
            self.GlobalUploadImageURL = imageURL
            self.GlobalUserPortraitChangeFlag = 1
            
            // display the image to the image view
            self.userProfileFirebaseModel.DisplayImageFromLocalURL(imageView: self.UserProfilePortrait_ImageView, imageURL: imageURL)
        }
        
        //print("UserProfile_View/UserProfile_ViewController.swift - func imagePickerController() - Dismiss Succeed")
        
    }
    
}
