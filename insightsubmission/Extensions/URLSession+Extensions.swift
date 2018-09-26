//
//  URLSession+Extensions.swift
//  insightsubmission
//
//  Created by Marc O'Neill on 26/09/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import Foundation

protocol NetworkSession {
    func loadData(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ())
}

extension URLSession: NetworkSession {
    func loadData(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) {
        let task = dataTask(with: url) { (data, response, error) in
            completionHandler(data, response, error)
        }
        task.resume()
    }
}
