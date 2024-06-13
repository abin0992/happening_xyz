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

    private func fetchProducts() -> AnyPublisher<[Product], Error> {
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
}

extension MainViewModel {
    func createJSONPayload() -> Data? {
        let products = cellViewModels.map { viewModel in
            [
                "id": viewModel.id.uuidString,
                "amount": viewModel.count
            ]
        }
        
        let payload: [String: Any] = ["products": products]
        
        guard JSONSerialization.isValidJSONObject(payload) else {
            print("Invalid JSON object")
            return nil
        }
        
        return try? JSONSerialization.data(withJSONObject: payload, options: [])
    }
}

extension MainViewModel {
    func makePurchaseProductsRequest() {
        guard let url = URL(string: "https://apache.superology.dev/interview/purchaseProducts") else { return }
        guard let jsonData = createJSONPayload() else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error making POST request: \(error)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(String(describing: response))")
                return
            }

            if let data = data {
                print("Response data: \(String(data: data, encoding: .utf8) ?? "")")
            }
        }.resume()
    }
}
