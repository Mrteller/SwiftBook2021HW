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
    
    static func getFrom(dict: [String: Any]) -> Self {
        Film(title: dict["title"] as? String,
             episodeId: dict["episodeId"] as? Int,
             openingCrawl: dict["openingCrawl"] as? String,
             director: dict["director"] as? String,
             producer: dict["producer"] as? String,
             releaseDate: dict["releaseDate"] as? String,
             species: dict["species"] as? [String],
             starships: dict["starships"] as? [String],
             vehicles: dict["vehicles"] as? [String],
             characters: dict["characters"] as? [String],
             planets: dict["planets"] as? [String],
             url: dict["url"] as? String,
             created: dict["created"] as? String,
             edited: dict["edited"] as? String)
    }
}


