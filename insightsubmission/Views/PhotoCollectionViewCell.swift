//
//  PhotoCollectionViewCell.swift
//  insightsubmission
//
//  Created by Marc O'Neill on 19/09/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import UIKit
import Bond

class PhotoCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView
    var viewModel: PhotoCellViewModel? = nil
    var imageKey: String?

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        imageView = UIImageView()
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func configure(with viewModel: PhotoCellViewModel) {
        self.viewModel = viewModel
        imageView.image = nil
        imageKey = viewModel.imageKey
        addSubview(imageView)
        backgroundColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        imageView.contentMode = .scaleAspectFit
        setupBinding()
    }

    // MARK: - Private methods
    
    private func setupBinding() {
        viewModel?.image.bind(to: imageView.reactive.image)
    }
}
