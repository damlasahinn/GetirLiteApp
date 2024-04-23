//
//  Notification.swift
//  GetirLiteApp
//
//  Created by Damla Sahin on 20.04.2024.
//

import Foundation
import CoreData

extension Notification.Name {
    static let didUpdateCartTotal = Notification.Name("didUpdateCartTotal")
}

class CartManager {
    static let shared = CartManager()
    
    var totalCartValue: Double = 0 {
        didSet {
            NotificationCenter.default.post(name: .didUpdateCartTotal, object: nil, userInfo: ["totalValue": totalCartValue])
        }
    }
    
    func calculateTotalCartValue() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            totalCartValue = results.reduce(0) { total, entity in
                let priceText = entity.priceText ?? "0" 
                let price = (priceText as NSString).doubleValue
                let quantity = Double(entity.quantity)
                return total + price * quantity
            }
        } catch {
            print("Calculating Error: \(error)")
        }
    }
    
    func addObserver(_ observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: .didUpdateCartTotal, object: nil)
    }
    
    func removeObserver(_ observer: Any) {
        NotificationCenter.default.removeObserver(observer, name: .didUpdateCartTotal, object: nil)
    }
}
