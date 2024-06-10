//
//  ProductService.swift
//  ShoppingCart
//
//  Created by Abin Baby on 06/06/2024.
//

import Combine
import Foundation

protocol ProductsFetchable {
    func fetchAllProducts() -> AnyPublisher<[Product], Error>
}

final class ProductService: ProductsFetchable {

    private lazy var decoder = JSONDecoder()
    private let config: ProductUrlConfig = ProductUrlConfig.shared

    private let httpClient: HTTPClientProtocol

    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }

    func fetchAllProducts() -> AnyPublisher<[Product], Error> {
        httpClient.performRequest(
            url: config.fetchProducts().url,
            method: .get,
            body: nil
        )
        .decode(type: ProductResponse.self, decoder: decoder)
        .map { response in
            let priceMap = response.data.prices.reduce(into: [String: Double]()) { $0[$1.id] = $1.price }
            return response.data.products.map { productData in
                guard let price = priceMap[productData.id] else {
                    fatalError("No price found for product with ID: \(productData.id)")
                }
                return Product(id: productData.id, name: productData.name, price: price)
            }
        }
        .eraseToAnyPublisher()
    }
}
