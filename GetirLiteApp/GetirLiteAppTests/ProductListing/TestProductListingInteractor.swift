//
//  ProsuctListingInteractorTests.swift
//  GetirLiteAppTests
//
//  Created by Damla Sahin on 23.04.2024.
//

import Foundation
@testable import GetirLiteApp
@testable import ProductAPI
@testable import RxSwift

final class TestProductListingInteractor: ProductListingInteractorProtocol {
    
    var isFetchProductsCalled = false
    var fetchProductsCalledCount = 0
    var productsToReturn: [ProductResponse] = []
    var fetchProductsCompletion: ((Result<[ProductResponse], Error>) -> Void)?
    
    func fetchProducts(for type: CollectionViewType) {
        isFetchProductsCalled = true
        fetchProductsCalledCount += 1
        if let completion = fetchProductsCompletion {
            completion(.success(productsToReturn))
        }
    }
    
    var isFetchCartProductIDsCalled = false
    
    func fetchCartProductIDs(completion: @escaping ([String]) -> Void) {
        isFetchCartProductIDsCalled = true
        completion(["6540f93a48e4bd7bf4940ffd", "5ce65819a72a950001cc8770"])
    }
    
    var isCalculateTotalCartValueCalled = false
    
    func calculateTotalCartValue(completion: @escaping (Double) -> Void) {
        isCalculateTotalCartValueCalled = true
        completion(200.00)
    }
    
    var updateProductQuantity = false
    
    func updateProductQuantity(productId: String, increment: Int32) {
        updateProductQuantity = true
    }
    
    var fetchProductFromCoreData = false
    
    func fetchProductsFromCoreData() -> RxSwift.Observable<[ProductAPI.Product]> {
        fetchProductFromCoreData = true
        return Observable.just([])
    }
    
    var deleteProductFromCoreData = false
    
    func deleteProductFromCoreData(productId: String, completion: @escaping () -> Void) {
        deleteProductFromCoreData = true
    }
}
