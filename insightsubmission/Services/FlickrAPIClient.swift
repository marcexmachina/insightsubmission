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
    func getPhotos(text: String, completion: @escaping (Result<FlickrPhotosResult>) -> ())
    func getPhotos(tag: String, completion: @escaping (Result<FlickrPhotosResult>) -> ())
    func getPhotos(latitude: Double, longitude: Double, completion: @escaping (Result<FlickrPhotosResult>) -> ())
    func startDownload(for photo: Photo, at indexPath: IndexPath, completion: @escaping ()->())
    func downloadDetailImage(for photo: Photo, completion: @escaping (Data?)->())
    func url(text: String) -> URL
    func url(latitude: Double, longitude: Double) -> URL
}

struct FlickrAPIClient {
    private let session: NetworkSession

    let operationsManager = PhotosOperationsManager()

    init(session: NetworkSession) {
        self.session = session
    }

    /// Search Flickr API for images with text
    ///
    /// - Parameters:
    ///   - text: text
    ///   - completion: completion
    func getPhotos(text: String, completion: @escaping (Result<FlickrPhotosResult>) -> ()) {
        let requestUrl = url(text: text)

        performDataTask(requestUrl, session, completion)
    }

    /// Search Flickr API for images with latitude, longitude values
    ///
    /// - Parameters:
    ///   - latitude: latitude
    ///   - longitude: longitude
    ///   - completion: completion
    func getPhotos(latitude: Double, longitude: Double, completion: @escaping (Result<FlickrPhotosResult>) -> ()) {
        let requestUrl = url(latitude: latitude, longitude: longitude)

        performDataTask(requestUrl, session, completion)
    }

    /// Search Flickr API for images tagged with string
    ///
    /// - Parameters:
    ///   - tag: tag
    ///   - completion: completion
    func getPhotos(tag: String, completion: @escaping (Result<FlickrPhotosResult>) -> ()) {
        let requestUrl = url(tag: tag)

        performDataTask(requestUrl, session, completion)
    }

    /// Start a download operation for thumbnail images
    ///
    /// - Parameters:
    ///   - photo: photo
    ///   - indexPath: indexPath
    ///   - completion: completion
    func startDownload(for photo: Photo, at indexPath: IndexPath, completion: @escaping ()->()) {
        guard operationsManager.operationsInProgress[indexPath] == nil else { return }

        let downloadOperation = ImageDownloadOperation(photo: photo, size: .largeSquare)

        downloadOperation.completionBlock = {
            DispatchQueue.main.async {
                self.operationsManager.operationsInProgress.removeValue(forKey: indexPath)
                completion()
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

//extension NetworkManagerProtocol {
extension FlickrAPIClient {
    func url(text: String) -> URL {
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

    func url(tag: String) -> URL {
        var components = requestComponents()

        let tagQueryItem = URLQueryItem(name: "tags", value: tag)

        var queryItems = commonQueryItems()
        queryItems.append(tagQueryItem)
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

    fileprivate func performDataTask(_ requestUrl: URL, _ session: NetworkSession,  _ completion: @escaping (Result<FlickrPhotosResult>) -> ()) {
        session.loadData(with: requestUrl) { data, response, error in
            guard let data = data, error == nil else {
                completion(.error(FlickrError.noData))
                return
            }

            let statusCode = (response as! HTTPURLResponse).statusCode
            guard 200...299 ~= statusCode else {
                completion(.error(FlickrError.serverResponseError))
                return
            }

            do {
                let flickrPhotosResult = try JSONDecoder().decode(FlickrPhotosResult.self, from: data)
                completion(.success(flickrPhotosResult))
            } catch let error {
                completion(.error(error))
            }
        }
    }
}
