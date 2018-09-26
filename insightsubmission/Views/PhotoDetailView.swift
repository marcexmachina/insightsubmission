//
//  PhotoDetailView.swift
//  insightsubmission
//
//  Created by Marc O'Neill on 24/09/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import UIKit

class PhotoDetailView: UIView {
    private var viewModel: PhotoDetailViewModel!

    var containerView: UIView
    var photoImageView: UIImageView
    var dateLabel: UILabel

    var nameLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .lightGray
        return label
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        containerView = UIView(frame: frame)
        photoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height / 2))
        dateLabel = UILabel()
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func configure(with viewModel: PhotoDetailViewModel) {
        self.viewModel = viewModel
        setupBinding()
        setupInterface()
    }

    // MARK: - Private Methods

    private func setupBinding() {
        viewModel.detailImage.bind(to: photoImageView.reactive.image)
        viewModel.name.bind(to: nameLabel.reactive.text)
        viewModel.date.bind(to: dateLabel.reactive.text)
    }

    private func setupInterface() {
        addSubview(containerView)
        containerView.addSubview(photoImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(dateLabel)

        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false

        let margins = layoutMarginsGuide
        containerView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true

        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        dateLabel.textColor = .lightGray

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -8).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true

        photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        photoImageView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -8).isActive = true
        photoImageView.contentMode = .scaleAspectFit
    }
}
