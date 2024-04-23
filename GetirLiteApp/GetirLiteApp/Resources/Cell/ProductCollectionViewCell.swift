//
//  ProductCollectionViewCell.swift
//  GetirLiteApp
//
//  Created by Damla Sahin on 15.04.2024.
//

import UIKit
import Kingfisher
import ProductAPI

final class ProductCollectionViewCell: UICollectionViewCell {
    
    private lazy var productImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "marketIcon")
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Bold", size: 14)
        label.textColor = UIColor(named: "text-primary")
        label.textAlignment = .left
        label.text = "₺0,00"
        return label
    }()
    
    private lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-SemiBold", size: 12)
        label.textColor = UIColor(named: "text-dark")
        label.textAlignment = .left
        label.text = "Product Name"
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var attributeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-SemiBold", size: 12)
        label.textColor = UIColor(named: "text-secondary")
        label.textAlignment = .left
        label.text = "Attribute"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(productImageView)
        addSubview(priceLabel)
        addSubview(productNameLabel)
        addSubview(attributeLabel)
        
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        attributeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: topAnchor),
            productImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            productImageView.heightAnchor.constraint(equalToConstant: 92),
            
            priceLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            productNameLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor),
            productNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            productNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            attributeLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor),
            attributeLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            attributeLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            attributeLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension ProductCollectionViewCell {
    func configure(with product: Product, isInCart: Bool) {
        productNameLabel.text = product.name
        priceLabel.text = product.priceText
        attributeLabel.text = product.attribute
        
        let placeholderImage = UIImage(named: "marketIcon")
        if let urlString = product.bestAvailableURL, let url = URL(string: urlString) {
            productImageView.kf.setImage(with: url, placeholder: placeholderImage)
        } else {
            productImageView.image = placeholderImage
        }

        if isInCart {
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor(named: "text-primary")?.cgColor
            self.layer.cornerRadius = 10
        } else {
            self.layer.borderWidth = 0
            self.layer.borderColor = nil
            self.layer.cornerRadius = 0
        }
    }
}
