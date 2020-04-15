//
//  Review_TablerViewController.swift
//  CIS_651_Proj_3
//
//  Created by Mengtao Tang on 4/12/20.
//  Copyright © 2020 Mengtao Tang. All rights reserved.
//

import UIKit

class Review_TablerViewController: UITableViewController {
    
    // declare reusable identifier
    let ReusableCellIdentifier = "ReviewTableReuseCell"
    
    // declare the model
    let userProfileFirebaseModel = UserProfileFirebaseModel()
    let movieFireBaseModel = MovieFirebaseModel()
    
    // declare movieId
    var MovieId : Int = -1

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }

    ///--------------------------------------------------------------------------
    /// Extension of the tableview
    ///--------------------------------------------------------------------------

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    // function to decide the total row of the table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var numOfRowInSection : Int = 10
        
        //numOfSection = movieFireBaseModel.RetrieveReviewNumByMovieId(movieId: self.MovieId)
        
        print("Review_TableViewController - func numOfSections() - numOfRowInSection: \(numOfRowInSection)")
        
        return numOfRowInSection
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.ReusableCellIdentifier, for: indexPath) as! ReviewTableViewCell
        
        // Configure the cell...

        return cell
    }
    
    /*
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return       // set the height of each cell to 15% of the main screen
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
