//
//  CellModel.swift
//  MVP-Pagination
//
//  Created by Kirill Taraturin on 05.12.2023.
//

import UIKit

struct CellModel {
    let identifier: String
    var onfil: ((UITableViewCell, IndexPath) -> Void)?
    var onSelect: ((IndexPath) -> Void)?
    var didScroll: ((UIScrollView) -> Void)?
}
