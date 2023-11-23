//
//  ImageCache.swift
//  Movie_List_App
//
//  Created by israkul
//


import UIKit


class ImageCache {
    static let shared = ImageCache()
    private init() {}
    let cachedImage = NSCache<AnyObject, AnyObject>()
    func loadImage(with url: URL, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        let urlString = url.absoluteString
        if let cachedImage = cachedImage.object(forKey: urlString as AnyObject) as? UIImage {
            // if image already cached
            PrintUtility.printLog(tag: "ImageCache : ", text: "Image from cache")
            completion(.success(cachedImage))
            return
        }
        DispatchQueue.global(qos: .background).async { [weak self] in
            do {
                let data = try Data(contentsOf: url)
                guard let image = UIImage(data: data) else {
                    return
                }
                self?.cachedImage.setObject(image, forKey: urlString as AnyObject)
                DispatchQueue.main.async {
                    // Update the completion handler on the main thread
                        completion(.success(image))
                    PrintUtility.printLog(tag: "ImageCache : ", text: "Image from server")
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
