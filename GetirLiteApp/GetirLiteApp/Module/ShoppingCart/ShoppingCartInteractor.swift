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
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", productId)
        
        do {
            if let product = try context.fetch(fetchRequest).first {
                context.delete(product)
                try context.save()
                output?.fetchOutputQuantity(product.quantity, productId)
                completion()
            }
        } catch {
            print("Failed to delete products: \(error)")
        }
    }
    
    func fetchProductsFromCoreData() -> Observable<[Product]> {
        Observable.create { observer in
            let context = CoreDataManager.shared.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()

            do {
                let results = try context.fetch(fetchRequest)
                let products = results.map { entity -> Product in
                    let id = entity.id
                    let name = entity.name
                    let attribute = entity.attribute
                    let priceText = entity.priceText
                    let imageURL = entity.imageURL
                    let thumbnailURL = entity.thumbnailURL
                    let squareThumbnailURL = entity.squareThumbnailURL
                    let price = entity.price
                    let quantity = entity.quantity
                    
                    return Product(id: id, name: name, attribute: attribute, thumbnailURL: thumbnailURL, squareThumbnailURL: squareThumbnailURL, imageURL: imageURL, price: price, priceText: priceText, quantity: quantity)
                }
                observer.onNext(products)
                observer.onCompleted()
            } catch {
                observer.onError(error)
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
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", productId)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let product = results.first {
                product.quantity += increment
                if product.quantity < 0 { product.quantity = 0 }
                try context.save()
                output?.fetchOutputQuantity(product.quantity, productId)
            } else {
                print("No product found with ID \(productId)")
            }
        } catch {
            print("Failed to update quantity: \(error)")
        }
    }
    
    func deleteAllProducts() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ProductEntity.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            try context.save()
            output?.fetchDeletedCart()
        } catch {
            output?.failedToUpdateProduct(with: "Failed to delete all products: \(error.localizedDescription)")
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
                completion(totalPrice)
            }
        } catch {
            print("Failed to fetch products for total calculation: \(error)")
            DispatchQueue.main.async {
                completion(0.0)
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
