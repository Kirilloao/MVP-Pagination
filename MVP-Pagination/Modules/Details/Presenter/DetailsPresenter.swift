//
//  DetailsPresenter.swift
//  MVP-Pagination
//
//  Created by Kirill Taraturin on 09.12.2023.
//

import Foundation

protocol DetailsViewPresenterProtocol {
    init(_ view: DetailsViewControllerProtocol, networkManager: NetworkManagerProtocol, image: String)
    func showImage()
}

final class DetailsPresenter: DetailsViewPresenterProtocol {
    
    // MARK: - Private Properties
    private var view: DetailsViewControllerProtocol!
    private var networkManager: NetworkManagerProtocol!
    private var image: String
    
    // MARK: - Init
    init(_ view: DetailsViewControllerProtocol, networkManager: NetworkManagerProtocol, image: String) {
        self.view = view
        self.image = image
        self.networkManager = networkManager
    }
    
    // MARK: - Public Methods
    func showImage() {
        guard let url = URL(string: image) else { return }
        networkManager.fetchImage(with: url) { result in
            switch result {
                
            case .success(let imageData):
                self.view?.showImage(imageData)
            case .failure(let error):
                print(error)
            }
        }
    }
}
