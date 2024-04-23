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
    func fetchProducts(for type: CollectionViewType) -> Observable<[ProductResponse]>
    func calculateTotalCartValue(completion: @escaping (Double) -> Void)
    func fetchCartProductIDs(completion: @escaping ([String]) -> Void)
}

protocol ProductListingInteractorOutputProtocol: AnyObject {
    func fetchOutput(_ products: [ProductResponse], for type: CollectionViewType)
    func failedToFetchProducts(with reason: String)
}

final class ProductListingInteractor {
    weak var output: ProductListingInteractorOutputProtocol?

}

extension ProductListingInteractor: ProductListingInteractorProtocol {
    
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
                completion(totalPrice)
            }
        } catch {
            print("Failed to fetch products for total calculation: \(error)")
            DispatchQueue.main.async {
                completion(0.0)
            }
        }
    }
    
    func fetchProducts(for type: CollectionViewType) -> Observable<[ProductResponse]> {
        let service = ProductService()
        switch type {
        case .vertical:
            return Observable.create { observer in
                service.fetchProducts { result in
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
        case .horizontal:
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
    }


    
    func fetchCartProductIDs(completion: @escaping ([String]) -> Void) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()

        do {
            let results = try context.fetch(fetchRequest)
            let ids = results.compactMap { $0.id }
            DispatchQueue.main.async {
                completion(ids)
            }
        } catch {
            print("Failed to fetch product IDs: \(error)")
            DispatchQueue.main.async {
                completion([])
            }
        }
    }

}
