//
//  ShoppingCartViewController.swift
//  GetirLiteApp
//
//  Created by Damla Sahin on 11.04.2024.
//

import UIKit
import RxCocoa
import RxSwift
import ProductAPI

protocol ShoppingCartViewControllerProtocol: AnyObject {
    func displayProducts(_ products: [ProductResponse])
    func displayCartProducts(_ products: [Product])
    func displayError(_ error: String)
    func reloadCollectionData()
    func reloadTableViewData()
    func updateCartValue(total: Double)
    func reloadQuantity(_ quantity: Int32,_ productId: String)
    func setCartProductsIDs(_ ids: [String])
}

final class ShoppingCartViewController: BaseViewController {
    
    private lazy var customNavigationBar: UIView = {
        let navBar = UIView()
        navBar.backgroundColor = UIColor(named: "text-primary")
        return navBar
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sepetim"
        label.textColor = .white
        label.font = UIFont(name: "OpenSans-Bold", size: 14)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    private lazy var cartTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: "ProductTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        return tableView
    }()
    
    private lazy var sectionHeaderView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var suggestedTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Önerilen Ürünler"
        label.textColor = UIColor(named: "text-dark")
        label.font = UIFont(name: "OpenSans-SemiBold", size: 12)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var suggestedProductsCollectionView: UICollectionView = {
        let layout = createCompositionalLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: "ProductCollectionViewCell")
        return collectionView
    }()
    
    private lazy var buttonView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var completeButton: CompleteButton = {
        let button = CompleteButton(type: .system)
        button.addTarget(self, action: #selector(completeOrderTapped), for: .touchUpInside)
        button.layer.cornerRadius = 10
        return button
    }()
    
    var presenter: ShoppingCartPresenterProtocol!
    private var suggestedProducts: [Product] = []
    private var cartProducts: [Product] = [] {
        didSet {
            reloadTableViewData()
        }
    }
    
    private var productsInCartIDs: [String] = []
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        presenter.viewDidLoad()
        setupLeftBarButtonItem()
        setupRightBarButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter?.viewDidAppear()
        presenter?.fetchCartProductsIDs()
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor(named: "bg-body")
        setupNavigationBar()
        setupScrollView()
        setupSectionView()
        setupCollectionView()
        setupButtonView()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 304)
        ])
        
        scrollView.addSubview(cartTableView)
        cartTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cartTableView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            cartTableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            cartTableView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            cartTableView.heightAnchor.constraint(equalToConstant: 304),
            cartTableView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupSectionView() {
        view.addSubview(sectionHeaderView)
        sectionHeaderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sectionHeaderView.topAnchor.constraint(equalTo: scrollView.bottomAnchor),
            sectionHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sectionHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sectionHeaderView.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        sectionHeaderView.addSubview(suggestedTitleLabel)
        suggestedTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            suggestedTitleLabel.heightAnchor.constraint(equalToConstant: 16),
            suggestedTitleLabel.leadingAnchor.constraint(equalTo: sectionHeaderView.leadingAnchor, constant: 16),
            suggestedTitleLabel.centerYAnchor.constraint(equalTo: sectionHeaderView.centerYAnchor)
        ])
    }
    
    private func setupCollectionView() {
        view.addSubview(suggestedProductsCollectionView)
        suggestedProductsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            suggestedProductsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            suggestedProductsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16),
            suggestedProductsCollectionView.topAnchor.constraint(equalTo: sectionHeaderView.bottomAnchor, constant: 16),
            suggestedProductsCollectionView.widthAnchor.constraint(equalToConstant: 556),
            suggestedProductsCollectionView.heightAnchor.constraint(equalToConstant: 185)
        ])
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
    
    private func setupButtonView() {
        view.addSubview(buttonView)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonView.heightAnchor.constraint(equalToConstant: 103),
            buttonView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        buttonView.addSubview(completeButton)
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            completeButton.centerXAnchor.constraint(equalTo: buttonView.centerXAnchor),
            completeButton.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor),
            completeButton.heightAnchor.constraint(equalToConstant: 50),
            completeButton.widthAnchor.constraint(equalToConstant: 351)
        ])
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
    
    private func setupRightBarButtonItem() {
        let deleteButton = UIButton(type: .system)
        deleteButton.setImage(UIImage(named: "trashIcon"), for: .normal)
        deleteButton.tintColor = .white
        deleteButton.backgroundColor = .clear
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        let rightBarItem = UIBarButtonItem(customView: deleteButton)
        
        self.navigationItem.rightBarButtonItem = rightBarItem
        self.navigationItem.rightBarButtonItem?.tintColor = .white
        self.navigationItem.hidesBackButton = true
    }
    
    @objc private func closeButtonTapped() {
        presenter?.closeViewController()
    }
    
    @objc private func deleteButtonTapped() {
        let yesAction = UIAlertAction(title: "Evet", style: .destructive) { [weak self] _ in
            self?.presenter?.deleteAllCartData()
        }
        let noAction = UIAlertAction(title: "Hayır", style: .cancel, handler: nil)
        showAlert(title: "Sepetini boşaltmak istediğinden emin misin?", message: "", actions: [yesAction, noAction])
    }
    
    @objc private func completeOrderTapped() {
        print("complete clicked")
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 92, height: 153)
        return layout
    }
}

