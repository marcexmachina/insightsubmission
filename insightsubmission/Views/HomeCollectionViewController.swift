//
//  HomeCollectionViewController.swift
//  insightsubmission
//
//  Created by Marc O'Neill on 16/09/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import UIKit

class HomeCollectionViewController: UIViewController {

    private let networkManager: NetworkManagerProtocol!
    private let viewModel: HomeScreenViewModel!

    let collectionView: UICollectionView!
    let searchBar: UISearchBar!

    // MARK: - Lifecycle

    required init?(coder aDecoder: NSCoder) {
        networkManager = FlickrAPIClient(session: URLSession.shared)
        viewModel = HomeScreenViewModel(networkManager: networkManager)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 150)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.prefetchDataSource = self
        setupUI()
        bindViewModel()
    }

    // MARK: - Private Methods

    private func bindViewModel() {
        viewModel.images.bind(to: collectionView) { array, indexPath, collectionView in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PhotoCollectionViewCell
//
//            repository.photo
//                .bind(to: cell.avatarImageView)
//                .dispose(in: cell.onReuseBag)

            let photo = array[indexPath.item]
            let cellViewModel = self.viewModel.cellViewModel(for: photo)
            cell.configure(with: cellViewModel)

            // Check cache for image, otherwise start download
            let key = photo.thumbnailUrl()
            if let cachedData = ImageCache.shared.imageData(forKey: key) {
                if let image = UIImage(data: cachedData) {
                    cellViewModel.image.value = image
                }
            } else {
                self.networkManager.startDownload(for: photo, at: indexPath) { [unowned self] in
                    self.collectionView.reloadItems(at: [indexPath])
                }
            }
            return cell
        }

        viewModel.searchString.bidirectionalBind(to: searchBar.reactive.text)
    }

    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false

        let margins = view.layoutMarginsGuide

        searchBar.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true

        // Setup collectionView constraints
        collectionView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        collectionView.backgroundColor = .red
   }
}

extension HomeCollectionViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let photo = viewModel.images[indexPath.row]
            let key = photo.thumbnailUrl()

            // Return early if image is already cached
            guard ImageCache.shared.imageData(forKey: key) == nil else { return }

            self.networkManager.startDownload(for: photo, at: indexPath) { [unowned self] in
                self.collectionView.reloadItems(at: [indexPath])
            }
        }
    }


}

