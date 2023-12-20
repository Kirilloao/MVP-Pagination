//
//  ModuleBuilder.swift
//  MVP-Pagination
//
//  Created by Kirill Taraturin on 20.12.2023.
//

import UIKit

// MARK: - ModuleBuilderProtocol
protocol ModuleBuilderProtocol {
    func createListModule(with coordinator: CoordinatorProtocol) -> UIViewController
    func createDetailsModule(image: String?) -> UIViewController
}

// MARK: - ModuleBuilder
final class ModuleBuilder: ModuleBuilderProtocol {
    func createListModule(with coordinator: CoordinatorProtocol) -> UIViewController {
        let view = ListViewController()
        let networkManager = NetworkManager()
        let presenter = ListPresenter(view: view, networkManager: networkManager, coordinator: coordinator)
        view.presenter = presenter
        return view
    }
    
    func createDetailsModule(image: String?) -> UIViewController {
        let view = DetailsViewController()
        let networkManager = NetworkManager()
        let presenter = DetailsPresenter(view, networkManager: networkManager, image: image ?? "")
        view.presenter = presenter
        return view
    }
}
