//
//  ImageCell.swift
//  MVP-Pagination
//
//  Created by Kirill Taraturin on 06.12.2023.
//

import UIKit
import SnapKit

final class ImageCell: UITableViewCell {
    
    // MARK: - ReuseID
    static let reuseID = String(describing: ImageCell.self)
    
    // MARK: - NetworkManager
    private let  networkManager = NetworkManager()
    
    // MARK: - Private UI Properties
    private lazy var mainImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private var activityIndicator = UIActivityIndicatorView()
    
    // MARK: - Private Properties
    private var imageURL: URL? {
        didSet {
            mainImageView.image = nil
            updateImage()
        }
    }
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setViews()
        setupConstraints()
        activityIndicator = showSpinner(in: mainImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(_ image: String) {
        imageURL = URL(string: image)
        
    }
    
    // MARK: - Private Methods
    private func getImage(from url: URL, completion: @escaping(Result<UIImage, Error>) -> Void) {
        if let cachedImage = ImageCacheManager.shared.object(forKey: url.lastPathComponent as NSString) {
            completion(.success(cachedImage))
            return
        }
        
        networkManager.fetchImage(with: url) { result in
            switch result {
            case .success(let imageData):
                guard let uiImage = UIImage(data: imageData) else { return }
                ImageCacheManager.shared.setObject(uiImage, forKey: url.lastPathComponent as NSString)
                completion(.success(uiImage))
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func updateImage() {
        guard let imageURL = imageURL else { return }
        
        getImage(from: imageURL) { [weak self] result in
            switch result {
            case .success(let image):
                if imageURL == self?.imageURL {
                    self?.mainImageView.image = image
                    self?.activityIndicator.stopAnimating()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func showSpinner(in view: UIView) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        view.addSubview(activityIndicator)
        activityIndicator.color = .darkGray
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalTo(mainImageView.snp.centerX)
            make.centerY.equalTo(mainImageView.snp.centerY)
        }
        
        return activityIndicator
    }
}

// MARK: - Setup Views
private extension ImageCell {
    func setViews() {
        contentView.addSubview(mainImageView)
    }
    
    func setupConstraints() {
        mainImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
    }
}
