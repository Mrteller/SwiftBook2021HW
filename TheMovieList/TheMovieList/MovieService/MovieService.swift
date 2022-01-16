//
//  MovieService.swift
//  TheMovieList
//
//  Created by  Paul on 14.01.2022.
//

import Foundation

enum Endpoint: String, CustomStringConvertible, CaseIterable {
    case nowPlaying = "now_playing"
    case upcoming
    case popular
    case topRated = "top_rated"
    
    var description: String {
        switch self {
        case .nowPlaying: return "Now Playing"
        case .upcoming: return "Upcoming"
        case .popular: return "Popular"
        case .topRated: return "Top Rated"
        }
    }
    
    
    init?(index: Int) {
        switch index {
        case 0: self = .nowPlaying
        case 1: self = .popular
        case 2: self = .upcoming
        case 3: self = .topRated
        default: return nil
        }
    }
    
    init?(description: String) {
        guard let first = Endpoint.allCases.first(where:{ $0.description == description }) else {
            return nil
        }
        self = first
    }
}

