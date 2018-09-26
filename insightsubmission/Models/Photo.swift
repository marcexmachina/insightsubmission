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
    let title: String
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
        case title
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
        title = try container.decode(String.self, forKey: .title)
        urlLargeSquare = try container.decodeIfPresent(String.self, forKey: .urlLargeSquare)
        urlMedium = try container.decodeIfPresent(String.self, forKey: .urlMedium)
        heightOriginal = try container.decodeIfPresent(String.self, forKey: .heightOriginal)
        widthOriginal = try container.decodeIfPresent(String.self, forKey: .widthOriginal)
        dateUpload = try container.decode(String.self, forKey: .dateUpload)
        tags = try container.decode(String.self, forKey: .tags)
    }
}
