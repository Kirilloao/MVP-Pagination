//
//  ViewController.swift
//  MVP-Pagination
//
//  Created by Kirill Taraturin on 05.12.2023.
//

import UIKit

protocol ListViewControllerProtocol: AnyObject {
    func success()
}

final class ListViewController: UIViewController {
    
    // MARK: - Presenter
    var presenter: ListPresenterProtocol?
    
    // MARK: - NetworkManager
    private let networkManager = NetworkManager()
    
    // MARK: - Private Properties
    private var tableViewBuilder: TableViewBuilder!
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private var images: [String] = []
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        setViews()
        presenter?.getImages()
        setupConstraints()
    }
    
    // MARK: - Private Methods
    private func setupTableView() {
        tableView.separatorStyle = .none
        
        let imageCell = presenter?.list.compactMap { image -> CellModel in
            var cellModel = CellModel(identifier: ImageCell.reuseID)
            
            
            cellModel.onfil = { cell, _ in
                if let customCell = cell as? ImageCell {
                    customCell.configure(image)
                }
            }
            
            cellModel.onSelect = { indexPath in
                let image = self.presenter?.list[indexPath.row]
                self.presenter?.tapOnImage(image: image ?? "")
            }
            
            return cellModel
        }
        
        tableViewBuilder.onScroll = { scrollView in
            let position = scrollView.contentOffset.y
            if position > (
                self.tableView.contentSize.height - 100 - scrollView.frame.size.height
            ) {
                guard !self.networkManager.isPaginating else {
                    return
                }
                
                self.tableView.tableFooterView = self.createSpinnerFooter()
                self.presenter?.loadNextPage()
            }
        }
        
        let imageSection = SectionModel(cells: imageCell ?? [])
        tableViewBuilder.sections = [imageSection]
    }
    
    private func registerCell() {
        tableViewBuilder = TableViewBuilder(tableView: tableView)
        tableView.register(ImageCell.self, forCellReuseIdentifier: ImageCell.reuseID)
    }
}

// MARK: - ListViewControllerProtocol
extension ListViewController: ListViewControllerProtocol {
    func success() {
        self.setupTableView()
        self.tableView.reloadData()
        self.tableView.tableFooterView = nil
    }
}

// MARK: - Setup Views
private extension ListViewController {
    func setViews() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.backgroundColor = .white
    }
    
    func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: view.frame.size.width,
            height: 100)
        )
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
}

