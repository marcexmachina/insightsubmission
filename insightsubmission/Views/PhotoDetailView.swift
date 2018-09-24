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
    var containerView: UIView!
    var photoImageView: UIImageView!
    var nameLabel: UILabel!
    var sizeLabel: UILabel!
    var resolutionLabel: UILabel!
    var dateLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        containerView = UIView(frame: frame)
        photoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height / 2))
        nameLabel = UILabel()
        sizeLabel = UILabel()
        resolutionLabel = UILabel()
        dateLabel = UILabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with viewModel: PhotoDetailViewModel) {
        self.viewModel = viewModel
        setupInterface()
        setupBinding()
    }

    private func setupBinding() {
        viewModel.detailImage.bind(to: photoImageView.reactive.image).dispose(in: bag)
    }

    private func setupInterface() {
        addSubview(containerView)
        containerView.addSubview(photoImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(sizeLabel)
        containerView.addSubview(resolutionLabel)
        containerView.addSubview(dateLabel)

        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        photoImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        photoImageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, constant: 0.6).isActive = true
        photoImageView.contentMode = .scaleAspectFit

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 8).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        nameLabel.text = "test"
        nameLabel.textColor = .lightGray
    }

}
