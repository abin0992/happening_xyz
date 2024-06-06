//
//  ProductTableViewCell.swift
//  ShoppingCart
//
//  Created by Mislav Šunjo on 26.03.2024..
//

import UIKit

final class ProductTableViewCell: UITableViewCell {

    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let stackView = UIStackView()
    private let countLabel = UILabel()
    private let minusButton = UIButton()
    private let plusButton = UIButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        setupStyle()

        nameLabel.text = "Bread"
        priceLabel.text = "1€"
        countLabel.text = "0"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(minusButton)
        stackView.addArrangedSubview(countLabel)
        stackView.addArrangedSubview(plusButton)

        nameLabel.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview().inset(12)
        }

        priceLabel.snp.makeConstraints {
            $0.centerY.equalTo(nameLabel)
            $0.leading.equalTo(nameLabel.snp.trailing).offset(8)
        }

        stackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-12)
            $0.centerY.equalTo(nameLabel)
            $0.leading.greaterThanOrEqualTo(priceLabel.snp.trailing).offset(4)
        }

        countLabel.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(30)
        }
    }

    private func setupStyle() {
        nameLabel.font = .systemFont(ofSize: 18)
        nameLabel.textColor = .darkText

        priceLabel.font = .systemFont(ofSize: 16)
        priceLabel.textColor = .darkText

        countLabel.font = .systemFont(ofSize: 18)
        countLabel.textColor = .darkText
        countLabel.textAlignment = .center

        minusButton.setTitle("-", for: .normal)
        minusButton.setTitleColor(.black, for: .normal)

        plusButton.setTitle("+", for: .normal)
        plusButton.setTitleColor(.black, for: .normal)

        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        selectionStyle = .none
    }
}
