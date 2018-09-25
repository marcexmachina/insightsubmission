//
//  HomeCollectionViewModel.swift
//  insightsubmission
//
//  Created by Marc O'Neill on 19/09/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import Foundation
import CoreLocation
import Bond

class HomeCollectionViewModel {
    private let networkManager: NetworkManagerProtocol!
    private let locationManager: LocationManager!
    private var initialLoadComplete: Bool = false

    var images = MutableObservableArray<Photo>([])
    var searchString = Observable<String?>("")
    var searchInProgress = Observable<Bool>(false)

    // MARK: - Lifecycle
    
    init(networkManager: NetworkManagerProtocol, locationManager: LocationManager) {
        self.networkManager = networkManager
        self.locationManager = locationManager

        _ = searchString
            .filter { $0!.count > 3 }
            .throttle(seconds: 0.3)
            .observeNext { [unowned self] text in
                if let text = text {
                    self.search(text)
                }
        }

        // Observe location update notifications
        NotificationCenter.default.addObserver(self, selector: #selector(searchByLocation(_:)), name: .locationDidUpdate, object: nil)
    }

    // MARK - Methods

    func cellViewModel(for photo: Photo) -> PhotoCellViewModel {
        return PhotoCellViewModel(photo: photo, networkManager: networkManager)
    }

    func images(for tag: String) {
        searchInProgress.value = true

        networkManager.getPhotos(tag: tag) { result in
            self.searchInProgress.value = false
            switch result {
            case .success(let result):
                guard let photos = result.photos?.photo else { return }

                // Stripping out photos without a medium and thumbnail sized image for simplicity sake
                let photosWithImageUrl = photos.filter { $0.urlMedium != nil && $0.urlLargeSquare != nil }

                self.images.replace(with: photosWithImageUrl)
            case .error(let error):
                NSLog("\(error.localizedDescription)")
            }
        }
    }

    // MARK: - Private methods

    /// Perform search of API with text
    ///
    /// - Parameter text: search text
    private func search(_ text: String) {
        searchInProgress.value = true
        
        networkManager.getPhotos(text: text) { result in
            self.searchInProgress.value = false
            switch result {
            case .success(let result):
                guard let photos = result.photos?.photo else { return }

                // Stripping out photos without a medium and thumbnail sized image for simplicity sake
                let photosWithImageUrl = photos.filter { $0.urlMedium != nil && $0.urlLargeSquare != nil }

                self.images.replace(with: photosWithImageUrl)
            case .error(let error):
                NSLog("\(error.localizedDescription)")
            }
        }
    }

    @objc private func searchByLocation(_ notification: Notification) {
        // Only want to do this once
        if !initialLoadComplete {
            searchInProgress.value = true
            guard let location = notification.object as? CLLocation else { return }

            networkManager.getPhotos(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { result in
                self.searchInProgress.value = false
                switch result {
                case .success(let result):
                    guard let photos = result.photos?.photo else { return }

                    // Stripping out photos without a medium and thumbnail sized image for simplicity sake
                    let photosWithImageUrl = photos.filter { $0.urlMedium != nil && $0.urlLargeSquare != nil }
                    
                    self.images.replace(with: photosWithImageUrl)
                    self.initialLoadComplete = false
                case .error(let error):
                    NSLog("\(error.localizedDescription)")
                }
            }
        }
    }
}
