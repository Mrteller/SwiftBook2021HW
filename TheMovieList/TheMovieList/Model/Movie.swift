//
//  Movie.swift
//  TheMovieList
//
//  Created by  Paul on 14.01.2022.
//

import Foundation

 struct MoviesResponse: Codable {
     let page: Int
     let totalResults: Int
     let totalPages: Int
     let results: [Movie]
}

 struct Movie: Codable,  Equatable, Hashable {
    
     let id: Int
     let title: String
     let backdropPath: String?
     let posterPath: String?
     let overview: String
     let releaseDate: Date
     let voteAverage: Double
     let voteCount: Int
     let tagline: String?
     let genres: [MovieGenre]?
     let videos: MovieVideoResponse?
     let credits: MovieCreditResponse?
     let adult: Bool
     let runtime: Int?
     var posterURL: URL? {
         guard let posterPath = posterPath else { return nil }
         return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
    
     var backdropURL: URL? {
         guard let backdropPath = backdropPath else { return nil }
         return URL(string: "https://image.tmdb.org/t/p/original\(backdropPath)")
    }
    
     var voteAveragePercentText: String {
        return "\(Int(voteAverage * 10))%"
    }
    
     var ratingText: String {
         let rating = Int(voteAverage)
         let ratingText = (0..<rating).reduce("") { (acc, _) in
             acc + "⭐️" }
         return ratingText
     }

     func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
     static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
}

 struct MovieGenre: Codable {
    let name: String
}

 struct MovieVideoResponse: Codable {
     let results: [MovieVideo]
}

 struct MovieVideo: Codable {
     let id: String
     let key: String
     let name: String
     let site: String
     let size: Int
     let type: String
    
     var youtubeURL: URL? {
        guard site == "YouTube" else {
            return nil
        }
        return URL(string: "https://www.youtube.com/watch?v=\(key)")
    }
}

 struct MovieCreditResponse: Codable {
     let cast: [MovieCast]
     let crew: [MovieCrew]
}

 struct MovieCast: Codable {
     let character: String
     let name: String
}

 struct MovieCrew: Codable {
     let id: Int
     let department: String
     let job: String
     let name: String
}
