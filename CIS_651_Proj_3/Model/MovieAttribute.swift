//
//  MovieAttribute.swift
//  CIS_651_Proj_3
//
//  Created by Mengtao Tang on 2/25/20.
//  Copyright © 2020 Mengtao Tang. All rights reserved.
//

import Foundation

// structure to store the information of each movie request
struct MovieInfo: Decodable {
    let id: Int?
    let poster_path: String?
    let title: String?
    let overview: String?

    
    //let genres: [String?] = []
    
    private enum CodingKeys: String, CodingKey {
        case id="id"
        case poster_path="poster_path"
        case title="title"
        case overview="overview"
        
    }
}

struct MovieDetail: Decodable {
    let id: Int?
    let poster_path: String?
    let title: String?
    let popularity: Float?
    let overview: String?
    let genres: [MovieGenreInfo]
    let vote_average: Float?
    let release_date: String?
    
    //let genres: [String?] = []
    
    private enum CodingKeys: String, CodingKey {
        case id="id"
        case poster_path="poster_path"
        case title="title"
        case popularity="popularity"
        case overview="overview"
        case genres="genres"
        case vote_average="vote_average"
        case release_date="release_date"
    }
}

struct MovieImageInfo: Decodable {
    let aspect_ratio: Float?
    let file_path: String?
    
    private enum CodingKeys: String, CodingKey{
        case aspect_ratio="aspect_ratio"
        case file_path="file_path"
    }
}

struct MovieGenreInfo: Decodable {
    let id: Int?
    let name: String?
    
    private enum CodingKeys: String, CodingKey{
        case id="id"
        case name="name"
    }
    
}



struct TMDBResult: Decodable {
    let page: Int?
    let numResults: Int?
    let numPages: Int?
    var results: [MovieInfo]
    
    private enum CodingKeys: String, CodingKey {
        case page,numResults="total_results",numPages="total_pages",results="results"
    }
}

struct MovieImageResult: Decodable {
    let id: Int?
    var backdrops: [MovieImageInfo]
    var posters: [MovieImageInfo]
    
    private enum CodingKeys: String, CodingKey {
        case id="id"
        case backdrops="backdrops"
        case posters="posters"
    }
}
