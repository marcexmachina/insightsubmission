//
//  ImageDownloadOperation.swift
//  insightsubmission
//
//  Created by Marc O'Neill on 22/09/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import Foundation

class ImageDownloadOperation: Operation {
    var photo: Photo

    init(photo: Photo) {
        self.photo = photo
    }

    override func main() {
        if isCancelled { return }

        guard let urlString = photo.urlThumbnail ?? photo.urlOriginal,
            let url = URL(string: urlString),
            let data = try? Data(contentsOf: url) else {
                return
        }

        if isCancelled { return }

        if !data.isEmpty {
            photo.updateState(.downloaded)
            ImageCache.shared.cache(key: urlString, imageData: data)
        } else {
            photo.updateState(.failed)
        }
    }
}
