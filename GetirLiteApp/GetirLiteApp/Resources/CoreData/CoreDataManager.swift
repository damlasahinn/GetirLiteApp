//
//  CoreDataManager.swift
//  GetirLiteApp
//
//  Created by Damla Sahin on 17.04.2024.
//

import CoreData
import ProductAPI

class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GetirLiteApp")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveProduct(_ product: Product, completion: @escaping (Bool, Error?) -> Void) {
        let context = persistentContainer.viewContext
        context.perform {
            let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", product.id ?? "")
            
            do {
                let results = try context.fetch(fetchRequest)
                let entity = results.first ?? ProductEntity(context: context)
                entity.id = product.id
                entity.name = product.name
                entity.attribute = product.attribute
                entity.thumbnailURL = product.thumbnailURL
                entity.imageURL = product.imageURL
                entity.priceText = product.priceText
                entity.quantity = (entity.quantity ?? 0) + 1
                try context.save()
                completion(true, nil)
            } catch {
                completion(false, error)
            }
        }
    }

    func updateProductQuantity(productId: String, increment: Int32, completion: @escaping (Bool) -> Void) {
        let context = persistentContainer.viewContext
        context.perform {
            let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", productId)
            
            do {
                let results = try context.fetch(fetchRequest)
                if let product = results.first {
                    product.quantity += increment
                    if product.quantity < 0 { product.quantity = 0 }
                    try context.save()
                    completion(true)
                } else {
                    completion(false)
                }
            } catch {
                completion(false)
            }
        }
    }

    func deleteProduct(productId: String, completion: @escaping (Bool) -> Void) {
        let context = persistentContainer.viewContext
        context.perform {
            let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", productId)
            
            do {
                if let product = try context.fetch(fetchRequest).first {
                    context.delete(product)
                    try context.save()
                    completion(true)
                } else {
                    completion(false)
                }
            } catch {
                completion(false)
            }
        }
    }

    func fetchProduct(productId: String, completion: @escaping (Product?) -> Void) {
        let context = persistentContainer.viewContext
        context.perform {
            let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", productId)
            
            do {
                let results = try context.fetch(fetchRequest)
                if let productEntity = results.first {
                    let product = Product(id: productEntity.id,
                                          name: productEntity.name ?? "",
                                          attribute: productEntity.attribute ?? "",
                                          thumbnailURL: productEntity.thumbnailURL,
                                          squareThumbnailURL: productEntity.squareThumbnailURL,
                                          imageURL: productEntity.imageURL,
                                          price: productEntity.price,
                                          priceText: productEntity.priceText ?? "",
                                          quantity: productEntity.quantity ?? 0)
                    completion(product)
                } else {
                    completion(nil)
                }
            } catch {
                completion(nil)
            }
        }
    }

    func calculateTotalCartValue(completion: @escaping (Double) -> Void) {
        let context = persistentContainer.viewContext
        context.perform {
            let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
            
            do {
                let results = try context.fetch(fetchRequest)
                let totalPrice = results.reduce(0.0) { (currentSum, productEntity) -> Double in
                    let quantity = Double(productEntity.quantity ?? 0)
                    let price = Double(productEntity.priceText?.replacingOccurrences(of: "₺", with: "").replacingOccurrences(of: ",", with: ".") ?? "0") ?? 0.0
                    return currentSum + (quantity * price)
                }
                completion(totalPrice)
            } catch {
                completion(0.0)
            }
        }
    }

    func checkProductInCoreData(productId: String, completion: @escaping (Int32?) -> Void) {
        let context = persistentContainer.viewContext
        context.perform {
            let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", productId)
            
            do {
                let results = try context.fetch(fetchRequest)
                let quantity = results.first?.quantity
                completion(quantity)
            } catch {
                completion(nil)
            }
        }
    }
    
    func fetchAllProducts(completion: @escaping ([Product]) -> Void) {
        let context = persistentContainer.viewContext
        context.perform {
            let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
            do {
                let results = try context.fetch(fetchRequest)
                let products = results.map { (productEntity) -> Product in
                    return Product(id: productEntity.id,
                                   name: productEntity.name,
                                   attribute: productEntity.attribute,
                                   thumbnailURL: productEntity.thumbnailURL,
                                   squareThumbnailURL: productEntity.squareThumbnailURL,
                                   imageURL: productEntity.imageURL,
                                   price: productEntity.price,
                                   priceText: productEntity.priceText,
                                   quantity: productEntity.quantity)
                }
                completion(products)
            } catch {
                completion([])
            }
        }
    }


    func deleteAllProducts(completion: @escaping (Bool) -> Void) {
        let context = persistentContainer.viewContext
        context.perform {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ProductEntity.fetchRequest()
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try context.execute(batchDeleteRequest)
                try context.save()
                completion(true)
            } catch {
                completion(false)
            }
        }
    }

    func fetchCartProductIDs(completion: @escaping ([String]) -> Void) {
        let context = persistentContainer.viewContext
        context.perform {
            let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
            do {
                let results = try context.fetch(fetchRequest)
                let ids = results.compactMap { $0.id }
                completion(ids)
            } catch {
                completion([])
            }
        }
    }
}

