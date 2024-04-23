//
//  CompleteButton.swift
//  GetirLiteApp
//
//  Created by Damla Sahin on 20.04.2024.
//

import UIKit

class CompleteButton: UIButton {
    
    private lazy var completeView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "text-primary")
        return view
    }()
    
    private lazy var completeLabel: UILabel = {
        let label = UILabel()
        label.text = "Siparişi Tamamla"
        label.font = UIFont(name: "OpenSans-Bold", size: 14)
        label.textColor = .white
        return label
    }()
    
    private lazy var totalView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.text = CompleteButton.formatPrice(0)
        label.font = UIFont(name: "OpenSans-Bold", size: 20)
        label.textColor = UIColor(named: "text-primary")
        return label
    }()
    
    static func formatPrice(_ price: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return "₺" + (formatter.string(from: NSNumber(value: price)) ?? "0,00")
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        layer.cornerRadius = 10
        clipsToBounds = true
        addSubview(completeView)
        completeView.addSubview(completeLabel)
        
        addSubview(totalView)
        totalView.addSubview(totalLabel)
        
        completeView.translatesAutoresizingMaskIntoConstraints = false
        completeLabel.translatesAutoresizingMaskIntoConstraints = false
        totalView.translatesAutoresizingMaskIntoConstraints = false
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            completeView.leadingAnchor.constraint(equalTo: leadingAnchor),
            completeView.widthAnchor.constraint(equalToConstant: 234),
            completeView.heightAnchor.constraint(equalToConstant: 50),
            completeView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            completeLabel.centerXAnchor.constraint(equalTo: completeView.centerXAnchor),
            completeLabel.centerYAnchor.constraint(equalTo: completeView.centerYAnchor),
            
            totalView.leadingAnchor.constraint(equalTo: completeView.trailingAnchor),
            totalView.trailingAnchor.constraint(equalTo: trailingAnchor),
            totalView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            totalLabel.centerXAnchor.constraint(equalTo: totalView.centerXAnchor),
            totalLabel.centerYAnchor.constraint(equalTo: totalView.centerYAnchor)
        ])
    }
    
}
