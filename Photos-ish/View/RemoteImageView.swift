//
//  RemoteImageView.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/9/24.
//

import SwiftUI

@Observable final class ImageLoader {
    var image: Image? = nil
    
    func load(fromURLString urlString: String) async throws {
        let uiImage = try await NetworkManager.shared.downloadImage(fromURLString: urlString)
        image = Image(uiImage: uiImage)
    }
}

struct RemoteImage: View {
    
    var image: Image?
    
    var body: some View {
        image?.resizable() ?? Image("").resizable()
    }
}

struct RemoteImageView: View {
    
    let imageLoader = ImageLoader()
    let urlString: String
    
    var body: some View {
        RemoteImage(image: imageLoader.image)
            .task {
                do {
                    try await imageLoader.load(fromURLString: urlString)
                } catch {
                    // TODO: - handle errors
                    print(error)
                }
            }
    }
}
