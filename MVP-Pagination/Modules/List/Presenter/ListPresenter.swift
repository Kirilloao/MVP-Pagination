//
//  ListPresenter.swift
//  MVP-Pagination
//
//  Created by Kirill Taraturin on 08.12.2023.
//

import Foundation

protocol ListPresenterProtocol: AnyObject {
    init(view: ListViewControllerProtocol, networkManager: NetworkManagerProtocol, router: RouterProtocol)
    var list: [String] { get set }
    func getImages()
    func loadNextPage()
    func tapOnImage(image: String)
}

final class ListPresenter: ListPresenterProtocol {
    
    // MARK: - Public Properties
    var list: [String] = []
    
    // MARK: - Private Properties
    private unowned let view: ListViewControllerProtocol
    private var pageNumber = 0
    private var router: RouterProtocol?
    private var networkManager: NetworkManagerProtocol!
    
    // MARK: - Init
    init(view: ListViewControllerProtocol, networkManager: NetworkManagerProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
        self.networkManager = networkManager
    }
    
    // MARK: - Public Methods
    func getImages() {
        NetworkManager.shared.fetchUrls(with: pageNumber) { [weak self] result in
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
                NetworkManager.shared.isPaginating = false
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
        router?.showDetails(image: image)
    }
}
