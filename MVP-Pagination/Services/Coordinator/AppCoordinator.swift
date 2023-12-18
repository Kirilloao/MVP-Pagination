//
//  AppCoordinator.swift
//  MVP-Pagination
//
//  Created by Kirill Taraturin on 18.12.2023.
//

import UIKit

// MARK: - Coordinator
protocol CoordinatorProtocol {
    func start()
    func showDetails(with image: String)
}

// MARK: - AppCoordinator
final class AppCoordinator: CoordinatorProtocol {

    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let listVC = ListViewController()
        let networkManager = NetworkManager()
        let presenter = ListPresenter(view: listVC, networkManager: networkManager, coordinator: self)
        listVC.presenter = presenter
        navigationController.pushViewController(listVC, animated: false)
    }
    
    func showDetails(with image: String) {
        let detailVC = DetailsViewController()
        let networkManager = NetworkManager()
        let presenter = DetailsPresenter(detailVC, networkManager: networkManager, image: image)
        detailVC.presenter = presenter
        navigationController.pushViewController(detailVC, animated: true)
    }
}
