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
    func url(for text: String) -> URL
}

struct FlickrAPIClient: NetworkManagerProtocol {
    private let session: URLSession

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
        let extras = URLQueryItem(name: "extras", value: extraURLParameters())
        components.queryItems = [methodQueryItem, textQueryItem, formatQueryItem, apiKeyQueryItem, jsonCallback, extras]
        return components.url!
    }

    private func extraURLParameters() -> String {
        return "description,date_upload,tags,o_dims,url_q,url_o"
    }
}
