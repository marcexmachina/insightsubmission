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
    private let networkManager: NetworkManagerProtocol!

    let detailImage = Observable<UIImage?>(nil)
    let name = Observable<String>("")
    let size = Observable<String>("")
    let resolution = Observable<String>("")
    let date = Observable<String>("")
    let tags = MutableObservableArray<String>([])

    // MARK: - Lifecycle

    init(photo: Photo, networkManager: NetworkManagerProtocol) {
        self.photo = photo
        self.networkManager = networkManager
        downloadImage()
        name.value = photo.title

        let timestamp = Double(photo.dateUpload) ?? 0.0 / 1000
        let dateFromTimestamp = Date(timeIntervalSince1970: TimeInterval(timestamp))

        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let dateStr = formatter.string(from: dateFromTimestamp)
        let sourceDate = formatter.date(from: dateStr)
        formatter.dateFormat = "dd-MM-yyyy HH:mm"

        tags.removeAll()
        tags.replace(with: photo.tags.components(separatedBy: " ").filter { $0 != "" })

        date.value = "Uploaded date: \(formatter.string(from: sourceDate!))"
    }

    func downloadImage() {
        networkManager.downloadDetailImage(for: photo) { data in
            guard let data = data, let image = UIImage(data: data) else {
                return
            }
            self.detailImage.value = image
        }
    }
}

