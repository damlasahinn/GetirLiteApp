//
//  ProductDetailPresenter.swift
//  GetirLiteApp
//
//  Created by Damla Sahin on 11.04.2024.
//

import Foundation
import ProductAPI

protocol ProductDetailPresenterProtocol: AnyObject {
    func viewDidLoad()
    func viewDidAppear()
    func closeViewController()
    func saveProductDetails(_ product: Product)
    func navigateToCart(_ route: ProductDetailRoutes)
    func increaseProductQuantity(productId: String)
    func decreaseProductQuantity(productId: String)
    func deleteProduct(productId: String)
    func refreshProductDetails()

}

final class ProductDetailPresenter {
    unowned var view: ProductDetailViewControllerProtocol!
    let router: ProductDetailRouterProtocol!
    let interactor: ProductDetailInteractorProtocol!
    var product: Product
    
    init(view: ProductDetailViewControllerProtocol!, 
         router: ProductDetailRouterProtocol!,
         interactor: ProductDetailInteractorProtocol!,
         product: Product)
    {
        self.view = view
        self.router = router
        self.interactor = interactor
        self.product = product
    }
    
    private func checkCoreDataProducts() {
        interactor.checkProductInCoreData(product.id ?? "") { [weak self] quantity in
            guard let quantity = quantity else {
                self?.view.showAddToCartButton()
                return
            }
            if quantity > 0 {
                DispatchQueue.main.async {
                    self?.view.showStepperView(with: quantity)
                }
            } else {
                self?.view.showAddToCartButton()
            }
        }
    }
    
}

extension ProductDetailPresenter: ProductDetailPresenterProtocol {
    func increaseProductQuantity(productId: String) {
        interactor.updateProductQuantity(productId: productId, increment: 1)
    }
    
    func decreaseProductQuantity(productId: String) {
        interactor.updateProductQuantity(productId: productId, increment: -1)
    }
    
    func deleteProduct(productId: String) {
        interactor.deleteProductFromCoreData(productId: productId) { [weak self] in
            self?.viewDidAppear()
            self?.closeViewController()
        }
    }
    
    func viewDidLoad() {
        view.displayProductDetails(product)
        checkCoreDataProducts()
    }
    
    func viewDidAppear() {
        interactor.calculateTotalCartValue { [weak self] total in
            self?.view?.updateCartValue(total: total)
        }
    }
    
    func closeViewController() {
        router.navigate(.listing)
    }
    
    func saveProductDetails(_ product: Product) {
        interactor.saveProduct(product)
    }
    
    func navigateToCart(_ route: ProductDetailRoutes) {
        router.navigate(.cart)
    }
    
    func refreshProductDetails() {
        guard let productId = product.id else { return }
        interactor.fetchUpdatedProduct(with: productId)
    }
}

extension ProductDetailPresenter: ProductDetailInteractorOutputProtocol {
    func fetchOutput() {
        view.reloadCoreData()
    }
    
    func productFetched(_ product: Product) {
        self.product = product
        view.displayProductDetails(product)
        
        if let quantity = product.quantity, quantity > 0 {
            view.showStepperView(with: quantity)
        } else {
            view.showAddToCartButton()
        }
    }
}
