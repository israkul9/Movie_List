//
//  MovieListVC.swift
//  Movie_List_App
//
//  Created by Israkul Tushaer-81 on 22/11/23.
//

import UIKit

class MovieListVC: UIViewController, UISearchResultsUpdating  {
  
    // MARK: Properties
    
    var movieListViewModel : MovieListViewModel!
    @IBOutlet weak var tableViewBottomConst: NSLayoutConstraint!
    let TAG = String(describing: MovieListVC.self)
    @IBOutlet weak var movieListTableView: UITableView!
  

    // MARK: Searchbar
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredMovies = [Movie]()
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        if searchController.isActive {
            if !isSearchBarEmpty || searchController.searchBar.selectedScopeButtonIndex != 0 {
                return true
            }
        }
        return false
    }

    // MARK: Controller Life Cycle
 
    override func viewDidLoad() {
        super.viewDidLoad()
        PrintUtility.printLog(tag: self.TAG, text: "viewDidLoad")
        self.setupSearchBar()
        self.enableLightMode()
        self.setupTableView()
        self.subscribeKeyboardShowAndHide()
        self.getdata()
    }
    
    deinit {
        PrintUtility.printLog(tag: TAG, text: " deinit called")
        NotificationCenter.default.removeObserver(self)
    }
}

extension MovieListVC {
    func getdata(){
        movieListViewModel = MovieListViewModel()
        self.movieListViewModel.fetchMoviesFromServer { success in
            if success {
                DispatchQueue.main.async {
                    self.movieListTableView.reloadData()
                }
            }
            else {
                PrintUtility.printLog(tag: self.TAG, text:"Error while getting data")
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    func subscribeKeyboardShowAndHide(){
        // Register to receive notifications when the keyboard shows or hides
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(notification: Notification) {
        // Extract the keyboard frame from the notification
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            
            // Perform actions when the keyboard will show, e.g., adjust UI layout
            // You can use keyboardFrame to get the keyboard's size and position
            PrintUtility.printLog(tag: TAG, text: "Keyboard will show. Frame: \(keyboardFrame)")
            
            UIView.animate(withDuration: 0.1) {
                self.tableViewBottomConst.constant = keyboardFrame.height
            }
            view.layoutIfNeeded()
            
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        // Perform actions when the keyboard will hide, e.g., restore UI layout
        PrintUtility.printLog(tag: TAG, text: "keyboardWillHide")
        UIView.animate(withDuration: 0.1) {
            self.tableViewBottomConst.constant = 0.0
        }
        view.layoutIfNeeded()
    }
    
    
    func setupSearchBar(){
        // Configure the search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search movie"
        
        // Add the search bar to the table view's header
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func setupTableView(){
        
        self.movieListTableView.delegate = self
        self.movieListTableView.dataSource = self
        self.movieListTableView.register(UINib(nibName: MovieCell.className, bundle: nil), forCellReuseIdentifier: MovieCell.className)
        self.movieListTableView.estimatedRowHeight = 120.0
        self.movieListTableView.estimatedRowHeight = UITableView.automaticDimension
    }
    func enableLightMode(){
        if let navigationController = self.navigationController {
            let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            navigationController.navigationBar.titleTextAttributes = textAttributes
        }
        
        // Set the navigation bar large title text color
        if let navigationController = self.navigationController {
            let largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            navigationController.navigationBar.largeTitleTextAttributes = largeTitleTextAttributes
        }
        if #available(iOS 13.0, *) {
            // Set the appearance style to light for this view controller
            overrideUserInterfaceStyle = .light
        }
    }
}
// MARK: Movie List tableview delegate and datasource
extension MovieListVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredMovies.count : self.movieListViewModel.movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let movieCell = tableView.dequeueReusableCell(withIdentifier: MovieCell.className)  as? MovieCell else {
            return UITableViewCell()
            
        }
        guard let movies  = self.movieListViewModel?.movieList else { return movieCell }
        let movie = isFiltering ? filteredMovies[indexPath.row] : movies[indexPath.row]
        movieCell.configureCell(movie: movie)
        return movieCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let imageUrl = self.movieListViewModel?.movieList[indexPath.row].posterPath else {  return }
        PrintUtility.printLog(tag: TAG, text: imageUrl)
    }
    
    /// Filter movie from movie list
        /// - Parameter searchText: text searched in search bar
   
    func filterMovies(searchText: String) {
        guard let movies = movieListViewModel?.movieList else { return }
        if searchText.isEmpty {
            // If the search text is empty, show all movies
            filteredMovies = movies
        } else {
            // If the search text is not empty, filter based on title and overview
            filteredMovies = movies.filter { (movie: Movie) -> Bool in
                let titleMatch = movie.title?.lowercased().contains(searchText.lowercased()) ?? false
                let overviewMatch = movie.overview?.lowercased().contains(searchText.lowercased()) ?? false
                return titleMatch || overviewMatch
            }
        }
        DispatchQueue.main.async {
            self.movieListTableView.reloadData()
        }
    }
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchedText = searchController.searchBar.text else {  return }
        PrintUtility.printLog(tag: TAG, text: "Searched text : \(searchedText  )")
        self.filterMovies(searchText: searchedText)
    }
}
 
