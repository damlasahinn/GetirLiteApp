//
//  ProductListingPresenter.swift
//  GetirLiteAppTests
//
//  Created by Damla Sahin on 23.04.2024.
//

import Foundation
@testable import GetirLiteApp
@testable import ProductAPI

final class TestProductListingPresenter: ProductListingPresenterProtocol {
    
    var viewDidLoadCalled = false
    var viewDidAppearCalled = false
    var didSelectProductCalled = false
    var navigateToCartCalled = false
    var fetchCartProductsIDsCalled = false
    
    var increaseProductQuantity = false
    var decreaseProductQuantity = false
    var deleteProduct = false
    var fetchFromCarts = false
    

    var lastProductIdSelected: String?
    var lastRouteNavigatedTo: ProductListingRoutes?

    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func viewDidAppear() {
        viewDidAppearCalled = true
    }
    
    func didSelectProduct(_ product: Product) {
        didSelectProductCalled = true
        lastProductIdSelected = product.id
    }
    
    func navigateToCart(_ route: ProductListingRoutes) {
        navigateToCartCalled = true
        lastRouteNavigatedTo = route
    }
    
    func fetchCartProductsIDs() {
        fetchCartProductsIDsCalled = true
    }
    
    func increaseProductQuantity(productId: String) {
        increaseProductQuantity = true
    }
    
    func decreaseProductQuantity(productId: String) {
        decreaseProductQuantity = true
    }
    
    func deleteProduct(productId: String) {
        deleteProduct = true
    }
    
    func fetchFromCart() {
        fetchFromCarts = true
    }
}
