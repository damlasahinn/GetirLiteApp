//
//  ProductListingInteractor.swift
//  GetirLiteApp
//
//  Created by Damla Sahin on 11.04.2024.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData
import ProductAPI

protocol ProductListingInteractorProtocol: AnyObject {
    func fetchProducts(for type: CollectionViewType)
    func fetchCartProductIDs(completion: @escaping ([String]) -> Void)
    func calculateTotalCartValue(completion: @escaping (Double) -> Void)
    func updateProductQuantity(productId: String, increment: Int32)
    func fetchProductsFromCoreData() -> Observable<[Product]>
    func deleteProductFromCoreData(productId: String, completion: @escaping () -> Void)
}

protocol ProductListingInteractorOutputProtocol: AnyObject {
    func fetchOutput(_ products: [ProductResponse], for type: CollectionViewType)
    func failedToFetchProducts(with reason: String)
    
    func productsFetched(_ products: [ProductResponse], for type: CollectionViewType)
    func cartProductIDsFetched(_ ids: [String])
    func totalCartValueCalculated(_ total: Double)
    func encounteredError(_ error: Error)
    func fetchOutputQuantity(_ quantity: Int32, _ productId: String)
    func failedToUpdateProduct(with reason: String)
}

final class ProductListingInteractor {
    weak var output: ProductListingInteractorOutputProtocol?

}

extension ProductListingInteractor: ProductListingInteractorProtocol {
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
    
    func calculateTotalCartValue(completion: @escaping (Double) -> Void) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()

        do {
            let results = try context.fetch(fetchRequest)
            let totalPrice = results.reduce(0.0) { (currentSum, product) -> Double in
                let quantity = Double(product.quantity ?? 0)
                let price = Double(product.priceText?.replacingOccurrences(of: "₺", with: "").replacingOccurrences(of: ",", with: ".") ?? "0") ?? 0.0
                return currentSum + (quantity * price)
            }
            DispatchQueue.main.async {
                self.output?.totalCartValueCalculated(totalPrice)
                completion(totalPrice)
            }
        } catch {
            DispatchQueue.main.async {
                completion(0.0)
            }
        }
    }
    
    func fetchProducts(for type: CollectionViewType) {
        let service = ProductService()
        switch type {
        case .vertical:
            service.fetchProducts { result in
                switch result {
                case .success(let products):
                    self.output?.productsFetched(products, for: type)
                case .failure(let error):
                    self.output?.encounteredError(error)
                }
            }
        case .horizontal:
            service.fetchSuggestedProducts { result in
                switch result {
                case .success(let products):
                    self.output?.productsFetched(products, for: type)
                case .failure(let error):
                    self.output?.encounteredError(error)
                }
            }
        }
        
    }
     
    func fetchCartProductIDs(completion: @escaping ([String]) -> Void) {
        CoreDataManager.shared.fetchCartProductIDs(completion: completion)
    }

}
