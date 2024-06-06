//
//  ProductTableViewCellViewModel.swift
//  ShoppingCart
//
//  Created by Abin Baby on 05/06/2024.
//

import Combine
import Foundation

final class ProductTableViewCellViewModel: ObservableObject {
    
    let id: UUID = UUID()

    let name: String
    let price: Double
    @Published var count: Int = 0

    let addItemAction = PassthroughSubject<Void, Never>()
    let removeItemAction = PassthroughSubject<Void, Never>()

    init(product: Product) {
        self.name = product.name
        self.price = product.price
    }

    func addItem() {
        count += 1
        addItemAction.send(())
    }

    func removeItem() {
        if count > 0 {
            count -= 1
            removeItemAction.send(())
        }
    }
}

extension ProductTableViewCellViewModel: Hashable {

    static func == (lhs: ProductTableViewCellViewModel, rhs: ProductTableViewCellViewModel) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
