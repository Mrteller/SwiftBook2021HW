//
//  MovieRepository.swift
//  TheMovieList
//
//  Created by  Paul on 14.01.2022.
//

import Foundation

final class MovieStore {
    
    // MARK: - Public vars
        
    static let shared = MovieStore()
    
    // MARK: - Private vars
    
    private let apiKey = "1d9b898a212ea52e283351e521e17871"
    private let baseAPIURL = "https://api.themoviedb.org/3"
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()
    
    // MARK: - Initializers
    
    private init() {}

    // MARK: - Public funcs
    
    func fetchMovies(from endpoint: Endpoint, completion: @escaping (Result<MoviesResponse, Error>) -> ()) {
            guard let url = self.generateURL(with: endpoint) else {
                completion(.failure(URLError(.unsupportedURL)))
                return
            }
        
           fetchAPI(url: url, completion: completion)

    }
    
    func fetchAPI<D: Decodable>(url: URL, completion: @escaping (Result<D, Error>) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      200...299 ~= httpResponse.statusCode,
                      let data = data else {
                          // TODO: Process `httpResponse.statusCode`
                          completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Bad HTTP Response"])))
                          return
                      }
                
                do {
                    let decodedData = try self.jsonDecoder.decode(D.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        .resume()
    }
    
    func fetchData(url: URL, completion: @escaping (Data) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let data = try? Data(contentsOf: url) else { return }
            // DispatchQueue.main.async {
                completion(data)
            // }
        }
    }
    
    // MARK: - Private funcs

    private func generateURL(with endpoint: Endpoint) -> URL? {
        guard var urlComponents = URLComponents(string: "\(baseAPIURL)/movie/\(endpoint.rawValue)") else {
            return nil
        }
        
        let queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }
    
}

