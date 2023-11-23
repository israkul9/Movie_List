//
//  MovieListViewModel.swift
//  Movie_List_App
//
//  Created by Israkul 
//

import Foundation

class MovieListViewModel {
    
    var movieList = [Movie]()
    
    func fetchMoviesFromServer(completion: @escaping (Bool) -> Void) {
        
        let movieURL = ApiConstant.movieListURL
           
        guard let url = URL(string: movieURL) else { return }
        
        APIManager.shared.callMovieListAPI(at: url) { result in
            switch result {
               case .success(let movies):
                   // Handle the successfully fetched movies
                self.movieList.removeAll()
                guard let movies = movies.results else { return }
                self.movieList = movies
                completion(true)
               case .failure(let error):
                   // Handle the error
                   print("Error fetching movies: \(error)")
                completion(false)
               }
        }
    }
}
