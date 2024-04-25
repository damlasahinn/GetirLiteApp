//
//  ProductListingPresenter.swift
//  GetirLiteApp
//
//  Created by Damla Sahin on 11.04.2024.
//

import Foundation
import RxSwift
import RxCocoa
import ProductAPI

protocol ProductListingPresenterProtocol: AnyObject {
    func viewDidLoad()
    func viewDidAppear()
    func didSelectProduct(_ product: Product)
    func navigateToCart(_ route: ProductListingRoutes)
    func increaseProductQuantity(productId: String)
    func decreaseProductQuantity(productId: String)
    func deleteProduct(productId: String)
    func fetchCartProductsIDs()
    func fetchFromCart()
}

final class ProductListingPresenter {
    
    unowned var view: ProductListingViewControllerProtocol!
    let router: ProductListingRouterProtocol!
    let interactor: ProductListingInteractorProtocol!
    private let disposeBag = DisposeBag()
    
    init(view: ProductListingViewControllerProtocol!, 
         router: ProductListingRouterProtocol!,
         interactor: ProductListingInteractorProtocol!)
    {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
    
    private func fetchFromCoreData() {
        interactor.fetchProductsFromCoreData()
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] products in
                    self?.view.displayCartProducts(products)
                    self?.view.reloadData()
                },
                onError: { [weak self] error in
                    self?.view.displayError(error.localizedDescription)
                }
            ).disposed(by: disposeBag)
    }
}

extension ProductListingPresenter: ProductListingPresenterProtocol {
    
    func increaseProductQuantity(productId: String) {
        interactor.updateProductQuantity(productId: productId, increment: 1)
    }
    
    func decreaseProductQuantity(productId: String) {
        interactor.updateProductQuantity(productId: productId, increment: -1)
    }
    
    func deleteProduct(productId: String) {
        interactor.deleteProductFromCoreData(productId: productId) { [weak self] in
            self?.fetchFromCoreData()
        }
    }
    
    func viewDidLoad() {
        view?.showLoadingView()
        interactor.fetchProducts(for: .vertical)
        interactor.fetchProducts(for: .horizontal)
        
    }
    
    func fetchFromCart(){
        fetchFromCoreData()
    }
    
    func viewDidAppear() {
        interactor.calculateTotalCartValue { [weak self] total in
            self?.view?.updateCartValue(total: total)
        }
        fetchCartProductsIDs()
    }
    
    func didSelectProduct(_ product: Product) {
        router.navigate(.detail, product)
    }
    
    func navigateToCart(_ route: ProductListingRoutes) {
        router.navigate(.cart, nil)
    }
    
    func fetchCartProductsIDs() {
        interactor.fetchCartProductIDs { [weak self] ids in
            self?.view.updateCartProductsIDs(ids)
        }
    }
    
}

extension ProductListingPresenter: ProductListingInteractorOutputProtocol {
    func failedToUpdateProduct(with reason: String) {
        // Show an error message to the user
    }
    
    func fetchOutput(_ products: [ProductResponse], for type: CollectionViewType) { //
        view?.hideLoadingView()
        view?.displayProducts(products, for: type)
        view?.reloadData()
    }
    
    func failedToFetchProducts(with reason: String) {
        view?.displayError(reason)
    }
    
    func productsFetched(_ products: [ProductResponse], for type: CollectionViewType) {
        view.displayProducts(products, for: type)
        view.hideLoadingView()
    }
    
    func cartProductIDsFetched(_ ids: [String]) {
        view.updateCartProductsIDs(ids)
    }
    
    func totalCartValueCalculated(_ total: Double) {
        view.updateCartValue(total: total)
    }
    
    func encounteredError(_ error: any Error) {
        view.displayError(error.localizedDescription)
    }
    
    func fetchOutputQuantity(_ quantity: Int32,_ productId: String) {
        view.reloadQuantity(quantity, productId)
        view.reloadData()
    }
}

