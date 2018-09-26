//
//  Photo.swift
//  insightsubmission
//
//  Created by Marc O'Neill on 17/09/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import Foundation

enum PhotoState {
    case new
    case downloaded
    case failed
}

enum Size: String {
    case largeSquare = "url_q"
    case medium = "url_m"
}

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
    let urlLargeSquare: String?
    let urlMedium: String?
    let heightOriginal: String?
    let widthOriginal: String?
    let dateUpload: String
    let tags: String
    let imageData: Data? = nil
    var state = PhotoState.new

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
        case urlLargeSquare = "url_q"
        case urlMedium = "url_m"
        case heightOriginal = "height_o"
        case widthOriginal = "width_o"
        case dateUpload = "dateupload"
        case tags
    }

    mutating func updateState(_ newValue: PhotoState) {
        state = newValue
    }

    /// Want the largeSquare image if available, otherwise medium
    ///
    /// - Returns: url
    func thumbnailUrl() -> String? {
        return self.urlLargeSquare ?? self.urlMedium
    }

    /// Want the medium image if available, otherwise largeSquare
    ///
    /// - Returns: url
    func detailImageUrl() -> String? {
        return self.urlMedium ?? self.urlLargeSquare
    }
}

extension Photo: Codable {
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
        urlLargeSquare = try container.decodeIfPresent(String.self, forKey: .urlLargeSquare)
        urlMedium = try container.decodeIfPresent(String.self, forKey: .urlMedium)
        heightOriginal = try container.decodeIfPresent(String.self, forKey: .heightOriginal)
        widthOriginal = try container.decodeIfPresent(String.self, forKey: .widthOriginal)
        dateUpload = try container.decode(String.self, forKey: .dateUpload)
        tags = try container.decode(String.self, forKey: .tags)
    }
}
