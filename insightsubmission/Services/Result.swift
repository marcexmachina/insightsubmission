//
//  Result.swift
//  insightsubmission
//
//  Created by Marc O'Neill on 16/09/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(Error)
}
