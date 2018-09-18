//
//  APIMethod.swift
//  insightsubmission
//
//  Created by Marc O'Neill on 16/09/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import Foundation

/// Describes the method to use in the Flickr HTTP request
///
/// - search: search for photos
enum APIMethod: String {
    case search = "flickr.photos.search"
}
