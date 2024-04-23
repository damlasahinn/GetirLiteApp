//
//  ProductDetailViewController.swift
//  GetirLiteApp
//
//  Created by Damla Sahin on 11.04.2024.
//

import UIKit
import ProductAPI

protocol ProductDetailViewControllerProtocol: AnyObject {
    func displayProductDetails(_ product: Product)
    func setProduct(_ product: Product)
    func showAddToCartButton()
    func showStepperView(with quantity: Int32)
    func reloadCoreData()
    func updateCartValue(total: Double)
}

final class ProductDetailViewController: BaseViewController {
    
    private lazy var customNavigationBar: UIView = {
        let navBar = UIView()
        navBar.backgroundColor = UIColor(named: "text-primary")
        return navBar
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Ürün Detayı"
        label.textColor = .white
        label.font = UIFont(name: "OpenSans-Bold", size: 14)
        label.textAlignment = .center
        return label
    }()
    private lazy var pageView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var buttonView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "marketIcon")
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "₺0,00"
        label.font = UIFont(name: "OpenSans-Bold", size: 20)
        label.textColor = UIColor(named: "text-primary")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Product Name"
        label.font = UIFont(name: "OpenSans-Semibold", size: 16)
        label.textColor = UIColor(named: "text-dark")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var attributeLabel: UILabel = {
        let label = UILabel()
        label.text = "Attribute"
        label.font = UIFont(name: "OpenSans-Semibold", size: 12)
        label.textColor = UIColor(named: "text-secondary")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sepete Ekle", for: .normal)
        button.titleLabel?.font = UIFont(name: "OpenSans-Bold", size: 14)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(named: "text-primary")
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        button.layer.shadowColor = UIColor.black.withAlphaComponent(0.12).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: -4)
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 1
        
        return button
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(didTapCartButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var cartValueLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var stepperView: StepperView = {
        let view = StepperView()
        view.delegate = self
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let spacing: CGFloat = 4
    var presenter: ProductDetailPresenterProtocol!
    var product: Product?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        presenter.viewDidLoad()
        setupLeftBarButtonItem()
        setupCartButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
    }
    
    private func setupCartButton() {
        let labelBackgroundView = UIView()
        labelBackgroundView.backgroundColor = UIColor(named: "text-bg-primary-subtle")
        labelBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        labelBackgroundView.layer.cornerRadius = 8
        labelBackgroundView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        cartButton.addSubview(labelBackgroundView)
        
        let cartIconImageView = UIImageView(image: UIImage(named: "cartIcon"))
        cartButton.addSubview(cartIconImageView)
        cartIconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cartIconImageView.leadingAnchor.constraint(equalTo: cartButton.leadingAnchor, constant: 10),
            cartIconImageView.centerYAnchor.constraint(equalTo: cartButton.centerYAnchor),
            cartIconImageView.widthAnchor.constraint(equalToConstant: 24),
            cartIconImageView.heightAnchor.constraint(equalToConstant: 24)
        ])

        cartValueLabel.text = "₺0,00"
        cartValueLabel.font = UIFont(name: "OpenSans-Bold", size: 14)
        cartValueLabel.textColor = UIColor(named: "text-primary")
        labelBackgroundView.addSubview(cartValueLabel)
        cartValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelBackgroundView.leadingAnchor.constraint(equalTo: cartIconImageView.trailingAnchor, constant: 10),
            labelBackgroundView.trailingAnchor.constraint(equalTo: cartButton.trailingAnchor),
            labelBackgroundView.topAnchor.constraint(equalTo: cartButton.topAnchor),
            labelBackgroundView.bottomAnchor.constraint(equalTo: cartButton.bottomAnchor),
            
            cartValueLabel.leadingAnchor.constraint(equalTo: labelBackgroundView.leadingAnchor, constant: 10),
            cartValueLabel.trailingAnchor.constraint(equalTo: labelBackgroundView.trailingAnchor, constant: -10),
            cartValueLabel.centerYAnchor.constraint(equalTo: labelBackgroundView.centerYAnchor)
        ])

        cartButton.layer.cornerRadius = 8
        cartButton.backgroundColor = .white
        cartButton.clipsToBounds = true


        let cartBarButtonItem = UIBarButtonItem(customView: cartButton)
        navigationItem.rightBarButtonItem = cartBarButtonItem

        cartButton.layoutIfNeeded()
    }
    
    private func setupLeftBarButtonItem() {
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        let leftBarItem = UIBarButtonItem(customView: closeButton)
        
        self.navigationItem.leftBarButtonItem = leftBarItem
        self.navigationItem.leftBarButtonItem?.tintColor = .white
        self.navigationItem.hidesBackButton = true
    }
    
    private func updateCartButtonValue(total: Double) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","

        let formattedTotal = formatter.string(from: NSNumber(value: total)) ?? "₺0,00"
        let title = "₺\(formattedTotal)"
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "OpenSans-Bold", size: 14) ?? UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor(named: "text-primary") ?? UIColor.black
        ]
        
        let attributedTitle = NSAttributedString(string: title, attributes: titleAttributes)
        cartValueLabel.attributedText = attributedTitle
    }
    
    @objc private func didTapCartButton() {
        presenter?.navigateToCart(.cart)
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        setupNavigationBar()
        setupPageView()
        setupButtonView()
    }
    
    private func setupButtonView() {
        view.addSubview(buttonView)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            buttonView.heightAnchor.constraint(equalToConstant: 98),
            buttonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        buttonView.addSubview(addToCartButton)
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addToCartButton.heightAnchor.constraint(equalToConstant: 50),
            addToCartButton.widthAnchor.constraint(equalToConstant: 375),
            addToCartButton.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor),
            addToCartButton.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor, constant: 16),
            addToCartButton.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor, constant: -16)
        ])
        
        applyShadow(to: buttonView)
        
        buttonView.addSubview(stepperView)
        stepperView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stepperView.centerXAnchor.constraint(equalTo: buttonView.centerXAnchor),
            stepperView.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor),
            stepperView.widthAnchor.constraint(equalToConstant: 146),
            stepperView.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        applyShadow(to: stepperView)
    
    }
    
    private func setupNavigationBar() {
        view.addSubview(customNavigationBar)
        customNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            customNavigationBar.topAnchor.constraint(equalTo: view.topAnchor),
            customNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavigationBar.heightAnchor.constraint(equalToConstant: 88)
        ])
        
        customNavigationBar.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: customNavigationBar.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: customNavigationBar.bottomAnchor, constant: -10),
            titleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupPageView() {
        view.addSubview(pageView)
        pageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageView.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor),
            pageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageView.heightAnchor.constraint(equalToConstant: 319)
        ])
        
        pageView.addSubview(productImageView)
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: pageView.topAnchor, constant: spacing),
            productImageView.centerXAnchor.constraint(equalTo: pageView.centerXAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: 200),
            productImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        pageView.addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: spacing),
            priceLabel.centerXAnchor.constraint(equalTo: pageView.centerXAnchor),
            priceLabel.widthAnchor.constraint(equalToConstant: 343),
            priceLabel.heightAnchor.constraint(equalToConstant: 27)
        ])
        
        pageView.addSubview(productNameLabel)
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            productNameLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: spacing),
            productNameLabel.centerXAnchor.constraint(equalTo: pageView.centerXAnchor),
            productNameLabel.widthAnchor.constraint(equalToConstant: 343),
            productNameLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        pageView.addSubview(attributeLabel)
        attributeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            attributeLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: spacing),
            attributeLabel.centerXAnchor.constraint(equalTo: pageView.centerXAnchor),
            attributeLabel.widthAnchor.constraint(equalToConstant: 343),
            attributeLabel.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        applyShadow(to: pageView)
    }

    
    func applyShadow(to view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.masksToBounds = false
    }
    
    @objc private func closeButtonTapped() {
        presenter?.closeViewController()
    }
    
    @objc private func addToCartButtonTapped() {
        guard let product = product else {
            print("No product to add to cart")
            return
        }
        if let quantity = product.quantity {
            showStepperView(with: quantity)
        } else {
            showStepperView(with: 1)
        }
        presenter.saveProductDetails(product)
        presenter.viewDidAppear()
    }
    
    @objc private func cartButtonTapped() {
        presenter.navigateToCart(.cart)
    }
}

