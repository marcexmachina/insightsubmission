//
//  PhotoDetailViewModel.swift
//  insightsubmission
//
//  Created by Marc O'Neill on 24/09/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
// 

import Foundation
import Bond

struct PhotoDetailViewModel {
    private let photo: Photo
    private let networkManager: FlickrAPIClient!

    let detailImage = Observable<UIImage?>(nil)
    let name = Observable<String>("")
    let size = Observable<String>("")
    let resolution = Observable<String>("")
    let date = Observable<String>("")
    let tags = MutableObservableArray<String>([])

    // MARK: - Lifecycle

    init(photo: Photo, networkManager: FlickrAPIClient) {
        self.photo = photo
        self.networkManager = networkManager
        downloadImage()
        name.value = photo.title

        tags.removeAll()
        tags.replace(with: photo.tags.components(separatedBy: " ").filter { $0 != "" })

        date.value = "Uploaded date: \(localDateString(from: photo.dateUpload))"
    }

    // MARK: - Methods

    func downloadImage() {
        networkManager.downloadDetailImage(for: photo) { data in
            guard let data = data, let image = UIImage(data: data) else {
                return
            }
            self.detailImage.value = image
        }
    }

    // MARK: - Private methods

    private func localDateString(from timestamp: String) -> String {
        let timestamp = Double(timestamp) ?? 0.0
        let dateFromTimestamp = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let dateString = formatter.string(from: dateFromTimestamp)
        let sourceDate = formatter.date(from: dateString)
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        return formatter.string(from: sourceDate!)
    }
}

