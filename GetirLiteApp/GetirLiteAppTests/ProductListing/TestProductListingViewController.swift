//
//  ProductListingViewControllerTests.swift
//  GetirLiteAppTests
//
//  Created by Damla Sahin on 23.04.2024.
//

import Foundation
@testable import GetirLiteApp
@testable import ProductAPI

final class TestProductListingViewController: ProductListingViewControllerProtocol {
    
    var isInvokedShowLoading = false
    var isInvokedShowLoadingCount = 0
    
    var isInvokedHideLoading = false
    var isInvokedHideLoadingCount = 0
    
    var isInvokedDisplayProducts = false
    var isInvokedDisplayProductsCount = 0
    var displayedProducts: [ProductResponse]?
    
    var isInvokedDisplayError = false
    var isInvokedDisplayErrorCount = 0
    var displayedError: String?
    
    var isInvokedReloadData = false
    var isInvokedReloadDataCount = 0
    
    var isInvokedUpdateCartValue = false
    var isInvokedUpdateCartValueCount = 0
    var updatedCartValue: Double?
    
    var isInvokedUpdateCartProductsIDs = false
    var isInvokedUpdateCartProductsIDsCount = 0
    var updatedCartProductIDs: [String]?
    
    var displayCartProducts = false
    var displayCartProductsCount = 0
    
    var reloadQuantity = false
    var reloadQuantityCount = 0
    
    func showLoadingView() {
        isInvokedShowLoading = true
        isInvokedShowLoadingCount += 1
    }
    
    func hideLoadingView() {
        isInvokedHideLoading = true
        isInvokedHideLoadingCount += 1
    }
   
    func displayProducts(_ products: [ProductResponse], for type: CollectionViewType) {
        isInvokedDisplayProducts = true
        isInvokedDisplayProductsCount += 1
        displayedProducts = products
    }
    
    func displayError(_ error: String) {
        isInvokedDisplayError = true
        isInvokedDisplayErrorCount += 1
        displayedError = error
    }
    
    func reloadData() {
        isInvokedReloadData = true
        isInvokedReloadDataCount += 1
    }
    
    func updateCartValue(total: Double) {
        isInvokedUpdateCartValue = true
        isInvokedUpdateCartValueCount += 1
        updatedCartValue = total
    }
    
    func updateCartProductsIDs(_ ids: [String]) {
        isInvokedUpdateCartProductsIDs = true
        isInvokedUpdateCartProductsIDsCount += 1
        updatedCartProductIDs = ids
    }
    
    func displayCartProducts(_ products: [Product]) {
        displayCartProducts = true
        displayCartProductsCount += 1
    }
    
    func reloadQuantity(_ quantity: Int32, _ productId: String) {
        reloadQuantity = true
        reloadQuantityCount += 1
    }
}
