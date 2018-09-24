//
//  NetworkManager.swift
//  insightsubmission
//
//  Created by Marc O'Neill on 16/09/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import Foundation

protocol NetworkManagerProtocol {
    init(session: URLSession)
    func getPhotos(with text: String, completion: @escaping (Result<FlickrPhotosResult>) -> ())
    func getPhotos(latitude: Double, longitude: Double, completion: @escaping (Result<FlickrPhotosResult>) -> ())
    func startDownload(for photo: Photo, at indexPath: IndexPath)
    func downloadDetailImage(for photo: Photo, completion: @escaping (Data?)->())
    func url(for text: String) -> URL
    func url(latitude: Double, longitude: Double) -> URL
}

struct FlickrAPIClient: NetworkManagerProtocol {
    private let session: URLSession
    let operationsManager = PhotosOperationsManager()

    init(session: URLSession) {
        self.session = session
    }

    func getPhotos(with text: String, completion: @escaping (Result<FlickrPhotosResult>) -> ()) {
        let requestUrl = url(for: text)

        session.dataTask(with: requestUrl) { data, response, error in
            guard let data = data, error == nil else {
                // TODO: NSLog
                return
            }

            let statusCode = (response as! HTTPURLResponse).statusCode
            guard 200...299 ~= statusCode else {
                // TODO: NSLog
                completion(.error(FlickrError.serverResponseError))
                return
            }

            do {
                let flickrPhotosResult = try JSONDecoder().decode(FlickrPhotosResult.self, from: data)
                // TODO: NSLog
                completion(.success(flickrPhotosResult))
            } catch let error {
                // TODO: NSLog
                completion(.error(error))
            }
        }.resume()
    }

    func getPhotos(latitude: Double, longitude: Double, completion: @escaping (Result<FlickrPhotosResult>) -> ()) {
        let requestUrl = url(latitude: latitude, longitude: longitude)

        session.dataTask(with: requestUrl) { data, response, error in
            guard let data = data, error == nil else {
                // TODO: NSLog
                return
            }

            let statusCode = (response as! HTTPURLResponse).statusCode
            guard 200...299 ~= statusCode else {
                // TODO: NSLog
                completion(.error(FlickrError.serverResponseError))
                return
            }

            do {
                let flickrPhotosResult = try JSONDecoder().decode(FlickrPhotosResult.self, from: data)
                // TODO: NSLog
                completion(.success(flickrPhotosResult))
            } catch let error {
                // TODO: NSLog
                completion(.error(error))
            }
        }.resume()
    }

    /// Start a download operation for thumbnail images
    ///
    /// - Parameters:
    ///   - photo: photo
    ///   - indexPath: indexPath
    ///   - completion: completion
    func startDownload(for photo: Photo, at indexPath: IndexPath) {
        guard operationsManager.operationsInProgress[indexPath] == nil else { return }

        let downloadOperation = ImageDownloadOperation(photo: photo, size: .largeSquare)

        downloadOperation.completionBlock = {
            if downloadOperation.isCancelled { return }

            DispatchQueue.main.async {
                self.operationsManager.operationsInProgress.removeValue(forKey: indexPath)
            }
        }
        
        self.operationsManager.operationsInProgress[indexPath] = downloadOperation
        self.operationsManager.downloadQueue.addOperation(downloadOperation)
    }

    /// Downloads the image for detail screen
    ///
    /// - Parameters:
    ///   - photo: photo to download
    ///   - completion: completion
    func downloadDetailImage(for photo: Photo, completion: @escaping (Data?)->()) {
        DispatchQueue.global().async {
            guard let urlString = photo.urlMedium ?? photo.urlLargeSquare,
                let url = URL(string: urlString),
                let data = try? Data(contentsOf: url) else {
                    completion(nil)
                    return
            }

            DispatchQueue.main.async {
                completion(data)
            }
        }
    }
}

extension NetworkManagerProtocol {
    func url(for text: String) -> URL {
        var components = requestComponents()

        let textQueryItem = URLQueryItem(name: "text", value: text)
        
        var queryItems = commonQueryItems()
        queryItems.append(textQueryItem)
        components.queryItems = queryItems
        return components.url!
    }

    func url(latitude: Double, longitude: Double) -> URL {
        var components = requestComponents()

        let coordinateQueryItems = [URLQueryItem(name: "lat", value: "\(latitude)"),
                                    URLQueryItem(name: "lon", value: "\(longitude)")]

        var queryItems = commonQueryItems()
        queryItems.append(contentsOf: coordinateQueryItems)
        components.queryItems = queryItems
        return components.url!
    }

    private func commonQueryItems() -> [URLQueryItem] {
        return [
            URLQueryItem(name: "method", value: APIMethod.search.rawValue),
            URLQueryItem(name: "format", value: Constants.Flickr.format),
            URLQueryItem(name: "api_key", value: Constants.Flickr.apiKey),
            URLQueryItem(name: "nojsoncallback", value: Constants.Flickr.JSONCallback),
            URLQueryItem(name: "safe_search", value: Constants.Flickr.safeSearch),
            URLQueryItem(name: "extras", value: Constants.Flickr.Extras.asString())
        ]
    }

    private func requestComponents() -> URLComponents {
        var components = URLComponents()
        components.scheme = Constants.Flickr.scheme
        components.host = Constants.Flickr.baseURL
        components.path = Constants.Flickr.path
        return components
    }
}
