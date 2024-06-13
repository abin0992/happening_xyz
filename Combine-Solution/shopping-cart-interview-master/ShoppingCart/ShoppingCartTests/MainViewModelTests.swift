//
//  MainViewModelTests.swift
//  ShoppingCartTests
//
//  Created by Abin Baby on 10/06/2024.
//

import XCTest
import Combine
@testable import ShoppingCart

class MainViewModelTests: XCTestCase {

    var viewModel: MainViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        viewModel = MainViewModel()
        cancellables = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        cancellables = nil
    }

    func testFetchAllProducts() throws {
        let expectation = XCTestExpectation(description: "Fetch products")

        viewModel.$cellViewModels
            .dropFirst() // Ignore the initial value
            .sink { cellViewModels in
                XCTAssertGreaterThan(cellViewModels.count, 0, "Cell view models should be populated")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.fetchAllProducts()

        wait(for: [expectation], timeout: 5.0)
    }

    func testAddItemUpdatesTotalPrice() throws {
        let product = Product(id: "1", name: "Product 1", price: 10.0)
        let cellViewModel = ProductTableViewCellViewModel(product: product)
        viewModel.cellViewModels = [cellViewModel]
        viewModel.setupBindings()

        let expectation = XCTestExpectation(description: "Total price updated")

        viewModel.$totalPrice
            .dropFirst()
            .sink { totalPrice in
                XCTAssertEqual(totalPrice, 10.0, "Total price should be 10.0 after adding one item")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        cellViewModel.addItem()

        wait(for: [expectation], timeout: 1.0)
    }

    func testRemoveItemUpdatesTotalPrice() throws {
        let product = Product(id: "1", name: "Product 1", price: 10.0)
        let cellViewModel = ProductTableViewCellViewModel(product: product)
        viewModel.cellViewModels = [cellViewModel]
        viewModel.setupBindings()
        cellViewModel.addItem()

        let expectation = XCTestExpectation(description: "Total price updated")

        viewModel.$totalPrice
            .dropFirst()
            .sink { totalPrice in
                XCTAssertEqual(totalPrice, 0.0, "Total price should be 0.0 after removing the item")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        cellViewModel.removeItem()

        wait(for: [expectation], timeout: 1.0)
    }
}
