//
//  UITableViewCell+Extension.swift
//  ShoppingCart
//
//  Created by Domagoj Kopić on 18.03.2024..
//

import Foundation
import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
