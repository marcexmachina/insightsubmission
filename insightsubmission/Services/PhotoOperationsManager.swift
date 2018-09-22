//
//  OperationsManager.swift
//  insightsubmission
//
//  Created by Marc O'Neill on 22/09/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import Foundation

/// Class to keep track of active/pending image downloads
class PhotosOperationsManager {
    lazy var operationsInProgress: [IndexPath: Operation] = [:]
    lazy var downloadQueue = OperationQueue()
}