extension ProductDetailViewController: ProductDetailViewControllerProtocol {
    func reloadCoreData() {
        presenter.refreshProductDetails()
    }
    
    func updateCartValue(total: Double) {
        DispatchQueue.main.async {
            self.updateCartButtonValue(total: total)
        }
    }
    
    func displayProductDetails(_ product: Product) {
        productNameLabel.text = product.name
        priceLabel.text = product.priceText
        attributeLabel.text = product.attribute
        if let imageURL = product.imageURL, let url = URL(string: imageURL) {
            productImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholderImage"))
        }
        
        self.product = product
    }
    
    func setProduct(_ product: Product) {
        self.product = product
    }
    
    func showAddToCartButton() {
        addToCartButton.isHidden = false
        stepperView.isHidden = true
        cartButton.isHidden = true
    }

    func showStepperView(with quantity: Int32) {
        addToCartButton.isHidden = true
        stepperView.isHidden = false
        stepperView.setCount(quantity)
        cartButton.isHidden = false
    }

}

extension ProductDetailViewController: StepperViewDelegate {
    func stepperView(_ stepperView: StepperView, didUpdateQuantity quantity: Int32, forProductId productId: String) {
       //TODO: make this optional
    }
    
    func stepperViewDidTapIncrease(_ stepperView: StepperView) {
        guard let product = product, let productId = product.id else {
            return
        }
        presenter.increaseProductQuantity(productId: productId)
        presenter.viewDidAppear()
    }
    
    func stepperViewDidTapDecrease(_ stepperView: StepperView) {
        guard let product = product, let productId = product.id else { return }
        if stepperView.getCount() > 0 {
            presenter.decreaseProductQuantity(productId: productId)
            presenter.viewDidAppear()
        } else {
            presenter.deleteProduct(productId: productId)
        }
    }
    
    func stepperViewDidTapDelete(_ stepperView: StepperView) {
        guard let product = product, let productId = product.id else { return }
        presenter.deleteProduct(productId: productId)
    }
}
