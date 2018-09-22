//
//  ImageCache
//  insightsubmission
//
//  Created by Marc O'Neill on 22/09/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import Foundation

final class ImageCache {
    static let shared = ImageCache()

    private let imageCache = NSCache<NSString, NSData>()

    private init() { }

    func cache(key: String, imageData: Data) {
        imageCache.setObject(NSData(data: imageData), forKey: key as NSString)
    }

    func imageData(forKey key: String) -> Data? {
        if let data = imageCache.object(forKey: key as NSString) {
            return data as Data
        }
        return nil
    }
}
