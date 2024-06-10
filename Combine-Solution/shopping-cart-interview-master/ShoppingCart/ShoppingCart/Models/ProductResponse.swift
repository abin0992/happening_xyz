//
//  ProductResponse.swift
//  ShoppingCart
//
//  Created by Abin Baby on 06/06/2024.
//

import Foundation

// MARK: - ProductResponse
struct ProductResponse: Codable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let products: [ProductName]
    let prices: [ProductPrice]
}

// MARK: - Price
struct ProductPrice: Codable {
    let id: String
    let price: Double
}

// MARK: - Product
struct ProductName: Codable {
    let id: String
    let name: String
}
