//
//  ProductTableViewCell.swift
//  GetirLiteApp
//
//  Created by Damla Sahin on 18.04.2024.
//

import UIKit
import Kingfisher
import ProductAPI

protocol ProductCellDelegate: AnyObject {
    func productCell(_ cell: ProductTableViewCell, didUpdateQuantity quantity: Int32, forProductId productId: String)
}

class ProductTableViewCell: UITableViewCell {
    
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //TODO: borderColor
        return imageView
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "OpenSans-Semibold", size: 12)
        label.textColor = UIColor(named: "text-dark")
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "OpenSans-Bold", size: 14)
        label.textColor = UIColor(named: "text-primary")
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private lazy var attributeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "OpenSans-Semibold", size: 12)
        label.textColor = UIColor(named: "text-secondary")
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
     lazy var stepperView: StepperView = {
        let stepper = StepperView()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        return stepper
    }()
    
    var productId: String?
    weak var delegate: ProductCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(verticalStackView)

        verticalStackView.addArrangedSubview(thumbnailImageView)
        verticalStackView.addArrangedSubview(horizontalStackView)
        
        horizontalStackView.addArrangedSubview(productNameLabel)
        horizontalStackView.addArrangedSubview(attributeLabel)
        horizontalStackView.addArrangedSubview(priceLabel)

        verticalStackView.addArrangedSubview(stepperView)

        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 74),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 74)
        ])
    }

    
    func configure(with product: Product) {
        productNameLabel.text = product.name
        priceLabel.text = product.priceText
        attributeLabel.text = product.attribute
        
        let placeholderImage = UIImage(named: "defaultPlaceholder")
        if let urlString = product.bestAvailableURL, let url = URL(string: urlString) {
            thumbnailImageView.kf.setImage(
                with: url,
                placeholder: placeholderImage,
                options: nil,
                progressBlock: nil) { result in
                    switch result {
                    case .success(let value):
                        print("Image: \(value.image). Got from: \(value.cacheType)")
                    case .failure(let error):
                        print("Error: \(error)")
                    }
            }
        } else {
            thumbnailImageView.image = placeholderImage
        }
        
        stepperView.setCount(product.quantity ?? 0)
    }

    func configureStepper(with quantity: Int32) {
        stepperView.setCount(quantity)
    }
}
