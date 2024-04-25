//
//  ProductDetailInteractor.swift
//  GetirLiteApp
//
//  Created by Damla Sahin on 11.04.2024.
//

import CoreData
import ProductAPI
import RxSwift

protocol ProductDetailInteractorProtocol: AnyObject {
    func saveProduct(_ product: Product)
    func checkProductInCoreData(_ productId: String, completion: @escaping (Int32?) -> Void)
    func updateProductQuantity(productId: String, increment: Int32)
    func deleteProductFromCoreData(productId: String, completion: @escaping () -> Void)
    func fetchUpdatedProduct(with productId: String)
    func calculateTotalCartValue(completion: @escaping (Double) -> Void)
    func fetchProductsFromCoreData() -> Observable<[Product]>
}

protocol ProductDetailInteractorOutputProtocol: AnyObject {
    func fetchOutput()
    func productFetched(_ product: Product)
}

final class ProductDetailInteractor {
    var output: ProductDetailInteractorOutputProtocol?
}

extension ProductDetailInteractor: ProductDetailInteractorProtocol {
    func updateProductQuantity(productId: String, increment: Int32) {
        CoreDataManager.shared.updateProductQuantity(productId: productId, increment: increment) { [weak self] success in
            if success {
                self?.output?.fetchOutput()
            } else {
                print("Failed Updating")
            }
        }
    }
    
    func calculateTotalCartValue(completion: @escaping (Double) -> Void) {
        CoreDataManager.shared.calculateTotalCartValue { [weak self] totalPrice in
            completion(totalPrice)
        }
    }
    
    func deleteProductFromCoreData(productId: String, completion: @escaping () -> Void) {
        CoreDataManager.shared.deleteProduct(productId: productId) { [weak self] success in
            if success {
                self?.output?.fetchOutput()
                completion()
            } else {
                print("Error deleting")
            }
        }
    }
    
    func fetchUpdatedProduct(with productId: String) {
        CoreDataManager.shared.fetchProduct(productId: productId) { [weak self] fetchedProduct in
            if let product = fetchedProduct {
                self?.output?.productFetched(product)
            } else {
                print("Fetch Update error")
            }
        }
    }
    
    func saveProduct(_ product: Product) {
        CoreDataManager.shared.saveProduct(product) { [weak self] success, error in
            if success {
                self?.output?.fetchOutput()
            } else {
                print("Error saving product: \(String(describing: error))")
            }
        }
    }
    
    func checkProductInCoreData(_ productId: String, completion: @escaping (Int32?) -> Void) {
        CoreDataManager.shared.checkProductInCoreData(productId: productId) { [weak self] quantity in
            completion(quantity)
        }
    }
    
    func fetchProductsFromCoreData() -> Observable<[Product]> {
        return Observable.create { observer in
            CoreDataManager.shared.fetchAllProducts { products in
                observer.onNext(products)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
