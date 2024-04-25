//
//  CustomAlertViewController.swift
//  GetirLiteApp
//
//  Created by Damla Sahin on 24.04.2024.
//

import UIKit
import MapKit

class CustomAlertViewController: UIViewController {
    var mapView = MKMapView()
    var messageLabel = UILabel()
    var dismissButton = UIButton()
    var totalLabel = UILabel()

    var shouldShowMap: Bool = false
    var total: Double?
    
    let latitude = 39.879990
    let longitude = 32.698970
    
    var onDismiss: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "bg-body")
        setupView()
    }

    func setupView() {
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = "Siparişiniz hazırlanıyor. Kuryeniz yola çıktığında siparişi izleyebilirsiniz."
        messageLabel.textColor = UIColor(named: "text-dark")
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont(name: "OpenSans-Semibold", size: 12)
        messageLabel.textAlignment = .center
        
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        totalLabel.textColor = .red
        totalLabel.textAlignment = .center
        totalLabel.font = UIFont(name: "OpenSans-Bold", size: 14)
        totalLabel.textColor = UIColor(named: "text-dark")

        mapView.translatesAutoresizingMaskIntoConstraints = false
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.title = "Getir"
        mapView.addAnnotation(annotation)

        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.setTitle("Tamam", for: .normal)
        dismissButton.backgroundColor = UIColor(named: "text-primary")
        dismissButton.layer.cornerRadius = 10
        dismissButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        view.addSubview(messageLabel)
        view.addSubview(totalLabel)
        view.addSubview(mapView)
        view.addSubview(dismissButton)

        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            totalLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10),
            totalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            totalLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            mapView.topAnchor.constraint(equalTo: totalLabel.bottomAnchor, constant: 20),
            mapView.heightAnchor.constraint(equalToConstant: 180),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            dismissButton.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 20),
            dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dismissButton.widthAnchor.constraint(equalToConstant: 100),
            dismissButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        mapView.isHidden = !shouldShowMap
        messageLabel.isHidden = !shouldShowMap
        dismissButton.isHidden = !shouldShowMap
        totalLabel.isHidden = !shouldShowMap
    }
    
    func configureView(withTotal total: Double) {
        self.total = total
        totalLabel.text = "Toplam: \(CompleteButton.formatPrice(total))"
    }

    @objc func dismissAlert() {
        self.dismiss(animated: true, completion: nil)
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
