//
//  Movie_TableViewController.swift
//  CIS_651_Proj_3
//
//  Created by Mengtao Tang on 2/25/20.
//  Copyright © 2020 Mengtao Tang. All rights reserved.
//

import Foundation
import UIKit


class MovieListScreenController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var MovieTableView: UITableView!
    @IBOutlet weak var MovieNavSeg: MovieSegController!
    
    //fileprivate var api_key: String = "3e8f10a4cd5f8fea677657f9aedb1efd"
    
    //var results: TMDBResult?    // data fetch from the url request
    var tmdbModel: MovieDataBaseModel?
    // variables to store data
    //var movies: [MovieCell] = []
    var movieId: Int = 0   // global variable to save the movie id on click
    
    
    override func viewWillAppear(_ animated: Bool) {
        //self.view.layer.allowsGroupOpacity = true
        MovieTableView.backgroundColor = UIColor(white: 1, alpha: 0.3)
    }
    
    // called on the load of the view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MovieTableView.dataSource = self
        MovieTableView.delegate = self
        
        self.tmdbModel = MovieDataBaseModel(viewLink: MovieTableView)
        
        //MovieTableView.estimatedRowHeight = 100
        //MovieTableView.rowHeight = 15 * UIScreen.main.bounds.height /  100      // set the height of each cell to 20% of the main screen
        
        let urlKeyStr = self.MovieNavSeg.getSelectedItemStr()
        //print("JSON STARTED")
        self.tmdbModel?.download_PopularMovie(urlKey: urlKeyStr) {
            //print("Number of Results: ", self.results?.numResults as Any)
            self.MovieTableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
            self.MovieTableView.reloadData()
            //self.navigationItem.title = "Popular"
            //self.MovieTableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieCell")
        }
        
        //print("JSON FNISHED")
    }
    
    // ALLOW TO DELETE
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            self.MovieTableView.beginUpdates()
            self.tmdbModel?.results?.results.remove(at: indexPath.row)
            self.MovieTableView.deleteRows(at: [indexPath], with: .automatic)
            self.MovieTableView.endUpdates()
        }
    }
    
    ///--------------------------------------------------------------------------
    /// Extension of the tableview
    ///--------------------------------------------------------------------------
    
    // function to decide the total row of the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cellRow = self.tmdbModel?.results?.results.count ?? 0
        
        //print(cellRow)
        
        return cellRow
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.MovieTableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell
        //let cell = MovieTableViewCell(style: .default, reuseIdentifier: "MovieCell")

        //cell.MovieTitleLabel.text = "MovieName#"
        //cell.MovieImageView.image = #imageLiteral(resourceName: "TestImage")
        
        /*
        self.TMDBModel!.download_PopularMovie {
            let movie = self.TMDBModel!.results?.results[indexPath.row]
            let movieTitle = movie?.title
            cell.MovieTitleLabel.text = movieTitle
        }
         */
        let movie = self.tmdbModel!.results?.results[indexPath.row]
        let movieTitle = movie?.title
        let poster_path = movie?.poster_path
        let overview = movie?.overview
        cell.MovieTitleLabel.text = movieTitle
        cell.MovieOverviewLabel.text = overview
        cell.backgroundColor = UIColor(white: 1, alpha: 0.3)
        
        //print(poster_path)
        //print("At row: \(indexPath.row)")
        //self.TMDBModel?.download_Poster(imagePostFix: poster_path, to: cell.MovieImageView)
        self.tmdbModel?.download_Poster(from: poster_path ?? (self.tmdbModel?.default_poster_path)!, imageView: cell.MovieImageView)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 15 * UIScreen.main.bounds.height /  100      // set the height of each cell to 15% of the main screen
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.MovieTableView.deselectRow(at: indexPath, animated: true)
        let movie = self.tmdbModel?.results?.results[indexPath.row]
        self.movieId = movie?.id ?? -1
        performSegue(withIdentifier: "ListToDetail", sender: self)
    }

    // prepare for transfer movie id from master view to detail view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ListToDetail"){
            if let destVC = segue.destination as? MovieDetailViewController{
                destVC.movieId = self.movieId
                print(destVC.movieId)
            }
        }
    
    }
    
    
    ///--------------------------------------------------------------------------
    /// End of the Extension of the tableview
    ///--------------------------------------------------------------------------
    
    // function to make react on the tap on the segemeted in navigation bar
    @IBAction func movieSegTapped(_ sender: Any) {
        let urlKeyStr = self.MovieNavSeg.getSelectedItemStr()
        //print("JSON STARTED")
        self.tmdbModel?.download_PopularMovie(urlKey: urlKeyStr) {
            //print("Number of Results: ", self.results?.numResults as Any)
            self.MovieTableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
            self.MovieTableView.reloadData()
            //self.navigationItem.title = "Popular"
            //self.MovieTableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieCell")
        }
    }
    
    
}


