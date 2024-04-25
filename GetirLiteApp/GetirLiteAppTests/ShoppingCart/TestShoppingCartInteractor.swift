//
//  ShoppingCartInteractor.swift
//  GetirLiteAppTests
//
//  Created by Damla Sahin on 23.04.2024.
//

import Foundation
@testable import GetirLiteApp
@testable import ProductAPI
@testable import RxSwift

final class TestShoppingCartInteractor: ShoppingCartInteractorProtocol {
    
    var fetchSuggestedProductsCalled = false
    var fetchProductsFromCoreDataCalled = false
    var updateProductQuantityCalled = false
    var deleteAllProductsCalled = false
    var calculateTotalCartValueCalled = false
    var deleteProductFromCoreDataCalled = false
    var fetchCartProductIDsCalled = false

    func fetchSuggestedProducts() -> Observable<[ProductResponse]> {
        fetchSuggestedProductsCalled = true
        return Observable.just([])
    }
    
    func fetchProductsFromCoreData() -> Observable<[Product]> {
        fetchProductsFromCoreDataCalled = true
        return Observable.just([])
    }
    
    func updateProductQuantity(productId: String, increment: Int32) {
        updateProductQuantityCalled = true
    }
    
    func deleteAllProducts() {
        deleteAllProductsCalled = true
    }
    
    func calculateTotalCartValue(completion: @escaping (Double) -> Void) {
        calculateTotalCartValueCalled = true
        completion(100.0)
    }
    
    func deleteProductFromCoreData(productId: String, completion: @escaping () -> Void) {
        deleteProductFromCoreDataCalled = true
        completion()
    }
    
    func fetchCartProductIDs(completion: @escaping ([String]) -> Void) {
        fetchCartProductIDsCalled = true
        completion([])
    }
    
    
}
