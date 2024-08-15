//
//  NetworkManager.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/9/24.
//

import UIKit

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    private let api_key = "live_gDmggwLjUW9czpSu1M4z0gAxeQGB4zdWCyDUCiRbgrLoHUEgsScYk6q0XLRlz6jO"
    private let numberOfImages = 100
    
    private var urlString: String {
        "https://api.thecatapi.com/v1/images/search?limit=\(numberOfImages)&api_key=\(api_key)"
    }
    
    func fetchCatImages() async throws -> [CatResponse] {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode([CatResponse].self, from: data)
        } catch {
            throw NetworkError.invalidData
        }
    }
    
    func downsample(from urlString: String, to pointSize: CGSize, scale: CGFloat, completed: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            guard let url = URL(string: urlString) else {
                print("Invalid URL")
                completed(nil)
                return
            }
            
            let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
            guard let imageSource = CGImageSourceCreateWithURL(url as CFURL, imageSourceOptions) else {
                print("Failed to create image source")
                completed(nil)
                return
            }
            
            let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
            let downsampleOptions = [kCGImageSourceCreateThumbnailFromImageAlways: true,
                                             kCGImageSourceShouldCacheImmediately: true,
                                       kCGImageSourceCreateThumbnailWithTransform: true,
                                              kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels] as CFDictionary
            
            guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
                print("Failed to downsample")
                completed(nil)
                return
            }
            
            let image = UIImage(cgImage: downsampledImage)
            completed(image)
        }
    }
}
