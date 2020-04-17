//
//  JSONRequestModel.swift
//  CIS_651_Proj_3
//
//  Created by Mengtao Tang on 2/25/20.
//  Copyright © 2020 Mengtao Tang. All rights reserved.
//

import Foundation
import UIKit

class MovieDataBaseModel {
    
    fileprivate var api_key: String = ""
    
    var results: TMDBResult?    // data fetch from the url request
    var viewLink: UITableView?
    let default_poster_path = "/0.jpg"
    
    init(viewLink: UITableView){
        self.viewLink = viewLink
    }
    
    // method to fetch from the json result
    func download_PopularMovie(urlKey: String, completed: @escaping() -> ()){
        
        // construct json string
        let url = URL(string:"https://api.themoviedb.org/3/movie/\(urlKey)?api_key=\(api_key)&language=en-US&page=1")
    
        URLSession.shared.dataTask(with: url!) {
            (data, response, err) in
            if err == nil
            {
                //check request result
                guard let jsondata = data else
                {
                    //print("Error: ", err!)
                    //completed()
                    return
                }
                
                // store the data
                do
                {
                    self.results = try JSONDecoder().decode(TMDBResult.self, from: jsondata)
                    DispatchQueue.main.async
                    {
                            completed()
                    }
                }
                catch
                {
                    print("Error: JSON Downloading Error!")
                }
                
            }
        }.resume()
    }
    
    
    
    
    // method to get the image data from url
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    // method to download image
    func download_Poster(from poster_path: String, imageView: UIImageView) {
        if (poster_path == "/0.jpg"){
            return
        }
        
        let url = URL(string:"https://image.tmdb.org/t/p/w185\(poster_path)")!
        
        //print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            //print(response?.suggestedFilename ?? url.lastPathComponent)
            //print("Download Finished")
            DispatchQueue.main.async() {
                imageView.image = UIImage(data: data)
                //self.viewLink?.reloadData()
            }
        }
    }
}


/*
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
*/