extension ShoppingCartViewController: ShoppingCartViewControllerProtocol {
    func reloadQuantity(_ quantity: Int32,_ productId: String) {
        if let index = cartProducts.firstIndex(where: { $0.id == productId }) {
            if let cell = cartTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? ProductTableViewCell {
                cell.configureStepper(with: quantity)
                presenter?.viewDidAppear()
            }
        }
    }
    
    func displayCartProducts(_ products: [Product]) {
        self.cartProducts = products
        reloadTableViewData()
    }
    
    func displayProducts(_ products: [ProductResponse]) {
        self.suggestedProducts = products.flatMap { $0.products ?? [] }
        reloadCollectionData()
    }
    
    func displayError(_ error: String) {
        print("Error displaying")
    }
    
    func reloadCollectionData() {
        DispatchQueue.main.async {
            self.suggestedProductsCollectionView.reloadData()
        }
    }
    
    func reloadTableViewData() {
        DispatchQueue.main.async {
            self.cartTableView.reloadData()
        }
    }
    
    func updateCompletedSuccessfully() {
        reloadTableViewData()
    }

    func updateFailed(with message: String) {
        print("Failed")
    }
    
    func updateCartValue(total: Double) {
        print(total)
        if total == 0.0 {
            presenter.deleteAllCartData()
        } else {
            DispatchQueue.main.async {
                self.completeButton.totalLabel.text = CompleteButton.formatPrice(total)
            }
        }
    }
    
    func setCartProductsIDs(_ ids: [String]) {
        self.productsInCartIDs = ids
        self.reloadCollectionData()
    }
}

extension ShoppingCartViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        suggestedProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
        
        let product = suggestedProducts[indexPath.row]
        
        let isInCart = productsInCartIDs.contains(product.id ?? "")
        
        cell.configure(with: product, isInCart: isInCart)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProduct = suggestedProducts[indexPath.row]
        presenter?.didSelectProduct(selectedProduct)
    }
}

extension ShoppingCartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cartProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as? ProductTableViewCell else {
            return UITableViewCell()
        }
        let product = cartProducts[indexPath.row]
        cell.configure(with: product)
        if let quantity = product.quantity {
            cell.configureStepper(with: quantity)
        } else {
            cell.configureStepper(with: 0)
        }
        cell.productId = product.id
        cell.stepperView.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { [weak self] (action, view, completionHandler) in
            guard let self = self else {
                completionHandler(false)
                return
            }
            
            let productId = self.cartProducts[indexPath.row].id ?? ""
            
            self.presenter.deleteProduct(productId: productId)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            presenter.fetchCartProductsIDs()

            completionHandler(true)
        }
        
        deleteAction.backgroundColor = UIColor(named: "bg-body")
        deleteAction.image = UIImage(named: "trashIcon")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        
        return configuration
    }
}

extension ShoppingCartViewController: StepperViewDelegate {
    func stepperViewDidTapIncrease(_ stepperView: StepperView) {
        if let index = findProductIndex(for: stepperView), let productId = cartProducts[index].id {
            presenter.increaseProductQuantity(productId: productId)
        }
    }
    
    func stepperViewDidTapDecrease(_ stepperView: StepperView) {
        if let index = findProductIndex(for: stepperView), let productId = cartProducts[index].id {
            if stepperView.getCount() > 0 {
                presenter.decreaseProductQuantity(productId: productId)
            } else {
                presenter.deleteProduct(productId: productId)
                presenter.fetchCartProductsIDs()
            }
        }
    }

    func stepperViewDidTapDelete(_ stepperView: StepperView) {
        if let index = findProductIndex(for: stepperView), let productId = cartProducts[index].id {
            presenter.deleteProduct(productId: productId)
            presenter.fetchCartProductsIDs()
        }
    }
    
    private func findProductIndex(for stepperView: StepperView) -> Int? {
        for (index, cell) in cartTableView.visibleCells.enumerated() {
            if let cell = cell as? ProductTableViewCell, cell.stepperView == stepperView {
                return index
            }
        }
        return nil
    }

}
