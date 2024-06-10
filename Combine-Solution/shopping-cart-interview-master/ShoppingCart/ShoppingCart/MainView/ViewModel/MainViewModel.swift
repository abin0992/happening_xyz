//
//  MainViewModel.swift
//  ShoppingCart
//
//  Created by Abin Baby on 15/05/2024.
//

import Foundation
import Combine

class MainViewModel: ObservableObject {

    @Published var cellViewModels: [ProductTableViewCellViewModel] = []
    @Published var allItems: [Product] = []
    @Published var cartItems: [CartItem] = []
    @Published var totalPrice: Double = 0.0

    private var cancellables = Set<AnyCancellable>()

    init() {
        fetchAllProducts()
    }

    func fetchAllProducts() {
        fetchProducts()
            .receive(on: DispatchQueue.main)
            .map { products in
                products.map { ProductTableViewCellViewModel(product: $0) }
            }
            .sink(receiveCompletion: { _ in }) { [weak self] viewModels in
                self?.cellViewModels = viewModels
                self?.setupBindings()
            }
            .store(in: &cancellables)
    }
}

private extension MainViewModel {

    func fetchProducts() -> AnyPublisher<[Product], Error> {
        guard let url = URL(string: "https://apache.superology.dev/interview/getAllProducts") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: ProductResponse.self, decoder: JSONDecoder())
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

    func setupBindings() {
        cellViewModels.forEach { cellViewModel in
            cellViewModel.addItemAction
                .sink { [weak self] in
                    self?.updateTotalPrice()
                }
                .store(in: &cancellables)

            cellViewModel.removeItemAction
                .sink { [weak self] in
                    self?.updateTotalPrice()
                }
                .store(in: &cancellables)
        }

        updateTotalPrice()
    }

    func updateTotalPrice() {
        totalPrice = cellViewModels.reduce(0) { $0 + Double($1.count) * $1.price }
    }
}
