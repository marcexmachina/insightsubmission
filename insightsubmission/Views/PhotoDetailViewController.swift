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

    weak var delegate: TagSearchDelegate?
    var viewModel: PhotoDetailViewModel!
    var collectionView: UICollectionView!
    var detailView: PhotoDetailView!
    
    var tagsHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "TAGS"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 14.0)
        return label
    }()

    // MARK: - Lifecycle

    convenience init(viewModel: PhotoDetailViewModel, delegate: TagSearchDelegate) {
        self.init()
        self.viewModel = viewModel
        self.delegate = delegate
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
        view.addSubview(tagsHeaderLabel)
        view.backgroundColor = .black

        let margins = view.layoutMarginsGuide
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.16).isActive = true

        detailView.translatesAutoresizingMaskIntoConstraints = false
        detailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        detailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        detailView.bottomAnchor.constraint(equalTo: tagsHeaderLabel.topAnchor, constant: -6).isActive = true
        detailView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true

        tagsHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        tagsHeaderLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        tagsHeaderLabel.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -6).isActive = true
    }

    private func bindViewModel() {
        viewModel
            .tags
            .bind(to: collectionView) { tags, indexPath, collectionView in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagsCollectionViewCell", for: indexPath) as! TagsCollectionViewCell
                let tag = tags[indexPath.item]

                cell.tagLabel.text = tag
                return cell
        }.dispose(in: bag)

        // tag selection

        collectionView
            .reactive
            .selectedItemIndexPath
            .observeNext { indexPath in
                self.delegate?.search(tag: self.viewModel.tags[indexPath.row])
                _ = self.navigationController?.popViewController(animated: true)
        }.dispose(in: bag)
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let calculatedSize = viewModel.tags[indexPath.row].size(withAttributes: nil)
        return CGSize(width: calculatedSize.width + 12, height: calculatedSize.height + 12)
    }
}
