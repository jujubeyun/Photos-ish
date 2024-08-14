//
//  GridView.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/9/24.
//

import SwiftUI

struct GridView: View {
    
    @State var scrolledID: Photo?
    let album: Album
    let photos: [Photo]
    let columnCount = 3
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: .init(repeating: .init(.flexible()), count: columnCount), spacing: 2) {
                ForEach(photos, id: \.self) { photo in
                    NavigationLink(value: photo) {
                        RemoteImageView(photo: photo)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width/3,
                                   height: UIScreen.main.bounds.width/3)
                            .clipped()
                            .overlay(alignment: .bottomLeading) {
                                if photo.isFavorite { FavoriteMark(size: 12) }
                            }
                    }
                }
            }
            .scrollTargetLayout()
        }
        .scrollPosition(id: $scrolledID)
        .navigationDestination(for: Photo.self) { photo in
            PhotoPagingView(album: album, selectedPhoto: photo, photos: photos)
        }
        .onAppear {
            scrolledID = photos.last
        }
    }
}

#Preview {
    GridView(album: .init(name: "test", date: Date()), photos: [])
}
