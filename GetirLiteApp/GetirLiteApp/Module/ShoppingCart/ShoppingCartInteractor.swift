//
//  ShoppingCartInteractor.swift
//  GetirLiteApp
//
//  Created by Damla Sahin on 11.04.2024.
//

import RxSwift
import RxCocoa
import CoreData
import ProductAPI

protocol ShoppingCartInteractorProtocol: AnyObject {
    func fetchSuggestedProducts() -> Observable<[ProductResponse]>
    func fetchProductsFromCoreData() -> Observable<[Product]>
    func updateProductQuantity(productId: String, increment: Int32)
    func deleteAllProducts()
    func calculateTotalCartValue(completion: @escaping (Double) -> Void)
    func deleteProductFromCoreData(productId: String, completion: @escaping () -> Void)
    func fetchCartProductIDs(completion: @escaping ([String]) -> Void)
}

protocol ShoppingCartInteractorOutputProtocol: AnyObject {
    func fetchOutput(_ products: [ProductResponse])
    func failedToFetchProducts(with reason: String)
    func productUpdatedSuccessfully()
    func failedToUpdateProduct(with reason: String)
    func fetchDeletedCart()
    func fetchOutputQuantity(_ quantity: Int32, _ productId: String)
}

final class ShoppingCartInteractor {
    var output: ShoppingCartInteractorOutputProtocol?
}

extension ShoppingCartInteractor: ShoppingCartInteractorProtocol {
    
    func deleteProductFromCoreData(productId: String, completion: @escaping () -> Void) {
        CoreDataManager.shared.deleteProduct(productId: productId) { success in
            if success {
                completion()
            } else {
                self.output?.failedToUpdateProduct(with: "Failed to delete the product from cart.")
            }
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
    
    func fetchSuggestedProducts() -> Observable<[ProductResponse]> {
        let service = ProductService()
        return Observable.create { observer in
            service.fetchSuggestedProducts { result in
                switch result {
                case .success(let productResponses):
                    observer.onNext(productResponses)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }

    func updateProductQuantity(productId: String, increment: Int32) {
        CoreDataManager.shared.updateProductQuantity(productId: productId, increment: increment) { [weak self] success in
            guard let strongSelf = self else { return }
            if success {
                CoreDataManager.shared.fetchProduct(productId: productId) { product in
                    DispatchQueue.main.async {
                        if let updatedQuantity = product?.quantity {
                            strongSelf.output?.fetchOutputQuantity(updatedQuantity, productId)
                        }
                    }
                }
            } else {
                strongSelf.output?.failedToUpdateProduct(with: "Unable to update product quantity.")
            }
        }
    }

    func deleteAllProducts() {
        CoreDataManager.shared.deleteAllProducts { success in
            if success {
                self.output?.fetchDeletedCart()
            } else {
                self.output?.failedToUpdateProduct(with: "Failed to delete all products from cart.")
            }
        }
    }
    
    func calculateTotalCartValue(completion: @escaping (Double) -> Void) {
        CoreDataManager.shared.calculateTotalCartValue { totalPrice in
            completion(totalPrice)
        }
    }
    
    func fetchCartProductIDs(completion: @escaping ([String]) -> Void) {
        CoreDataManager.shared.fetchCartProductIDs(completion: completion)
    }
}
