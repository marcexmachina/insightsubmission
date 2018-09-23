//
//  HomeCollectionViewModel.swift
//  insightsubmission
//
//  Created by Marc O'Neill on 19/09/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import Foundation
import Bond

class HomeCollectionViewModel {
    var images = MutableObservableArray<Photo>([])
    var searchString = Observable<String?>("")
    let networkManager: NetworkManagerProtocol!

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager

        _ = searchString
            .filter { $0!.count > 3 }
            .throttle(seconds: 0.3)
            .observeNext { [unowned self] text in
                if let text = text {
                    self.search(text)
                }
        }
    }

    // MARK - Methods

    func cellViewModel(for photo: Photo) -> PhotoCellViewModel {
        return PhotoCellViewModel(photo: photo)
    }

    // MARK: - Private methods

    /// Perform search of API with text
    ///
    /// - Parameter text: search text
    private func search(_ text: String) {
        networkManager.getPhotos(with: text) { result in
            switch result {
            case .success(let result):
                guard let photos = result.photos?.photo else { return }
                self.images.replace(with: photos)
            case .error(let error):
                // TODO: NSLog and handle error message
                print("\(error)")
            }
        }
    }
}
