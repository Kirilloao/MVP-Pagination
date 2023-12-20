//
//  AppCoordinator.swift
//  MVP-Pagination
//
//  Created by Kirill Taraturin on 18.12.2023.
//

import UIKit

// MARK: - Coordinator
protocol CoordinatorProtocol: AnyObject {
    func start()
    func showDetails(with image: String)
}

// MARK: - AppCoordinator
final class AppCoordinator: CoordinatorProtocol {

    private var navigationController: UINavigationController
    private let moduleBuilder = ModuleBuilder()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let listVC = moduleBuilder.createListModule(with: self)
        navigationController.pushViewController(listVC, animated: false)
    }
    
    func showDetails(with image: String) {
        let detailVC = moduleBuilder.createDetailsModule(image: image)
        navigationController.pushViewController(detailVC, animated: true)
    }

}
