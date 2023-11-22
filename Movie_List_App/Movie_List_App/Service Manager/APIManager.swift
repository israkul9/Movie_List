//
//  APIManager.swift
//  Movie_List_App
//
//  Created by Israkul 
//

import Foundation


class APIManager {
    static let shared = APIManager()
    private init() {}
    func callMovieListAPI(at url: URL, completion: @escaping (Result<Movies, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            if let data = data {
                do {
                    let movies = try JSONDecoder().decode(Movies.self, from: data)
                    completion(.success(movies))
                } catch let decoderError {
                    completion(.failure(decoderError))
                }
            }
        }.resume()
    }
}
