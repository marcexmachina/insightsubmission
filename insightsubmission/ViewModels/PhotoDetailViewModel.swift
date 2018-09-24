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

    init(photo: Photo, networkManager: NetworkManagerProtocol) {
        self.photo = photo
        self.networkManager = networkManager
        downloadImage()
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
