//
//  ProductDetailInteractor.swift
//  GetirLiteApp
//
//  Created by Damla Sahin on 11.04.2024.
//

import CoreData
import ProductAPI

protocol ProductDetailInteractorProtocol: AnyObject {
    func fetch()
    func saveProduct(_ product: Product)
    func checkProductInCoreData(_ productId: String, completion: @escaping (Int32?) -> Void)
    func updateProductQuantity(productId: String, increment: Int32)
    func deleteProductFromCoreData(productId: String, completion: @escaping () -> Void)
    func fetchUpdatedProduct(with productId: String)
    func calculateTotalCartValue(completion: @escaping (Double) -> Void)
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
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", productId)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let product = results.first {
                product.quantity += increment
                if product.quantity < 0 { product.quantity = 0 }
                try context.save()
                print("Successfully saved: \(product.quantity)")
                output?.fetchOutput()
            } else {
                print("No product found with ID \(productId)")
            }
        } catch {
            print("Failed to update quantity: \(error)")
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
    
    func deleteProductFromCoreData(productId: String, completion: @escaping () -> Void) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", productId)
        
        do {
            if let product = try context.fetch(fetchRequest).first {
                context.delete(product)
                try context.save()
                output?.fetchOutput()
                completion()
            }
        } catch {
            print("Failed to delete products: \(error)")
        }
    }
    
    func fetchUpdatedProduct(with productId: String) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", productId)
        do {
            let results = try context.fetch(fetchRequest)
            if let productEntity = results.first {
                let product = Product(id: productEntity.id,
                                      name: productEntity.name ?? "",
                                      attribute: productEntity.attribute ?? "",
                                      thumbnailURL: productEntity.thumbnailURL, squareThumbnailURL: productEntity.squareThumbnailURL,
                                      imageURL: productEntity.imageURL, price: productEntity.price,
                                      priceText: productEntity.priceText ?? "",
                                      quantity: productEntity.quantity ?? 0)


                output?.productFetched(product)
            }
        } catch {
            print("Error fetching product: \(error)")
        }
    }
    
    func fetch() {
        //TODO: fetchOutput
    }
    
    func saveProduct(_ product: Product) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
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
            print("Product saved or updated")
        } catch {
            print("Failed to save or update product: \(error)")
        }
    }
    
    func checkProductInCoreData(_ productId: String, completion: @escaping (Int32?) -> Void) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", productId)
        do {
            let results = try context.fetch(fetchRequest)
            let quantity = results.first?.quantity
            completion(quantity)
        } catch {
            print("Failed to fetch product: \(error)")
            completion(nil)
        }
    }
    
    private func fetchAllProducts(in context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            //print("Currently stored products:")
            results.forEach { product in
                print("ID: \(product.id ?? ""), Name: \(product.name ?? ""), Quantitiy: \(product.quantity), Price: \(product.priceText ?? ""), Attribute: \(product.attribute ?? ""), Image URL: \(product.imageURL ?? "")")
            }
        } catch {
            print("Failed to fetch products: \(error)")
        }
    }
}
