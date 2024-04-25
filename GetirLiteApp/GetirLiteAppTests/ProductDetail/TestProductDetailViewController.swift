//
//  ProductDetailViewController.swift
//  GetirLiteAppTests
//
//  Created by Damla Sahin on 23.04.2024.
//

import Foundation
@testable import GetirLiteApp
@testable import ProductAPI

final class TestProductDetailViewController: ProductDetailViewControllerProtocol {
    
    var displayProductDetailsCalled = false
    var setProductCalled = false
    var showAddToCartButtonCalled = false
    var showStepperViewCalled = false
    var reloadCoreDataCalled = false
    var updateCartValueCalled = false
    var displayCartProducts = false
    var displayError = false
    var displayedProduct: Product?
    var updatedTotal: Double = 0.0
    
    func displayProductDetails(_ product: Product) {
        displayProductDetailsCalled = true
        displayedProduct = product
    }
    
    func setProduct(_ product: Product) {
        setProductCalled = true
    }
    
    func showAddToCartButton() {
        showAddToCartButtonCalled = true
    }
    
    func showStepperView(with quantity: Int32) {
        showStepperViewCalled = true
    }
    
    func reloadCoreData() {
        reloadCoreDataCalled = true
    }
    
    func updateCartValue(total: Double) {
        updateCartValueCalled = true
        updatedTotal = total
    }
    
    func displayCartProducts(_ products: [ProductAPI.Product]) {
        displayCartProducts = true
    }
    
    func displayError(_ error: String) {
        displayError = true
    }
}
