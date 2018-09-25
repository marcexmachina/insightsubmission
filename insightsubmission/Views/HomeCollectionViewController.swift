//
//  HomeCollectionViewController.swift
//  insightsubmission
//
//  Created by Marc O'Neill on 16/09/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import UIKit

protocol TagSearchDelegate: class {
    func search(tag: String)
}

class HomeCollectionViewController: UIViewController {

    private let networkManager: NetworkManagerProtocol!
    private let viewModel: HomeCollectionViewModel!

    let collectionView: UICollectionView!

    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        return searchBar
    }()

    // MARK: - Lifecycle

    required init?(coder aDecoder: NSCoder) {
        networkManager = FlickrAPIClient(session: URLSession.shared)
        viewModel = HomeCollectionViewModel(networkManager: networkManager, locationManager: LocationManager.shared)

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 150)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")

        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.isPrefetchingEnabled = false
        collectionView.delegate = self
        setupUI()
        bindViewModel()
    }

    // MARK: - Private Methods

    private func bindViewModel() {
        // Bind collectionView to datasource

        viewModel
            .images
            .bind(to: collectionView) { array, indexPath, collectionView in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PhotoCollectionViewCell
                cell.imageView.image = nil
                let photo = array[indexPath.item]
                let cellViewModel = self.viewModel.cellViewModel(for: photo)
                cell.configure(with: cellViewModel)
                let key = photo.thumbnailUrl()!

                ImageCache.shared.imageData(key: key) { data in
                    guard let data = data, let image = UIImage(data: data) else {
                        DispatchQueue.main.async {
                            guard let indexPath = self.collectionView.indexPath(for: cell) else { return }

                            self.networkManager.startDownload(for: photo, at: indexPath) {
                                if let _ = self.collectionView.cellForItem(at: indexPath) {
                                    self.collectionView.reloadItems(at: [indexPath])
                                }
                            }
                        }
                        return
                    }

                    // Ensure we're setting the correct image for the correct cell
                    if cellViewModel.imageKey == cell.imageKey {
                        cellViewModel.image.value = image
                    }
                }

                return cell
        }.dispose(in: bag)

        // Cell selection
        collectionView
            .reactive
            .selectedItemIndexPath
            .observeNext { [weak self] indexPath in
                guard let cell = self?.collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell,
                    let viewModel = cell.viewModel else {
                    return
                }

                let detailController = PhotoDetailViewController(viewModel: viewModel.detailViewModel(), delegate: self!)
                self?.navigationController?.pushViewController(detailController, animated: true)
        }.dispose(in: bag)

        viewModel
            .searchString
            .bidirectionalBind(to: searchBar.reactive.text)
            .dispose(in: bag)

        viewModel
            .searchInProgress
            .observeOn(.main)
            .observeNext { [weak self] value in
                DispatchQueue.main.async {
                    self?.searchBar.isLoading = value
                }
        }.dispose(in: bag)
    }

    private func setupUI() {
        self.navigationItem.titleView = searchBar

        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false

        let margins = view.layoutMarginsGuide

        // Setup collectionView constraints
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.backgroundColor = .lightGray
   }
}

// MARK: - UIScrollViewDelegate
extension HomeCollectionViewController: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            searchBar.endEditing(true)
        }
    }
}

extension HomeCollectionViewController: TagSearchDelegate {
    func search(tag: String) {
        searchBar.text = tag
        viewModel.images(for: tag)
    }
}

