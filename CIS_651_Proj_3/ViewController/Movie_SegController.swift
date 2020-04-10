//
//  MovieSegController.swift
//  CIS_651_Proj_3
//
//  Created by Mengtao Tang on 2/29/20.
//  Copyright © 2020 Mengtao Tang. All rights reserved.
//

import Foundation
import UIKit

class MovieSegController: UISegmentedControl{
    func getSelectedItemStr() -> String{
        let selectedIndex = self.selectedSegmentIndex
        
        switch(selectedIndex){
        case 0:
            return "popular"
        
        case 1:
            return "top_rated"
            
        case 2:
            return "now_playing"
            
        case 3:
            return "upcoming"
            
        default:
            return "popular"
        }
    }
}
