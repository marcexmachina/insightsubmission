//
//  ImageDownloadOperation.swift
//  insightsubmission
//
//  Created by Marc O'Neill on 22/09/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import Foundation

/// Operation to download image from Flickr
class ImageDownloadOperation: Operation {
    var photo: Photo
    var size: Size

    init(photo: Photo, size: Size) {
        self.photo = photo
        self.size = size
    }

    override func main() {
        if isCancelled { return }

        var urlString: String

        switch size {
        case .largeSquare:
            urlString = photo.thumbnailUrl() ?? ""
        case .medium:
            urlString = photo.urlMedium ?? photo.urlLargeSquare ?? ""
        }
        
        guard let url = URL(string: urlString),
            let data = try? Data(contentsOf: url) else { return }

        if isCancelled { return }

        if !data.isEmpty {
            photo.updateState(.downloaded)
            ImageCache.shared.cache(key: urlString, imageData: data)
        } else {
            photo.updateState(.failed)
        }
    }
}
