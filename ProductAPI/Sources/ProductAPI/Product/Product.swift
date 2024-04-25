//
//  File.swift
//  
//
//  Created by Damla Sahin on 22.04.2024.
//

import Foundation
import CoreData

public struct Product: Decodable {
    public let id: String?
    public let name: String?
    public let attribute: String?
    public let thumbnailURL: String?
    public let squareThumbnailURL: String?
    public let imageURL: String?
    public let price: Double?
    public let priceText: String?
    public var quantity: Int32?
    
    public var bestAvailableURL: String? {
        return imageURL ?? squareThumbnailURL ?? thumbnailURL
    }
    
    public init(id: String?, name: String?, attribute: String?, thumbnailURL: String?,squareThumbnailURL: String?, imageURL: String?, price: Double?, priceText: String?, quantity: Int32?) {
        self.id = id
        self.name = name
        self.attribute = attribute
        self.thumbnailURL = thumbnailURL
        self.squareThumbnailURL = squareThumbnailURL
        self.imageURL = imageURL
        self.price = price
        self.priceText = priceText
        self.quantity = quantity
    }
}

public struct ProductResponse: Decodable {
    public let id: String?
    public let name: String?
    public let productCount: Int32?
    public let products: [Product]?

    enum CodingKeys: String, CodingKey {
        case id, name, productCount, products
    }
}
