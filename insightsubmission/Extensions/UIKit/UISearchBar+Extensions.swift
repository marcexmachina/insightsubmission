//
//  UISearchBar+Extensions.swift
//  insightsubmission
//
//  Created by Marc O'Neill on 24/09/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import UIKit

extension UISearchBar {
    var isLoading: Bool {
        get {
            return activityIndicator != nil
        } set {
            if newValue {
                if activityIndicator == nil {
                    let newActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                    newActivityIndicator.startAnimating()
                    newActivityIndicator.backgroundColor = UIColor.white
                    textField?.leftView?.addSubview(newActivityIndicator)
                    let leftViewSize = textField?.leftView?.frame.size ?? CGSize.zero
                    newActivityIndicator.center = CGPoint(x: leftViewSize.width/2, y: leftViewSize.height/2)
                }
            } else {
                activityIndicator?.removeFromSuperview()
            }
        }
    }

    private var textField: UITextField? {
        let subViews = subviews.flatMap { $0.subviews }
        guard let textField = (subViews.filter { $0 is UITextField }).first as? UITextField else {
            return nil
        }
        return textField
    }

    private var activityIndicator: UIActivityIndicatorView? {
        return textField?.leftView?.subviews.compactMap { $0 as? UIActivityIndicatorView }.first
    }
}
