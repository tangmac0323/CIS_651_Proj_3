//
//  Review_TableViewCell.swift
//  CIS_651_Proj_3
//
//  Created by Mengtao Tang on 4/15/20.
//  Copyright © 2020 Mengtao Tang. All rights reserved.
//

import Foundation
import UIKit

class ReviewTableViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var UserPortrait_ImageView: UIImageView!
    
    @IBOutlet weak var Nickname_Label: UILabel!
    @IBOutlet weak var Date_Label: UILabel!
    @IBOutlet weak var ReviewContent_TextView: UITextView!
    
    @IBOutlet weak var RatingLike_ImageView: UIImageView!
    @IBOutlet weak var RatingLike_Label: UILabel!
    
    @IBOutlet weak var RatingDislike_ImageView: UIImageView!
    @IBOutlet weak var RatingDislike_Label: UILabel!
    
    
    
    //var userId : String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ReviewContent_TextView.delegate = self
        
        Nickname_Label.backgroundColor = UIColor(white: 1, alpha: 0.3)
        Date_Label.backgroundColor = UIColor(white: 1, alpha: 0.3)
        ReviewContent_TextView.backgroundColor = UIColor(white: 1, alpha: 0.3)
        //ReviewContent_TextView.translatesAutoresizingMaskIntoConstraints = true
        //ReviewContent_TextView.sizeToFit()
        //ReviewContent_TextView.isScrollEnabled = false
        
        self.layer.borderColor = UIColor.orange.cgColor
        self.layer.borderWidth = 4.0
        self.layer.masksToBounds = true
    }
    
    func adjustUITextViewHeight() {
        ReviewContent_TextView.translatesAutoresizingMaskIntoConstraints = true
        ReviewContent_TextView.sizeToFit()
        ReviewContent_TextView.isScrollEnabled = false
    }
    
    // set the rating imageview image
    func setRatingImageByReviewStatus(reviewStatus : MovieAppFirebaseConstants.ReviewRatingStatus){
        switch reviewStatus {
        case MovieAppFirebaseConstants.ReviewRatingStatus.LIKE:
            self.RatingLike_ImageView.isUserInteractionEnabled = true
            self.RatingLike_ImageView.image = UIImage(systemName: "hand.thumbsup.fill")
            
            self.RatingDislike_ImageView.isUserInteractionEnabled = false
            self.RatingDislike_ImageView.image = UIImage(systemName: "hand.thumbsdown")
            
        case MovieAppFirebaseConstants.ReviewRatingStatus.DISLIKE:
            self.RatingLike_ImageView.isUserInteractionEnabled = false
            self.RatingLike_ImageView.image = UIImage(systemName: "hand.thumbsup")
            
            self.RatingDislike_ImageView.isUserInteractionEnabled = true
            self.RatingDislike_ImageView.image = UIImage(systemName: "hand.thumbsdown.fill")
            
        case MovieAppFirebaseConstants.ReviewRatingStatus.UNRATED:
            self.RatingLike_ImageView.isUserInteractionEnabled = true
            self.RatingLike_ImageView.image = UIImage(systemName: "hand.thumbsup")
            
            self.RatingDislike_ImageView.isUserInteractionEnabled = true
            self.RatingDislike_ImageView.image = UIImage(systemName: "hand.thumbsdown")
            
        default:
            print("Review_View/Review_TableViewCell.swift - func setRatingImageByReviewStatus() - Unexpected Review Status")
        }
    }
    
    // set the lable to display the review rating count
    func setReviewRatingCount(countArray : [Int]) {
        self.RatingLike_Label.text = String(countArray[0])
        self.RatingDislike_Label.text = String(countArray[1])
    }
}

