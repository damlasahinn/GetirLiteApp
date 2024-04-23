//
//  BaseViewController.swift
//  GetirLiteApp
//
//  Created by Damla Sahin on 11.04.2024.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func showAlert(title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let actionButtonColor = UIColor(named: "text-primary") ?? UIColor.black

        for action in actions {
            alert.addAction(action)
            action.setValue(actionButtonColor, forKey: "titleTextColor")
        }
        
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}
