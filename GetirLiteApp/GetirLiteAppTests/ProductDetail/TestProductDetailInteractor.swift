//
//  ProductDetailInteractor.swift
//  GetirLiteAppTests
//
//  Created by Damla Sahin on 23.04.2024.
//

import Foundation
@testable import GetirLiteApp
@testable import ProductAPI
@testable import RxSwift

final class TestProductDetailInteractor: ProductDetailInteractorProtocol {
    
    var fetchCalled = false
    var saveProductCalled = false
    var checkProductInCoreDataCalled = false
    var updateProductQuantityCalled = false
    var deleteProductFromCoreDataCalled = false
    var fetchUpdatedProductCalled = false
    var calculateTotalCartValueCalled = false
    var fetchedProductsFromCoreData = false
    
    func fetch() {
        fetchCalled = true
    }
    
    func saveProduct(_ product: Product) {
        saveProductCalled = true
    }
    
    func checkProductInCoreData(_ productId: String, completion: @escaping (Int32?) -> Void) {
        checkProductInCoreDataCalled = true
        completion(nil)
    }
    
    func updateProductQuantity(productId: String, increment: Int32) {
        updateProductQuantityCalled = true
    }
    
    func deleteProductFromCoreData(productId: String, completion: @escaping () -> Void) {
        deleteProductFromCoreDataCalled = true
        completion()
    }
    
    func fetchUpdatedProduct(with productId: String) {
        fetchUpdatedProductCalled = true
    }
    
    func calculateTotalCartValue(completion: @escaping (Double) -> Void) {
        calculateTotalCartValueCalled = true
        completion(100.0)
    }
    
    func fetchProductsFromCoreData() -> RxSwift.Observable<[ProductAPI.Product]> {
        fetchedProductsFromCoreData = true
        return Observable.just([])
    }
}
