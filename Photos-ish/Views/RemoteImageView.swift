//
//  RemoteImageView.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/9/24.
//

import SwiftUI

final class ImageLoader: ObservableObject {
    
    @Published var image: Image? = nil
    
    func load(fromURLString urlString: String, size: Int) {        
        let size = CGSize(width: size, height: size)
        NetworkManager.shared.downsample(from: urlString, to: size, scale: 1.0) { [weak self] uiImage in
            guard let uiImage = uiImage else { return }
            DispatchQueue.main.async {
                self?.image = Image(uiImage: uiImage)
            }
        }
    }
}

struct RemoteImage: View {
    
    var image: Image?
    
    var body: some View {
        image?.resizable() ?? Image(uiImage: UIImage())
    }
}

struct RemoteImageView: View {
    
    @StateObject var imageLoader = ImageLoader()
    let photo: Photo
    let imageContentMode: ContentMode
    let shouldShowFavoriteMark: Bool
    let isGrid: Bool
    
    var body: some View {
        Rectangle()
            .onAppear { imageLoader.load(fromURLString: photo.url, size: Int(isGrid ? 200 : UIScreen.main.bounds.width)) }
            .foregroundColor(.clear)
            .overlay {
                GeometryReader { geometry in
                    RemoteImage(image: imageLoader.image)
                        .aspectRatio(contentMode: imageContentMode)
                        .frame(width: geometry.size.width,
                               height: geometry.size.height,
                               alignment: .center)
                        .clipped()
                        .overlay(alignment: .bottomLeading) {
                            if photo.isFavorite && shouldShowFavoriteMark { FavoriteMark() }
                        }
                }
            }
    }
}
