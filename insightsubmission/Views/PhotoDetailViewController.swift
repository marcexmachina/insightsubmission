//
//  PhotoDetailViewController.swift
//  insightsubmission
//
//  Created by Marc O'Neill on 23/09/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {

    var viewModel: PhotoDetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        let detailView = PhotoDetailView(frame: view.bounds)
        view.addSubview(detailView)
        detailView.configure(with: viewModel)
    }
}
