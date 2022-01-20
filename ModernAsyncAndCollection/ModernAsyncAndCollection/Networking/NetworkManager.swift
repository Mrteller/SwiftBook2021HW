//
//  NetworkManager.swift
//  ModernAsyncAndCollection
//
//  Created by  Paul on 20.01.2022.
//

import Foundation
import Alamofire

final class NetworkManager {
// MARK: - Public vars
    
static let shared = NetworkManager()

// MARK: - Initializers

private init() {}
    
    
    // MARK: - Public funcs
    
    /// regular JSON decoding with modern concurensy
    func fetchAndDecode<D: Decodable>(url: URL) async throws -> D {
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedData = try JSONDecoder().decode(D.self, from: data)
        return decodedData
    }
    
    /// regular JSON decoding using generalized endpoint calculation with modern concurensy
    func fetchResource<U: Decodable>(_ value: Resources<U>.Type, id: String? = nil, query: [URLQueryItem] = []) async -> (Result<Resources<U>, Error>) {
        
        guard let resource = SwapiEndpoint(T: U.self, id: id, query: query) else { return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No endpoint for type"]))}
        let request = resource.request
        print(resource.request.url ?? "No valid URL")
        do {
            let result: Resources<U> = try await fetchAndDecode(url: request.url!)
            return .success(result)
        } catch {
                return .failure(error)
            }
    }
    
    /// manual JSON decoding using JSONSerialization with modern concurensy
    func fetchAndDecodeFilms(id: String? = nil, query: [URLQueryItem] = []) async -> (Result<Resources<Film>, Error>) {
        guard let resource = SwapiEndpoint(T: Film.self, id: id, query: query) else { return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No endpoint for type"]))}
        let request = resource.request
        do {
        let (data, _) = try await URLSession.shared.data(from:  request.url!)
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                guard let result = jsonObject["result"] as? [[String: Any]] else { throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "No result"))}
                let films: [Film] = result.compactMap{
                    guard let props = $0["properties"] as? [String: Any] else { return nil }
                    return Film(title: props["title"] as? String, episodeId: props["episodeId"] as? Int)
                }
                let message = jsonObject["message"] as? String
                let decodedData = Resources(message: message, result: .many(films.map({ Resources.Res(properties: $0)})))
                return .success(decodedData)
            }
        } catch {
            return .failure(error)
        }
        return .failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "General error"]))
    }
    
    /// manual JSON decoding using Alamorfire with modern concurensy
    func fetchAndDecodeFilmsaAM(id: String? = nil, query: [URLQueryItem] = [], completion: @escaping (Result<[Film], Error>) -> Void) {
        guard let resource = SwapiEndpoint(T: Film.self, id: id, query: query) else { completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No endpoint for type"])))
            return
        }
        let request = resource.request
        AF.request(request.url!)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    guard let jsonObject = value as? [String: Any],
                          let result = jsonObject["result"] as? [[String: Any]] else { completion(.failure(DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "No dictionary"))))
                        return
                    }
                    let films: [Film] = result.compactMap{
                        guard let props = $0["properties"] as? [String: Any] else { return nil }
                        return Film.getFrom(dict: props)
                    }
                    let message = jsonObject["message"] as? String
                    let decodedData = Resources(message: message, result: .many(films.map({ Resources.Res(properties: $0)})))
                    completion(.success(decodedData.results!))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    /// manual JSON decoding using Alamorfire with modern concurency (refactored)
    func fetchAndDecodeFilmsAMRefactored(id: String? = nil, query: [URLQueryItem] = [], completion: @escaping (Result<Resources<Film>, Error>) -> Void) {
        guard let resource = SwapiEndpoint(T: Film.self, id: id, query: query) else { completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No endpoint for type"])))
            return
        }
        let request = resource.request
        AF.request(request.url!)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    guard let jsonObject = value as? [String: Any] else { completion(.failure(DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "No dictionary"))))
                        return
                    }
                    guard let decodedData = Resources<Film>.getFilmsFrom(dict: jsonObject) else {
                        completion(.failure(DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "No Resources"))))
                        return
                    }
                    completion(.success(decodedData))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
}
