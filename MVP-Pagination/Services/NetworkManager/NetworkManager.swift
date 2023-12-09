//
//  NetworkManager.swift
//  MVP-Pagination
//
//  Created by Kirill Taraturin on 05.12.2023.
//

import UIKit

// MARK: - NetworkError
enum NetworkError: Error {
    case noData
    case invalidUrl
    case decodingError
}

// MARK: - NetworkManagerProtocol
protocol NetworkManagerProtocol {
    var isPaginating: Bool { get set }
    func fetchUrls(with numberOfPage: Int, pagination: Bool, completion: @escaping(Result<[String], NetworkError>) -> Void)
    func fetchImage(with url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void)
}

// MARK: - NetworkManager
final class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    
    private init() {}
    
    var isPaginating = false
    
    func fetchUrls(with numberOfPage: Int, pagination: Bool = false, completion: @escaping(Result<[String], NetworkError>) -> Void) {
        if pagination{
            isPaginating = true
        }
        
        guard
            let url = URL(string: "https://api.imgur.com/3/gallery/hot/viral/\(numberOfPage).json")
        else {
            completion(.failure(.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Client-ID 09ac4cb355d5d4a", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data
            else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "no errror description")
                return
            }
            
            do {
                let response = try JSONDecoder().decode(ImageResponse.self, from: data)
                
                let imageLinks = response.data.flatMap { item -> [String] in
                    if let images = item.images, item.isAlbum ?? false {
                        return images.filter { $0.type.hasPrefix("image/") && !$0.type.hasSuffix("gif") }.map { $0.link }
                    } else if let type = item.type, type.hasPrefix("image/") && !type.hasSuffix("gif") {
                        return [item.link]
                    }
                    return []
                }.prefix(10)
                
                DispatchQueue.main.async {
                    completion(.success(Array(imageLinks)))
                    if pagination {
                        self.isPaginating = false
                    }
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func fetchImage(with url: URL, completion: @escaping(Result<Data, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(data))
            }
        }.resume()
    }
}
