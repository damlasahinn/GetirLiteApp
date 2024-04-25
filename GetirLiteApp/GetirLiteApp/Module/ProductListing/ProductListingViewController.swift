//
//  ViewController.swift
//  GetirLiteApp
//
//  Created by Damla Sahin on 10.04.2024.
//

import UIKit
import ProductAPI

protocol ProductListingViewControllerProtocol: AnyObject {
    func showLoadingView()
    func hideLoadingView()
    func displayProducts(_ products: [ProductResponse], for type: CollectionViewType)
    func displayError(_ error: String)
    func reloadData()
    func updateCartValue(total: Double)
    func updateCartProductsIDs(_ ids: [String])
    func displayCartProducts(_ products: [Product])
    func reloadQuantity(_ quantity: Int32,_ productId: String)
}

enum CollectionViewType {
    case horizontal
    case vertical
}

final class ProductListingViewController: BaseViewController, LoadingShowable {
    
    private lazy var customNavigationBar: UIView = {
        let navBar = UIView()
        navBar.backgroundColor = UIColor(named: "text-primary")
        navBar.isUserInteractionEnabled = true
        return navBar
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Ürünler"
        label.textColor = .white
        label.font = UIFont(name: "OpenSans-Bold", size: 14)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(didTapCartButton), for: .touchUpInside)
        button.accessibilityIdentifier = "listingCartButton"
        return button
    }()
    
    private lazy var cartValueLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var horizontalCollectionView: UICollectionView = {
        let layout = createHorizontalCompositionalLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: "ProductCollectionViewCell")
        collectionView.accessibilityIdentifier = "horizontalCollectionView"
        return collectionView
    }()
    
    private lazy var verticalCollectionView: UICollectionView = {
        let layout = createVerticalCompositionalLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: "ProductCollectionViewCell")
        collectionView.accessibilityIdentifier = "verticalCollectionView"
        return collectionView
    }()
    
    var presenter: ProductListingPresenterProtocol?
    
    private var horizontalProducts: [ProductResponse] = []
    private var verticalProducts: [ProductResponse] = []
    
    private var productsInCartIDs: [String] = []
    private var cartProducts: [Product] = [] {
        didSet {
            reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "mainScreen"
        setupViews()
        setupCollectionView()
        setupCartButton()
        presenter?.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.viewDidAppear()
        presenter?.fetchFromCart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor(named: "bg-body")
        setupNavigationBar()
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
        
        labelBackgroundView.isUserInteractionEnabled = false
        cartIconImageView.isUserInteractionEnabled = false

        cartButton.layer.cornerRadius = 8
        cartButton.backgroundColor = .white
        cartButton.clipsToBounds = true


        let cartBarButtonItem = UIBarButtonItem(customView: cartButton)
        navigationItem.rightBarButtonItem = cartBarButtonItem

        cartButton.layoutIfNeeded()
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
        let cartValue = cartValueLabel.text?.replacingOccurrences(of: "₺", with: "")
        if cartValue == "0,00" || cartValue == "0" {
            let okAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
            showAlert(title: "Sepetiniz boş.", message: "Lütfen ürün ekleyiniz.", actions: [okAction])
        } else {
            presenter?.navigateToCart(.cart)
        }
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
    
    private func setupCollectionView() {
        view.addSubview(horizontalCollectionView)
        NSLayoutConstraint.activate([
            horizontalCollectionView.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor, constant: 16),
            horizontalCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            horizontalCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            horizontalCollectionView.heightAnchor.constraint(equalToConstant: 185)
        ])
        
        view.addSubview(verticalCollectionView)
        NSLayoutConstraint.activate([
            verticalCollectionView.topAnchor.constraint(equalTo: horizontalCollectionView.bottomAnchor, constant: 16),
            verticalCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 8),
            verticalCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            verticalCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        self.navigationItem.hidesBackButton = true
    }
    
    func createHorizontalCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 104, height: 156)
        return layout
    }
    
    func createVerticalCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let padding: CGFloat = 16
        let availableWidth = view.frame.width - (padding * 2)
        let itemsPerRow: CGFloat = 3
        let spacing: CGFloat = 10
        let totalSpacing = (itemsPerRow - 1) * spacing
        let adjustedWidth = (availableWidth - totalSpacing) / itemsPerRow
        let itemHeight: CGFloat = 156
        layout.itemSize = CGSize(width: adjustedWidth, height: itemHeight)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        return layout
    }
}

