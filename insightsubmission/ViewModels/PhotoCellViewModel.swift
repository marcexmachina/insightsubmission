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
    let image = Observable<UIImage?>(nil)

    init(photo: Photo) {
        self.photo = photo
    }
}
