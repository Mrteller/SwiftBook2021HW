import Foundation

enum SwapiEndpoint {
    
    case people(_ id: String?, query: [URLQueryItem])
    case films(_ id: String?, query: [URLQueryItem])
    case planets(_ id: String?, query: [URLQueryItem])
    case species(_ id: String?, query: [URLQueryItem])
    case starships(_ id: String?, query: [URLQueryItem])
    case vehicles(_ id: String?, query: [URLQueryItem])
}

extension SwapiEndpoint: Endpoint {
    
    var base: String {
        return "https://www.swapi.tech" // https://swapi.co
    }
    
    var path: String {
        switch self {
        case .people(let id, _): return "/api/people/\(id ?? "")"
        case .films(let id, _): return "/api/films/\(id ?? "")"
        case .planets(let id, _): return "/api/planets/\(id ?? "")"
        case .species(let id, _): return "/api/species/\(id ?? "")"
        case .starships(let id,_): return "/api/starships/\(id ?? "")"
        case .vehicles(let id, _): return "/api/vehicles/\(id ?? "")"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .people(_, let query), .films(_, let query), .planets(_, let query), .species(_, let query), .starships(_, let query), .vehicles(_, let query):
            return query
        }
    }
    
    init?(T: Decodable.Type, id: String?, query: [URLQueryItem]) {
        switch T {
        case is Film.Type: self = .films(id, query: query)
        case is People.Type: self = .people(id, query: query)
        case is Starship.Type: self = .starships(id, query: query)
        case is Vehicle.Type: self = .vehicles(id, query: query)
        case is Species.Type: self = .species(id, query: query)
        case is Planet.Type: self = .planets(id, query: query)
        default: return nil
        }
    }
}
