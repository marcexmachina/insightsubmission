//
//  Constants.swift
//  insightsubmission
//
//  Created by Marc O'Neill on 16/09/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import Foundation

struct Constants {
    enum Flickr {
        static let apiKey = "07b1faa42f0ae8294e817901651f30c1"
        static let scheme = "https"
        static let baseURL = "api.flickr.com"
        static let path = "/services/rest"
        static let format = "json"
        static let JSONCallback = "1"
        static let safeSearch = "1"
//        static let secret = "f1e4b232ec4e6134"

        enum Extras: String {
            case description
            case date_upload
            case tags
            case o_dims
            case url_q
            case url_o

            private static let allValues = [description, date_upload, tags, o_dims, url_q, url_o]


            /// Returns a comma separated list of extras, stripping the last comma from the `String`
            ///
            /// - Returns: extras
            static func asString() -> String {
                return String(Extras.allValues.reduce("") { result, extra in
                    result.appending("\(extra),")
                }.dropLast())
            }
        }
    }
}
