//
//  Photo.swift
//  insightsubmission
//
//  Created by Marc O'Neill on 17/09/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import Foundation

struct Photo {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let isPublic: Bool
    let isFriend: Bool
    let isFamily: Bool
    let urlOriginal: String
    let urlThumbnail: String
    let heightOriginal: String
    let widthOriginal: String
    let dateUpload: String
    let tags: String

    enum CodingKeys: String, CodingKey {
        case id
        case owner
        case secret
        case server
        case farm
        case title
        case isPublic = "ispublic"
        case isFriend = "isfriend"
        case isFamily = "isfamily"
        case urlOriginal = "url_o"
        case urlThumbnail = "url_q"
        case heightOriginal = "height_o"
        case widthOriginal = "width_o"
        case dateUpload = "dateupload"
        case tags
    }
}

extension Photo: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        owner = try container.decode(String.self, forKey: .owner)
        secret = try container.decode(String.self, forKey: .secret)
        server = try container.decode(String.self, forKey: .server)
        farm = try container.decode(Int.self, forKey: .farm)
        title = try container.decode(String.self, forKey: .title)
        isPublic = try container.decode(Int.self, forKey: .isPublic) == 1 ? true : false
        isFriend = try container.decode(Int.self, forKey: .isFriend) == 1 ? true : false
        isFamily = try container.decode(Int.self, forKey: .isFamily) == 1 ? true : false
        urlOriginal = try container.decode(String.self, forKey: .urlOriginal)
        urlThumbnail = try container.decode(String.self, forKey: .urlThumbnail)
        heightOriginal = try container.decode(String.self, forKey: .heightOriginal)
        widthOriginal = try container.decode(String.self, forKey: .widthOriginal)
        dateUpload = try container.decode(String.self, forKey: .dateUpload)
        tags = try container.decode(String.self, forKey: .tags)
    }
}
