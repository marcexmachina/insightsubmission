//
//  FlickrPagedPhotoResult.swift
//  insightsubmission
//
//  Created by Marc O'Neill on 18/09/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import Foundation

struct FlickrPagedPhotoResult: Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: String
    let photo : [Photo]
}
