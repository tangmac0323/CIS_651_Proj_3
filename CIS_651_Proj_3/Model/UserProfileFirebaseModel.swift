//
//  MovieAppFirebaseModel.swift
//  CIS_651_Proj_3
//
//  Created by Mengtao Tang on 4/14/20.
//  Copyright © 2020 Mengtao Tang. All rights reserved.
//

import Foundation
import Firebase

class UserProfileFirebaseModel {
    
    // *********************************************************************************
    // extract nick name by user id from users collection
    // *********************************************************************************
    func GetNickNameFromFirebaseByUserId(userId : String, CompletionHandler : @escaping (String?, Error?) -> Void) {
        
    }
    
    // *********************************************************************************
    // upload image from camera roll
    // *********************************************************************************
    func UploadImageToFirebaseStorage(userId : String, imageURL : URL){
        
        // get a reference to the storage service
        let storage = Storage.storage()
         
        // create a storage reference from the service
        let storageRef = storage.reference()
        
        // create image path string used in the storage
        let imagePath = MovieAppFirebaseConstants.UserDatabaseAttribute.UserProfilePortraitPathPrefix + MovieAppFirebaseConstants.UserDatabaseAttribute.UserProfilePortraitFilePrefix + Auth.auth().currentUser!.uid + MovieAppFirebaseConstants.UserDatabaseAttribute.UserProfilePortraitFileType
        
        // create a reference to the file upload
        let uploadImageRef = storageRef.child(imagePath)
        
        // upload the file to the storage path
        uploadImageRef.putFile(from: imageURL, metadata: nil) { (metadata, error) in
            
            guard let metadata = metadata else {
                print("Model/UserProfileFirebaseModel.swift - func UploadImageToFirebaseStorage() - Upload Failed")
                print(error as Any)
                return
            }
        }
    }
    
    
    
    // *********************************************************************************
    // download image from fire store
    // *********************************************************************************
    func DownloadImageFromFirebaseStorage(userId : String, imageView : UIImageView) {
        
        // get a reference to the storage service
        let storage = Storage.storage()
        
        // create a storage reference from the service
        let storageRef = storage.reference()
        
        // create image path string
        let imagePath = MovieAppFirebaseConstants.UserDatabaseAttribute.UserProfilePortraitPathPrefix + MovieAppFirebaseConstants.UserDatabaseAttribute.UserProfilePortraitFilePrefix + Auth.auth().currentUser!.uid + MovieAppFirebaseConstants.UserDatabaseAttribute.UserProfilePortraitFileType
        
        // try to download the file and display in the image view
        storageRef.child(imagePath).getData(maxSize: Int64(MovieAppFirebaseConstants.UserDatabaseAttribute.MaxUploadImageSize)) { (image, error) in
            
            // check the error code
            if let error = error {
                print("Model/UserProfileFirebaseModel.swift - func DownloadImageFromFirebaseStorage() - Download Failed\n\(error)")
            }
            else{
                
                // display the image and set the image
                imageView.image = UIImage(data: image!)
                imageView.layer.cornerRadius = (imageView.frame.size.width ?? 0.0) / 2
                imageView.clipsToBounds = true
                imageView.layer.borderWidth = 1.0
                imageView.layer.borderColor = UIColor.white.cgColor
                //print("UserProfile_View/UserProfile_ViewController.swift - func DownloadImageFromFirebaseStorage() - Download Succeed")
            }
        }
        
    }
    
    
    // *********************************************************************************
    // display image from camera roll
    // *********************************************************************************
    func DisplayImageFromLocalURL(imageView : UIImageView, imageURL : URL){
        do {
            let imageData = try Data(contentsOf: imageURL)
            imageView.image = UIImage(data : imageData)
        } catch {
            print("Model/UserProfileFirebaseModel.swift - func DisplayImageFromLocalURL() - Error Loading Image : \(error)")
        }
    }
    
    // *********************************************************************************
    // get image size
    // *********************************************************************************
    func GetImageSizeInKB(info : [UIImagePickerController.InfoKey : Any]) -> Double {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let imageData = NSData(data: image.jpegData(compressionQuality: 1)!)
        let imageSize = Double(imageData.count)/1000.0
        
        print("Model/UserProfileFirebaseModel.swift - func GetImageSize() - \(imageSize) KB")
        
        return imageSize
    }
    
    
    // *********************************************************************************
    // update the database with the content of the textfield
    // *********************************************************************************
    
    /*
    func UpdateTextFieldContentToDatabase(textField : UITextField, collection: String, document: String, field: String) {
        // create a reference to the firestore
        let db = Firestore.firestore()
        
        // check if logged in
        if let userId = Auth.auth().currentUser?.uid{
            
            // get the document reference
            let docRef = db.collection(collection).document(document).setData([
                field : textField.text!
            ]) {
                error in
                if let error = error {
                    print("Model/MovieAppFirebaseModel.swift - func UpdateTextFieldContentToDatabase() - Faield to update dababase\(collection)/\(document)/\(field)")
                }
            }
        }
    }
     */
    func UpdateTextFieldContentToDatabase(data : [String : Any], collection: String, document: String) {
        // create a reference to the firestore
        let db = Firestore.firestore()
        
        // check if logged in
        if let userId = Auth.auth().currentUser?.uid{
            
            // get the document reference
            let docRef = db.collection(collection).document(document).updateData(data) {
                error in
                if let error = error {
                    print("Model/UserProfileFirebaseModel.swift - func UpdateTextFieldContentToDatabase() - Faield to update dababase\(collection)/\(document)\n\(error)")
                }
            }
        }
    }
}

