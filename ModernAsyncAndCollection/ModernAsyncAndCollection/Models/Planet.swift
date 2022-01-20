import Foundation

struct Planet: Decodable {
    
    var name: String?
    var diameter: String?
    var rotationPeriod: String?
    var orbitalPeriod: String?
    var gravity: String?
    var population: String?
    var climate: String?
    var terrain: String?
    var surfaceWater: String?
    var residents: [String]?
    var films: [String]?
    var url: String?
    var created:String?
    var edited: String?
}
