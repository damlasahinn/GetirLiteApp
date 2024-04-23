//
//  LoadingShowable.swift
//  GetirLiteApp
//
//  Created by Damla Sahin on 23.04.2024.
//

import UIKit

protocol LoadingShowable where Self: UIViewController {
    func showLoading()
    func hideLoading()
}

extension LoadingShowable {
    func showLoading() {
        LoadingView.shared.startLoading()
    }
    
    func hideLoading() {
        LoadingView.shared.hideLoading()
    }
}
