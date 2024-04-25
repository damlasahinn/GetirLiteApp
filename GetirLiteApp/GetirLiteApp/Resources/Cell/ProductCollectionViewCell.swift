//
//  ProductCollectionViewCell.swift
//  GetirLiteApp
//
//  Created by Damla Sahin on 15.04.2024.
//

import UIKit
import Kingfisher
import ProductAPI

protocol ProductCollectionViewCellDelegate: AnyObject {
    func stepperDidIncrease(in cell: ProductCollectionViewCell)
    func stepperDidDecrease(in cell: ProductCollectionViewCell)
    func stepperDidDelete(in cell: ProductCollectionViewCell)
}

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
    
    lazy var stepperView: StepperView = {
       let stepper = StepperView()
       stepper.translatesAutoresizingMaskIntoConstraints = false
       return stepper
   }()
    
    let stepper = StepperView()
    var product: Product?
    
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
        
        clipsToBounds = false
        
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
    func configure(with product: Product, isInCart: Bool, quantity: Int32) {
        self.product = product
        productNameLabel.text = product.name
        priceLabel.text = product.priceText
        attributeLabel.text = product.attribute
        
        let placeholderImage = UIImage(named: "marketIcon")
        if let urlString = product.bestAvailableURL, let url = URL(string: urlString) {
            productImageView.kf.setImage(with: url, placeholder: placeholderImage)
        } else {
            productImageView.image = placeholderImage
        }
        stepperView.removeFromSuperview()
        
        if isInCart {
            productImageView.layer.borderWidth = 1
            productImageView.layer.borderColor = UIColor(named: "text-primary")?.cgColor
            productImageView.layer.cornerRadius = 10
            
            stepper.stackViewOrientation = .vertical
            stepperView = stepper
            contentView.addSubview(stepper)
            
            stepper.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                stepper.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
                stepper.topAnchor.constraint(equalTo: topAnchor),
                stepper.widthAnchor.constraint(equalToConstant: 35),
                stepper.heightAnchor.constraint(equalToConstant: 105),
            ])
        } else {
            productImageView.layer.borderWidth = 0
            productImageView.layer.borderColor = nil
            productImageView.layer.cornerRadius = 0
        }
        
        
        stepperView.setCount(quantity)
        
    }
    
    func configureStepper(with quantity: Int32) {
        stepperView.setCount(quantity)
    }
}
