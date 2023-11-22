//
//  AppConstants.swift
//  Movie_List_App
//
//  Created by Israkul 
//

import Foundation

struct StoryboardNames {
    static let Onboarding = "Onboarding"
    static let Movies = "Movies"
}

struct ViewControllerNames {
    static let Onboarding = "OnboardingVC"
    static let MovieListVC = "MovieListVC"
}

struct ApiConstant {
    static let movieListURL = "https://api.themoviedb.org/3/search/movie?api_key=38e61227f85671163c275f9bd95a8803&query=marvel"
    static let posterImageBaseURL = "https://image.tmdb.org/t/p/w500"
}
