//
//  PhotoPagingView.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/12/24.
//

import SwiftUI

struct PhotoPagingView: View {
    
    @State var index: Int?
    let photos: [Photo]
    let selectedIndex: Int
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: .init(repeating: .init(.flexible()), count: 1), spacing: 0) {
                ForEach(0..<photos.count, id: \.self) { i in
                    RemoteImageView(urlString: photos[i].url)
                        .scaledToFit()
                        .containerRelativeFrame(.horizontal)
                }
            }
            .scrollTargetLayout()
        }
        .onAppear { index = selectedIndex }
        .scrollTargetBehavior(.paging)
        .scrollIndicators(.hidden)
        .scrollPosition(id: $index)
        .ignoresSafeArea()
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                let selectedPhoto = photos[index ?? 0]
                let imageName = selectedPhoto.isFavorite ? "heart.fill" : "heart"
                Button("favorite", systemImage: imageName) {
                    selectedPhoto.isFavorite.toggle()
                }
                
                Spacer()
                
                Button("delete", systemImage: "trash") {
                    
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        PhotoPagingView(photos: Photo.samples, selectedIndex: 0)
    }
}
