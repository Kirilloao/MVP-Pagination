//
//  ImgurResponse.swift
//  MVP-Pagination
//
//  Created by Kirill Taraturin on 06.12.2023.
//

import Foundation

// MARK: - ImgurResponse
struct ImageResponse: Decodable {
    let data: [ImageItem]
}

// MARK: - ImgurItem
struct ImageItem: Decodable {
    let isAlbum: Bool?
    let link: String
    let type: String?
    let images: [Image]?

    enum CodingKeys: String, CodingKey {
        case isAlbum = "is_album"
        case link, type, images
    }
}

// MARK: - ImgurImage
struct Image: Decodable {
    let link: String
    let type: String
}
