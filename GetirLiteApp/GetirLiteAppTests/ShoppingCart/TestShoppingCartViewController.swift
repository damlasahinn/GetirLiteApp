//
//  ShoppingCartViewController.swift
//  GetirLiteAppTests
//
//  Created by Damla Sahin on 23.04.2024.
//

import Foundation
@testable import GetirLiteApp
@testable import ProductAPI

final class TestShoppingCartViewController: ShoppingCartViewControllerProtocol {
    
    var displayProductsCalled = false
    var displayCartProductsCalled = false
    var displayErrorCalled = false
    var reloadCollectionDataCalled = false
    var reloadTableViewDataCalled = false
    var updateCartValueCalled = false
    var reloadQuantityCalled = false
    var setCartProductsIDsCalled = false

    var products: [ProductResponse] = []
    var cartProducts: [Product] = []
    var error: String = ""
    var total: Double = 0.0
    var quantity: Int32 = 0
    var productIDs: [String] = []
    
    func displayProducts(_ products: [ProductResponse]) {
        displayProductsCalled = true
        self.products = products
    }
    
    func displayCartProducts(_ products: [Product]) {
        displayCartProductsCalled = true
        self.cartProducts = products
    }
    
    func displayError(_ error: String) {
        displayErrorCalled = true
        self.error = error
    }
    
    func reloadCollectionData() {
        reloadCollectionDataCalled = true
    }
    
    func reloadTableViewData() {
        reloadTableViewDataCalled = true
    }
    
    func updateCartValue(total: Double) {
        updateCartValueCalled = true
        self.total = total
    }
    
    func reloadQuantity(_ quantity: Int32, _ productId: String) {
        reloadQuantityCalled = true
        self.quantity = quantity
    }
    
    func setCartProductsIDs(_ ids: [String]) {
        setCartProductsIDsCalled = true
        self.productIDs = ids
    }
}
