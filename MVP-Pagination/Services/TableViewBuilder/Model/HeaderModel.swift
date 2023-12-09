//
//  HeaderModel.swift
//  MVP-Pagination
//
//  Created by Kirill Taraturin on 05.12.2023.
//

import UIKit

struct HeaderModel {
    var identifier: String
    var onFill: ((UITableViewHeaderFooterView) -> Void)?
}

