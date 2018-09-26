//
//  PhotoCellViewModel.swift
//  insightsubmission
//
//  Created by Marc O'Neill on 22/09/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import Foundation
import Bond

struct PhotoCellViewModel {
    private let photo: Photo
    private let networkManager: FlickrAPIClient!
    
    let image = Observable<UIImage?>(nil)
    let imageKey: String

    init(photo: Photo, networkManager: FlickrAPIClient) {
        self.photo = photo
        self.networkManager = networkManager
        imageKey = photo.id
    }

    func detailViewModel() -> PhotoDetailViewModel {
        return PhotoDetailViewModel(photo: photo, networkManager: networkManager)
    }
}
