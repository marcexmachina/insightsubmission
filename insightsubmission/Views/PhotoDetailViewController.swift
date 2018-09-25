//
//  PhotoDetailViewController.swift
//  insightsubmission
//
//  Created by Marc O'Neill on 23/09/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import UIKit
import Bond

class PhotoDetailViewController: UIViewController, UICollectionViewDelegateFlowLayout {

    var viewModel: PhotoDetailViewModel!
    var collectionView: UICollectionView!
    var detailView: PhotoDetailView!

    // MARK: - Lifecycle

    convenience init(viewModel: PhotoDetailViewModel) {
        self.init()
        self.viewModel = viewModel
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 1, height: 1)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collectionView.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "TagsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TagsCollectionViewCell")
        detailView = PhotoDetailView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        detailView.configure(with: viewModel)

        setupInterface()
        bindViewModel()
    }

    // MARK: - Private Methods

    private func setupInterface() {
        view.addSubview(collectionView)
        view.addSubview(detailView)
        view.backgroundColor = .black

        let margins = view.layoutMarginsGuide
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true

        detailView.translatesAutoresizingMaskIntoConstraints = false
        detailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        detailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        detailView.bottomAnchor.constraint(equalTo: collectionView.topAnchor).isActive = true
        detailView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }

    private func bindViewModel() {
//        viewModel.tags.bind(to: collectionView, cellType: TagsCollectionViewCell.self) { (cell, tag) in
//            cell.tagLabel.text = tag
//        }.dispose(in: bag)

        viewModel.tags.bind(to: collectionView) { tags, indexPath, collectionView in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagsCollectionViewCell", for: indexPath) as! TagsCollectionViewCell
            let tag = tags[indexPath.item]

            cell.tagLabel.text = tag
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.tags[indexPath.row].size(withAttributes: nil)
    }
}
