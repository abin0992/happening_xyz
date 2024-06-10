//
//  MainViewController.swift
//  ShoppingCart
//
//  Created by Domagoj Kopić on 15.03.2024..
//

import UIKit
import SnapKit
import Combine
import SwiftUI

class MainViewController: UIViewController {

     @ObservedObject var viewModel = MainViewModel()

    private let tableView = UITableView()
    
    private var cancellables = Set<AnyCancellable>()

    private lazy var dataSource: UITableViewDiffableDataSource<String, AnyHashable> = {
        UITableViewDiffableDataSource(tableView: tableView) { [weak self] tableView, indexPath, item in
            if let _ = item as? String {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SumTableViewCell.reuseIdentifier, for: indexPath) as? SumTableViewCell else {
                    return UITableViewCell()
                }
                cell.bind(totalPrice: self?.viewModel.totalPrice ?? 0.0)
                return cell
            } else if let viewModel = item as? ProductTableViewCellViewModel {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.reuseIdentifier, for: indexPath) as? ProductTableViewCell else {
                    return UITableViewCell()
                }
                cell.configure(with: viewModel)
                return cell
            } else {
                return UITableViewCell()
            }
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Shopping cart"
        setupLayout()
        setupTableView()
        bindViewModel()
        setupSnapshot()
   //     viewModel.fetchAllProducts()
    }

    private func setupSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<String, AnyHashable>()
        snapshot.appendSections(["Section 1"])
        snapshot.appendItems(["Sum Identifier"])
        snapshot.appendItems(viewModel.cellViewModels)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func setupTableView() {
        tableView.register(
            SumTableViewCell.self,
            forCellReuseIdentifier: SumTableViewCell.reuseIdentifier
        )
        tableView.register(
            ProductTableViewCell.self,
            forCellReuseIdentifier: ProductTableViewCell.reuseIdentifier
        )
        tableView.separatorStyle = .none
    }
}

private extension MainViewController {
    func bindViewModel() {
            viewModel.$cellViewModels
            .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.setupSnapshot()
                }
                .store(in: &cancellables)
            
            viewModel.$totalPrice
            .receive(on: DispatchQueue.main)
                .sink { [weak self] totalPrice in
                    if let sumCell = self?.tableView.visibleCells.compactMap({ $0 as? SumTableViewCell }).first {
                        sumCell.bind(totalPrice: totalPrice)
                    }
                }
                .store(in: &cancellables)
        }
}
