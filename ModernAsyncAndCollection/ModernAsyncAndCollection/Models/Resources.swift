import Foundation

struct Resources<T: Decodable>: Decodable /* Resource */ {
    var message: String?
    var result: OneOrMany<Res>?
    
    var results: [T]? {
        switch result {
        case .one(let result):
            return [result.properties]
        case .many(let resultArray):
            return resultArray.map { $0.properties }
        case .none:
            return nil
        }
        
    }
    
    
    struct Res: Decodable {
        let properties: T
        //        let resultDescription, id, uid: String
        //        let v: Int
    }
    
    static func getFilmsFrom(dict: [String: Any]) -> Resources<Film>? {
        
        let message = dict["message"] as? String
        if let result = dict["result"] as? [[String: Any]] {
            let films: [Film] = result.compactMap{
                guard let props = $0["properties"] as? [String: Any] else { return nil }
                return Film.getFrom(dict: props)}
            return Resources<Film>(message: message,
                                   result: .many(films.map({ Resources<Film>.Res(properties: $0)})))
        }
        else if let result = dict["result"] as? [String: Any] {
            guard let props = result["properties"] as? [String: Any] else { return nil }
            let film = Film.getFrom(dict: props)
            return Resources<Film>(message: message,
                                   result: .one(Resources<Film>.Res(properties: film)))
        }
        else
        { return nil }
        
    }
}

enum OneOrMany<U: Decodable>: Decodable {
    case one(U)
    case many([U])
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(U.self) {
            self = .one(x)
            return
        }
        if let x = try? container.decode([U].self) {
            self = .many(x)
            return
        }
        throw DecodingError.typeMismatch(OneOrMany.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unexpected assosiated type for an enum"))
    }
    // This is for future Encodable conformance
    //    func encode(to encoder: Encoder) throws {
    //        var container = encoder.singleValueContainer()
    //        switch self {
    //        case .one(let x):
    //            try container.encode(x)
    //        case .many(let x):
    //            try container.encode(x)
    //        }
    //    }
}


