//
//  ListPresenter.swift
//  MVP-Pagination
//
//  Created by Kirill Taraturin on 08.12.2023.
//

import Foundation

// MARK: - ListPresenterProtocol
protocol ListPresenterProtocol: AnyObject {
    var list: [String] { get }
    init(view: ListViewControllerProtocol, networkManager: NetworkManagerProtocol, coordinator: CoordinatorProtocol)
    func getImages()
    func loadNextPage()
    func tapOnImage(image: String)
}

// MARK: - ListPresenter
final class ListPresenter: ListPresenterProtocol {
    
    var list: [String] = []
    
    private let view: ListViewControllerProtocol
    private var coordinator: CoordinatorProtocol
    private var pageNumber = 0
    private var networkManager: NetworkManagerProtocol!
    
    init(view: ListViewControllerProtocol, networkManager: NetworkManagerProtocol, coordinator: CoordinatorProtocol) {
        self.view = view
        self.networkManager = networkManager
        self.coordinator = coordinator
    }
    
    func getImages() {
        networkManager.fetchUrls(with: pageNumber, pagination: false) { [weak self] result in
            switch result {
            case .success(let list):
                self?.list = list
                self?.view.success()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadNextPage() {
        guard !networkManager.isPaginating else {
            return
        }
        
        pageNumber += 1
        networkManager.isPaginating = true
        
        networkManager.fetchUrls(with: pageNumber, pagination: true) { [weak self] result in
            defer {
                self?.networkManager.isPaginating = false
            }
            switch result {
            case .success(let list):
                self?.list.append(contentsOf: list)
                self?.view.success()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func tapOnImage(image: String) {
        coordinator.showDetails(with: image)
    }
}
