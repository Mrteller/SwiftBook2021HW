import Foundation

struct Film: Decodable, Hashable {
    
    var title: String?
    var episodeId: Int?
    var openingCrawl: String?
    var director: String?
    var producer: String?
    var releaseDate: String?
    var species: [String]?
    var starships: [String]?
    var vehicles: [String]?
    var characters: [String]?
    var planets: [String]?
    var url: String?
    var created: String?
    var edited: String?
}


