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

    let initialDummyData: [Product] = [
        Product(
            id: "7aa080fd-aafc-4cd7-9d26-030457708297",
            name: "Bread",
            price: 1.25
        ),
        Product(
            id: "05313b70-ffc8-40c0-958c-46f595b75ea9",
            name: "Milk",
            price: 0.94
        )
    ]

    init() {
        self.allItems = initialDummyData
        self.cellViewModels = initialDummyData.map { ProductTableViewCellViewModel(product: $0) }
        setupBindings()
    }
}

private extension MainViewModel {
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
