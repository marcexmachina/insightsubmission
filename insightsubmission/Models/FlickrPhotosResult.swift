//
//  FlickrPhotosResult.swift
//  insightsubmission
//
//  Created by Marc O'Neill on 17/09/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import Foundation

struct FlickrPhotosResult: Decodable {
    let stat: String
    let photos: FlickrPagedPhotoResult?
}
