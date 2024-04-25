//
//  File.swift
//  
//
//  Created by Damla Sahin on 22.04.2024.
//

import Foundation

public protocol ProductResponseProtocol {
    func fetchProducts(completion: @escaping (Result<[ProductResponse], Error>) -> Void)
    func fetchSuggestedProducts(completion: @escaping (Result<[ProductResponse], Error>) -> Void)
}

public class ProductService: ProductResponseProtocol {
    
    public init() {}

    public func fetchProducts(completion: @escaping (Result<[ProductResponse], Error>) -> Void) {
        let url = URL(string: "https://65c38b5339055e7482c12050.mockapi.io/api/products")!
        fetchData(from: url, completion: completion)
    }

    public func fetchSuggestedProducts(completion: @escaping (Result<[ProductResponse], Error>) -> Void) {
        let url = URL(string: "https://65c38b5339055e7482c12050.mockapi.io/api/suggestedProducts")!
        fetchData(from: url, completion: completion)
    }

    private func fetchData(from url: URL, completion: @escaping (Result<[ProductResponse], Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let productResponses = try JSONDecoder().decode([ProductResponse].self, from: data)
                    completion(.success(productResponses))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }

}
