//
//  MainViewController.swift
//  ShoppingCart
//
//  Created by Domagoj Kopić on 15.03.2024..
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    private let tableView = UITableView()

    private lazy var dataSource: UITableViewDiffableDataSource<String, AnyHashable> = {
        UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, item in
            if item is String {
                let cell = tableView.dequeueReusableCell(withIdentifier: SumTableViewCell.reuseIdentifier, for: indexPath)
                return cell
            } else if item is Int {
                let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.reuseIdentifier, for: indexPath)
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
        setupSnapshot()
    }

    private func setupSnapshot() {
        var initialSnapshot = NSDiffableDataSourceSnapshot<String, AnyHashable>()
        initialSnapshot.appendSections(["Section 1"])
        initialSnapshot.appendItems(["Sum Identifier"])
        initialSnapshot.appendItems([1, 2, 3, 4])
        dataSource.apply(initialSnapshot, animatingDifferences: false)
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
