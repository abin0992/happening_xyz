//
//  APIEndpoint.swift
//  ShoppingCart
//
//  Created by Abin Baby on 06/06/2024.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol URLConfig {
    var url: URL { get }
}

private struct APIEndpoint: URLConfig {
    
    let path: String
    var queryItems: [URLQueryItem] = []
    var url: URL {
        var components: URLComponents = URLComponents()
        components.scheme = "https"
        components.host = AppConfiguration.apiBaseURL
        components.path = path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            DLog("Invalid URL components: \(components)")
            preconditionFailure(
                "Invalid URL components: \(components)"
            )
        }
        
        return url
    }
}

protocol NetworkConfigurable {
    func fetchProducts() -> URLConfig
}

struct ProductUrlConfig: NetworkConfigurable {

    static let shared: ProductUrlConfig = ProductUrlConfig()

    private init() {}

    func fetchProducts() -> URLConfig {
        APIEndpoint(path: "/interview/getAllProducts")
    }
}