extension ProductListingViewController: ProductListingViewControllerProtocol {
    func reloadQuantity(_ quantity: Int32,_ productId: String) {
        if let index = self.cartProducts.firstIndex(where: { $0.id == productId }) {
            self.cartProducts[index].quantity = quantity
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    
    func displayCartProducts(_ products: [Product]) {
        self.cartProducts = products
        reloadData()
    }
    
    func showLoadingView() {
        DispatchQueue.main.async {
            self.showLoading()
        }
    }
    
    func hideLoadingView() {
        hideLoading()
    }
    
    func displayProducts(_ products: [ProductResponse], for type: CollectionViewType) {
        let allProducts = products.flatMap { $0.products ?? [] }
        switch type {
        case .horizontal:
            horizontalProducts = products
        case .vertical:
            verticalProducts = products
        }
        self.reloadData()
    }
    
    func displayError(_ error: String) {
        print("Error displaying \(error)")
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.horizontalCollectionView.reloadData()
            self.verticalCollectionView.reloadData()
        }
        
    }
    
    func updateCartValue(total: Double) {
        DispatchQueue.main.async {
            self.updateCartButtonValue(total: total)
        }
    }
    
    func updateCartProductsIDs(_ ids: [String]) {
        self.productsInCartIDs = ids
        self.reloadData()
    }
}

extension ProductListingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == horizontalCollectionView {
            return horizontalProducts.flatMap { $0.products?.count ?? 0 }.reduce(0, +)
        } else if collectionView == verticalCollectionView {
            return verticalProducts.flatMap { $0.products?.count ?? 0 }.reduce(0, +)
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
        let product: Product
        var itemQuantity: Int32 = 0
        if collectionView == horizontalCollectionView {
            let allProducts = horizontalProducts.flatMap { $0.products ?? [] }
            product = allProducts[indexPath.row]
            if let quantity = cartProducts.first(where: { $0.id == product.id })?.quantity {
                itemQuantity = quantity
            }
        } else {
            let allProducts = verticalProducts.flatMap { $0.products ?? [] }
            product = allProducts[indexPath.row]
            if let quantity = cartProducts.first(where: { $0.id == product.id })?.quantity {
                itemQuantity = quantity
            }
        }

        let isInCart = productsInCartIDs.contains(product.id ?? "")
        cell.configure(with: product, isInCart: isInCart, quantity: itemQuantity)
        cell.stepperView.delegate = self
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let products = collectionView === horizontalCollectionView ? horizontalProducts : verticalProducts
        let selectedProductArray = products.flatMap { $0.products ?? [] }

        if indexPath.row < selectedProductArray.count {
            let selectedProduct = selectedProductArray[indexPath.row]
            presenter?.didSelectProduct(selectedProduct)
        } else {
            print("Selected product is out of range")
        }
    }

}

extension ProductListingViewController: StepperViewDelegate {
    func stepperViewDidTapIncrease(_ stepperView: StepperView) {

        if let index = findProductIndex(for: stepperView, in: horizontalCollectionView),
           let productId = cartProducts[index].id {
            presenter?.increaseProductQuantity(productId: productId)
        } else if let index = findProductIndex(for: stepperView, in: verticalCollectionView),
                  let productId = cartProducts[index].id {
            
            presenter?.increaseProductQuantity(productId: productId)
        }
        presenter?.viewDidAppear()
        reloadData()
    }


    func stepperViewDidTapDecrease(_ stepperView: StepperView) {
        
        if let index = findProductIndex(for: stepperView, in: horizontalCollectionView),
           let productId = cartProducts[index].id {
            if stepperView.getCount() > 0 {
                presenter?.decreaseProductQuantity(productId: productId)
                presenter?.viewDidAppear()
            } else {
                presenter?.deleteProduct(productId: productId)
                
            }
        } else if let index = findProductIndex(for: stepperView, in: verticalCollectionView),
           let productId = cartProducts[index].id {
            if stepperView.getCount() > 0 {
                presenter?.decreaseProductQuantity(productId: productId)
            } else {
                presenter?.deleteProduct(productId: productId)
            }
        }
        presenter?.viewDidAppear()
    }

    func stepperViewDidTapDelete(_ stepperView: StepperView) {
        if let index = findProductIndex(for: stepperView, in: horizontalCollectionView),
           let productId = cartProducts[index].id {
            presenter?.deleteProduct(productId: productId)
        } else if let index = findProductIndex(for: stepperView, in: verticalCollectionView),
           let productId = cartProducts[index].id {
            presenter?.deleteProduct(productId: productId)
            presenter?.fetchCartProductsIDs()
        }
    }


    private func findProductIndex(for stepperView: StepperView, in collectionView: UICollectionView) -> Int? {
        for index in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: index, section: 0)
            guard let cell = collectionView.cellForItem(at: indexPath) as? ProductCollectionViewCell,
                  cell.stepperView === stepperView else {
                continue
            }
            if let productId = cell.product?.id, let cartIndex = cartProducts.firstIndex(where: { $0.id == productId }) {
                return cartIndex
            }
        }
        return nil
    }

}

