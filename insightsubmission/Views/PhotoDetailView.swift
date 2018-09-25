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

    var nameLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .lightGray
        return label
    }()

    var sizeLabel: UILabel!
    var resolutionLabel: UILabel!
    var dateLabel: UILabel!
    var tagButtons: [UIButton] = []

    var tagsStackView: UIStackView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        containerView = UIView(frame: frame)
        photoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height / 2))
        sizeLabel = UILabel()
        resolutionLabel = UILabel()
        dateLabel = UILabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with viewModel: PhotoDetailViewModel) {
        self.viewModel = viewModel
        setupBinding()
//        tagButtons = viewModel.tags.map { tag -> UIButton in
//            let button = UIButton()
//            button.setTitle(tag, for: .normal)
//            button.backgroundColor = .white
//            button.setTitleColor(.black, for: .normal)
//            return button
//        }

        tagsStackView = UIStackView(arrangedSubviews: tagButtons)
        setupInterface()
    }

    private func setupBinding() {
        viewModel.detailImage.bind(to: photoImageView.reactive.image)
        viewModel.name.bind(to: nameLabel.reactive.text)
        viewModel.date.bind(to: dateLabel.reactive.text)
    }

    private func setupInterface() {
        addSubview(containerView)
        containerView.addSubview(photoImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(sizeLabel)
        containerView.addSubview(resolutionLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(tagsStackView)

        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        tagsStackView.translatesAutoresizingMaskIntoConstraints = false

        let margins = layoutMarginsGuide
        containerView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true

        tagsStackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -8).isActive = true
        tagsStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        tagsStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.bottomAnchor.constraint(equalTo: tagsStackView.topAnchor, constant: -8).isActive = true
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

        tagsStackView.axis = .horizontal
        tagsStackView.distribution = .fillEqually
        tagsStackView.alignment = .center
        tagsStackView.spacing = 5

//        print("Number buttons:: \(tagButtons.count)")
    }

    private func setupButtons() {

    }

}
