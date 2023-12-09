//
//  ModuleBuilder.swift
//  MVP-Pagination
//
//  Created by Kirill Taraturin on 08.12.2023.
//

import UIKit

// MARK: - ModuleBuilderProtocol
protocol ModuleBuilderProtocol {
    func createListModule(router: RouterProtocol) -> UIViewController
    func createDetailsModule(image: String?, router: RouterProtocol) -> UIViewController
}

// MARK: - ModuleBuilderProtocol
final class ModuleBuilder: ModuleBuilderProtocol {
    func createListModule(router: RouterProtocol) -> UIViewController {
        let view = ListViewController()
        let networkManager = NetworkManager.shared
        let presenter = ListPresenter(view: view, networkManager: networkManager, router: router)
        view.presenter = presenter
        return view
    }
    
    func createDetailsModule(image: String?, router: RouterProtocol) -> UIViewController {
        let view = DetailsViewController()
        let networkManager = NetworkManager.shared
        let presenter = DetailsPresenter(view, networkManager: networkManager, image: image ?? "")
        view.presenter = presenter
        return view
    }
}
