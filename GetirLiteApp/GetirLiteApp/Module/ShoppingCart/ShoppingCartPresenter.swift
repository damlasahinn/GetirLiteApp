//
//  ShoppingCartPresenter.swift
//  GetirLiteApp
//
//  Created by Damla Sahin on 11.04.2024.
//

import Foundation
import RxSwift
import RxCocoa
import ProductAPI

protocol ShoppingCartPresenterProtocol: AnyObject {
    func viewDidLoad()
    func viewDidAppear()
    func closeViewController()
    func increaseProductQuantity(productId: String)
    func decreaseProductQuantity(productId: String)
    func deleteProduct(productId: String)
    func deleteAllCartData()
    func didSelectProduct(_ product: Product)
    func fetchCartProductsIDs()
}

final class ShoppingCartPresenter {
    unowned  var view: ShoppingCartViewControllerProtocol!
    let router: ShoppingCartRouterProtocol!
    let interactor: ShoppingCartInteractorProtocol!
    private let disposeBag = DisposeBag()
    
    init(view: ShoppingCartViewControllerProtocol!, 
         router: ShoppingCartRouterProtocol!,
         interactor: ShoppingCartInteractorProtocol!) 
    {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
    
    private func fetchFromAPI() {
        interactor.fetchSuggestedProducts()
            .subscribe(
                onNext: { [weak self] suggestedProducts in
                    self?.view.displayProducts(suggestedProducts)
                    self?.view.reloadCollectionData()
                },
                onError: { [weak self] error in
                    self?.view.displayError(error.localizedDescription)
                }
            ).disposed(by: disposeBag)
    }
    
    private func fetchFromCoreData() {
        interactor.fetchProductsFromCoreData()
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] products in
                    self?.view.displayCartProducts(products)
                    self?.view.reloadTableViewData()
                },
                onError: { [weak self] error in
                    self?.view.displayError(error.localizedDescription)
                }
            ).disposed(by: disposeBag)
    }
}

extension ShoppingCartPresenter: ShoppingCartPresenterProtocol {
    
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
        fetchFromAPI()
        fetchFromCoreData()
    }
    
    func viewDidAppear() {
        interactor.calculateTotalCartValue { [weak self] total in
            self?.view?.updateCartValue(total: total)
        }
    }
    
    func closeViewController() {
        router.navigate(.listing, nil)
    }
    
    func deleteAllCartData() {
        interactor.deleteAllProducts()
    }
    
    func didSelectProduct(_ product: Product) {
        router.navigate(.detail, product)
    }
    
    func fetchCartProductsIDs() {
        interactor.fetchCartProductIDs { [weak self] ids in
            self?.view.setCartProductsIDs(ids)
        }
    }
}

extension ShoppingCartPresenter: ShoppingCartInteractorOutputProtocol {
    func fetchOutput(_ products: [ProductResponse]) {
        view.displayProducts(products)
        view.reloadCollectionData()
    }
    
    func failedToFetchProducts(with reason: String) {
        view.displayError(reason)
    }
    
    func productUpdatedSuccessfully() {
        view.reloadTableViewData()
    }

    func failedToUpdateProduct(with reason: String) {
        // Show an error message to the user
    }
    
    func fetchDeletedCart() {
        view.reloadTableViewData()
        router.navigate(.listing, nil)
    }
    
    func fetchOutputQuantity(_ quantity: Int32,_ productId: String) {
        view.reloadQuantity(quantity, productId)
    }
}
