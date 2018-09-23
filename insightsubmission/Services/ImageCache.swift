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

    private let imageCache: NSCache<NSString, NSData>
    private let fileManager: FileManager
    private let imageCacheUrl: URL
    private let queue: DispatchQueue

    private init() {
        imageCache = NSCache<NSString, NSData>()
        fileManager = FileManager()
        queue = DispatchQueue(label: "com.marcexmachina.insightsubmission.cache", qos: .background, attributes: .concurrent)

        let defaultUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        imageCacheUrl = defaultUrl.appendingPathComponent("com.marcexmachina.insightsubmission")

        do {
            try fileManager.createDirectory(at: imageCacheUrl, withIntermediateDirectories: true, attributes: nil)
        } catch(let error) {
            print("\(error)")
        }
    }

    func cache(key: String, imageData: Data) {
        queue.async {
            let fileName = self.fileName(for: key)

            // Cache image in memory
            self.imageCache.setObject(NSData(data: imageData), forKey: fileName as NSString)

            // Cache image to caches directory
            let path = self.filePath(for: key)
            do {
                try imageData.write(to: path)
            } catch(let error) {
                // TODO: - NSLog here
                print("\(error)")
            }
        }
    }

    func imageData(key: String, completion: @escaping (Data?) -> ()) {
        queue.async {
            let fileKey = self.fileName(for: key)
            var result: Data?

            // Check in-memory cache for image
            if let data = self.imageCache.object(forKey: fileKey as NSString) {
                result = data as Data
            }

            // Check caches directory for image
            let path = self.filePath(for: key)
            if let data = try? Data(contentsOf: path) {
                result = data as Data
            }

            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    func imageDataFromMemory(for key: String, completion: @escaping (Data?) -> ()) {
        queue.async {
            let fileName = self.fileName(for: key)

            var result: Data?
            if let data = self.imageCache.object(forKey: fileName as NSString) {
                result = data as Data
            }

            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    func imageDataFromDisk(for key: String, completion: @escaping (Data?) -> ()) {
        queue.async {
            let path = self.filePath(for: key)

            var result: Data?
            if let data = try? Data(contentsOf: path) {
                result = data as Data
            }

            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    func removeAllObjects() {
        self.imageCache.removeAllObjects()
        let urls = try? self.fileManager.contentsOfDirectory(at: self.imageCacheUrl, includingPropertiesForKeys: nil, options: [])
        urls?.forEach({ (url) in
            try? self.fileManager.removeItem(at: url)
        })
    }

    // MARK: - Private Methods

    private func fileName(for urlString: String) -> String {
        let path = self.filePath(for: urlString)
        return path.lastPathComponent
    }

    private func filePath(for urlString: String) -> URL {
        let filename = URL(string: urlString)!.lastPathComponent
        return imageCacheUrl.appendingPathComponent(filename)
    }
}
