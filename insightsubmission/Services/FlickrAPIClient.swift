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
    func startDownload(for photo: Photo, at indexPath: IndexPath, completion: @escaping ()->())
    func url(for text: String) -> URL
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

    func startDownload(for photo: Photo, at indexPath: IndexPath, completion: @escaping ()->()) {
        guard operationsManager.operationsInProgress[indexPath] == nil else { return }

        let downloadOperation = ImageDownloadOperation(photo: photo)

        downloadOperation.completionBlock = {
            if downloadOperation.isCancelled { return }

            DispatchQueue.main.async {
                self.operationsManager.operationsInProgress.removeValue(forKey: indexPath)
                completion()
            }
        }
        
        self.operationsManager.operationsInProgress[indexPath] = downloadOperation
        self.operationsManager.downloadQueue.addOperation(downloadOperation)
    }
}

extension NetworkManagerProtocol {
    func url(for text: String) -> URL {
        var components = URLComponents()
        components.scheme = Constants.Flickr.scheme
        components.host = Constants.Flickr.baseURL
        components.path = Constants.Flickr.path

        let methodQueryItem = URLQueryItem(name: "method", value: APIMethod.search.rawValue)
        let textQueryItem = URLQueryItem(name: "text", value: text)
        let formatQueryItem = URLQueryItem(name: "format", value: Constants.Flickr.format)
        let apiKeyQueryItem = URLQueryItem(name: "api_key", value: Constants.Flickr.apiKey)
        let jsonCallback = URLQueryItem(name: "nojsoncallback", value: Constants.Flickr.JSONCallback)
        let extras = URLQueryItem(name: "extras", value: Constants.Flickr.Extras.asString())
        components.queryItems = [methodQueryItem, textQueryItem, formatQueryItem, apiKeyQueryItem, jsonCallback, extras]
        return components.url!
    }
}
