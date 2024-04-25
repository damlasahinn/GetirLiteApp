//
//  ShoppingCartPresenter.swift
//  GetirLiteAppTests
//
//  Created by Damla Sahin on 23.04.2024.
//

import Foundation
@testable import GetirLiteApp
@testable import ProductAPI

final class TestShoppingCartPresenter: ShoppingCartPresenterProtocol {
    
    var viewDidLoadCalled = false
    var viewDidAppearCalled = false
    var closeViewControllerCalled = false
    var increaseProductQuantityCalled = false
    var decreaseProductQuantityCalled = false
    var deleteProductCalled = false
    var deleteAllCartDataCalled = false
    var didSelectProductCalled = false
    var fetchCartProductsIDsCalled = false
    var fetchShoppingCart = false

    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func viewDidAppear() {
        viewDidAppearCalled = true
    }
    
    func closeViewController() {
        closeViewControllerCalled = true
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
    
    func deleteAllCartData() {
        deleteAllCartDataCalled = true
    }
    
    func didSelectProduct(_ product: Product) {
        didSelectProductCalled = true
    }
    
    func fetchCartProductsIDs() {
        fetchCartProductsIDsCalled = true
    }
    
    func fetchFromCart() {
        fetchShoppingCart = true
    }
}
