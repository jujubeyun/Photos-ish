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
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    private let api_key = "live_gDmggwLjUW9czpSu1M4z0gAxeQGB4zdWCyDUCiRbgrLoHUEgsScYk6q0XLRlz6jO"
    private let numberOfImages = 100
    
    private var urlString: String {
        "https://api.thecatapi.com/v1/images/search?limit=\(numberOfImages)&api_key=\(api_key)"
    }
    
    func fetchCatImages() async throws -> [CatImage] {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode([CatImage].self, from: data)
        } catch {
            throw NetworkError.invalidData
        }
    }
    
    func downloadImage(fromURLString urlString: String, completed: @escaping (UIImage?) -> Void) {
        
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                completed(nil)
                return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }.resume()
    }
}
