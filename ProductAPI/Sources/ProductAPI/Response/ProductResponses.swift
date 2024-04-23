//
//  File.swift
//  
//
//  Created by Damla Sahin on 22.04.2024.
//

import Foundation

public struct ProductResponses: Decodable {
    public let results: [ProductResponse]?

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        results = try container.decodeIfPresent([ProductResponse].self, forKey: .results)
    }
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}
