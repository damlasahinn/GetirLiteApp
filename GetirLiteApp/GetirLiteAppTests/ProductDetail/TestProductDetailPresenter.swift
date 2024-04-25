//
//  ProductDetailPresenter.swift
//  GetirLiteAppTests
//
//  Created by Damla Sahin on 23.04.2024.
//

import Foundation
@testable import GetirLiteApp
@testable import ProductAPI

final class TestProductDetailPresenter: ProductDetailPresenterProtocol {
    
    var viewDidLoadCalled = false
    var viewDidAppearCalled = false
    var closeViewControllerCalled = false
    var saveProductDetailsCalled = false
    var navigateToCartCalled = false
    var increaseProductQuantityCalled = false
    var decreaseProductQuantityCalled = false
    var deleteProductCalled = false
    var refreshProductDetailsCalled = false
    var fetchCartsProduct = false

    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func viewDidAppear() {
        viewDidLoadCalled = true
    }
    
    func closeViewController() {
        closeViewControllerCalled = true
    }
    
    func saveProductDetails(_ product: Product) {
        saveProductDetailsCalled = true
    }
    
    func navigateToCart(_ route: ProductDetailRoutes) {
        navigateToCartCalled = true
    }
    
    func increaseProductQuantity(productId: String) {
        increaseProductQuantityCalled = true
    }
    
    func decreaseProductQuantity(productId: String) {
        decreaseProductQuantityCalled = true
    }
    
    func deleteProduct(productId: String) {
        deleteProductCalled = true
    }
    
    func refreshProductDetails() {
        refreshProductDetailsCalled = true
    }
    
    func fetchCartProducts() {
        fetchCartsProduct = true
    }
    
}
