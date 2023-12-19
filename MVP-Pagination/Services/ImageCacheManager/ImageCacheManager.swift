//
//  CacheManager.swift
//  MVP-Pagination
//
//  Created by Kirill Taraturin on 08.12.2023.
//

import UIKit

final class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    
    private init() {}
}
