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
    @IBOutlet weak var ReviewContent_TextView: UITextView!
    
    @IBOutlet weak var RatingLike_ImageView: UIImageView!
    @IBOutlet weak var RatingLike_Label: UILabel!
    
    @IBOutlet weak var RatingDislike_ImageView: UIImageView!
    @IBOutlet weak var RatingDislike_Label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ReviewContent_TextView.delegate = self
        ReviewContent_TextView.translatesAutoresizingMaskIntoConstraints = true
        ReviewContent_TextView.sizeToFit()
        ReviewContent_TextView.isScrollEnabled = false
    }
    
    func adjustUITextViewHeight(textView : UITextView) {
        textView.translatesAutoresizingMaskIntoConstraints = true
        textView.sizeToFit()
        textView.isScrollEnabled = false
    }
    
}
