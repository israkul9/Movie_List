//
//  MovieCell.swift
//  Movie_List_App
//
//  Created by Israkul
//

import UIKit

class MovieCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell( movie : Movie ){
        self.titleLabel.text = movie.title
        self.overviewLabel.text = movie.overview
        
        let imageString = ApiConstant.posterImageBaseURL + (movie.backdropPath ?? "")
        
        if let imageURL = URL(string: imageString) {
            self.posterImageView.image = UIImage(named: "placeholderImage")
            self.getPosterImage(url: imageURL)
            
        }
        
    }
    
    func getPosterImage(url: URL){
        // Use the ImageCache to load and cache the image
        ImageCache.shared.loadImage(with: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                self.posterImageView.image = image
            case .failure(let error):
                print("Error loading image: \(error)")
            }
        }
    }
    

    }
    
    

    

