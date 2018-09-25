//
//  TagsCollectionViewCell.swift
//  insightsubmission
//
//  Created by Marc O'Neill on 25/09/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import UIKit

class TagsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tagLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 4
        contentView.layer.opacity = 0.8
        contentView.backgroundColor = .white
    }
}
