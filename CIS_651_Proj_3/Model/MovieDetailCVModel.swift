//
//  MovieDetailCollectionViewModel.swift
//  CIS_651_Proj_3
//
//  Created by Mengtao Tang on 2/26/20.
//  Copyright © 2020 Mengtao Tang. All rights reserved.
//

import Foundation
import UIKit

class MovieDetailCVModel{
    fileprivate var api_key: String = "3e8f10a4cd5f8fea677657f9aedb1efd"
    
    var imageResults: MovieImageResult?    // data fetch from the url
    var detailResult: MovieDetail?
    var viewLink: UIView?
    var movieId: Int?
    
    let default_poster_path = "/0.jpg"
    let default_backdrop_path = "/0.jpg"
    
    let base_url_poster = "https://image.tmdb.org/t/p/w342"
    let base_url_backdrops = "https://image.tmdb.org/t/p/w300"
    // constructor of this model
    init(viewLink: UIView, movieId: Int)
    {
        self.viewLink = viewLink
        self.movieId = movieId
    }
    // function to download details of a movie accoridng to the movie id
    func download_MovieDetail(completed: @escaping() -> ()){
        
        // construct json string
        let url = URL(string:"https://api.themoviedb.org/3/movie/\(self.movieId!)?api_key=\(api_key)")
    
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
                
                //print("Start JSON: \(String(describing: self.movieId))" )
                // store the data
                do
                {
                    self.detailResult = try JSONDecoder().decode(MovieDetail.self, from: jsondata)
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
    
    func download_ImageList(completed: @escaping() -> ()){
        
        // construct json string
        let url = URL(string:"https://api.themoviedb.org/3/movie/\( self.movieId!)/images?api_key=\(self.api_key)")
    
        //print(url)
        
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
                
                //print("Start JSON: \(String(describing: self.movieId))" )
                // store the data
                do
                {
                    self.imageResults = try JSONDecoder().decode(MovieImageResult.self, from: jsondata)
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
    
    func generateImageList() -> [String]{
        var tempImgList: [MovieImageInfo] = []
        var returnList: [String] = []
        
        // try to put at most 3 poster and at most 3 backdrop path into the string list
        /*
        if ((imageResults?.backdrops.count)!>=3){
            tempImgList += imageResults?.backdrops.prefix(3) ?? []
        }
        else if (imageResults?.backdrops.count ==2){
            tempImgList += imageResults?.backdrops.prefix(2) ?? []
        }
        */
        tempImgList += imageResults?.backdrops.prefix(6) ?? imageResults?.backdrops.prefix(5) ?? imageResults?.backdrops.prefix(4) ?? []
        tempImgList += imageResults?.backdrops.prefix(3) ?? imageResults?.backdrops.prefix(2) ?? imageResults?.backdrops.prefix(1) ?? []
        
        tempImgList += imageResults?.posters.prefix(6) ?? imageResults?.posters.prefix(5) ?? imageResults?.posters.prefix(4) ?? []
        tempImgList += imageResults?.posters.prefix(3) ?? imageResults?.posters.prefix(2) ?? imageResults?.posters.prefix(1) ?? []
        
        for img in tempImgList {
            returnList.append(img.file_path!)
        }
        
        return returnList
        
    }
    
    // method to get the image data from url
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    // metjod to down load image
    func download_Image(from image_path: String, imageView: UIImageView, category: String) {
        var urlStr: String
        if (category == "POSTER"){
            urlStr = base_url_poster + image_path
        }
        else{
            urlStr = base_url_backdrops + image_path
        }
        let url = URL(string: urlStr)!
        
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
    
    func constructGenresStr(genres: [MovieGenreInfo]) -> String {
        //var returnStr: String = ""
        var strArray: [String] = []
        for genre in genres {
            strArray.append(genre.name!)
        }
        
        let returnStr = (strArray.map{String($0)}).joined(separator: ",")
        
        return returnStr
    }
}
