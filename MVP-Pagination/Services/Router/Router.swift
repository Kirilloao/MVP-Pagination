//
//  Services.swift
//  MVP-Pagination
//
//  Created by Kirill Taraturin on 09.12.2023.
//

import UIKit

// MARK: - RouterMain
protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var moduleBuilder: ModuleBuilderProtocol? { get set }
}

// MARK: - RouterProtocol
protocol RouterProtocol: RouterMain {
    func initialViewController()
    func showDetails(image: String?)
}

// MARK: - Router
final class Router: RouterProtocol {
    
    var navigationController: UINavigationController?
    var moduleBuilder: ModuleBuilderProtocol?
    
    init(navigationController: UINavigationController, moduleBuilder: ModuleBuilderProtocol) {
        self.navigationController = navigationController
        self.moduleBuilder = moduleBuilder
    }

    func initialViewController() {
        if let navigationController = navigationController {
            guard let mainVC = moduleBuilder?.createListModule(router: self) else { return }
            navigationController.viewControllers = [mainVC]
        }
    }
    
    func showDetails(image: String?) {
        if let navigationController = navigationController {
            guard let details = moduleBuilder?.createDetailsModule(image: image, router: self) else { return }
            navigationController.pushViewController(details, animated: true)
        }
    }
}
