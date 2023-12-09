//
//  DetailsViewController.swift
//  MVP-Pagination
//
//  Created by Kirill Taraturin on 09.12.2023.
//

import UIKit

protocol DetailsViewControllerProtocol {
    func showImage(_ image: Data)
}

final class DetailsViewController: UIViewController {
    
    // MARK: - Presenter
    var presenter: DetailsViewPresenterProtocol!
    
    // MARK: - Private UI Properties
    private lazy var mainImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        var activity = UIActivityIndicatorView()
        activity.hidesWhenStopped = true
        activity.style = .medium
        activity.color = .darkGray
        activity.startAnimating()
        return activity
    }()
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setupConstraints()
        presenter.showImage()
    }
    
    // MARK: - Private Methods
    private func setViews() {
        view.backgroundColor = .white
        view.addSubview(mainImageView)
        mainImageView.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        mainImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
            make.height.equalTo(200)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}

// MARK: - DetailsViewControllerProtocol
extension DetailsViewController: DetailsViewControllerProtocol {
    func showImage(_ image: Data) {
        mainImageView.image = UIImage(data: image)
        activityIndicator.stopAnimating()
    }
}
