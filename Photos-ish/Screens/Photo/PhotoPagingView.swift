//
//  PhotoPagingView.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/12/24.
//

import SwiftUI
import SwiftData

struct PhotoPagingView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: [SortDescriptor<Album>(\.date, order: .forward)]) private var albums: [Album]
    @State private var scrolledID: Photo?
    @State private var isShowingAlert = false
    let album: Album
    let selectedPhoto: Photo
    let photos: [Photo]
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: .init(repeating: .init(.flexible()), count: 1), spacing: 0) {
                ForEach(photos, id: \.self) { photo in
                    VStack {
                        RemoteImageView(photo: photo)
                            .scaledToFit()
                            .containerRelativeFrame(.horizontal)
                    }
                }
            }
            .scrollTargetLayout()
        }
        .onAppear { scrolledID = selectedPhoto }
        .scrollTargetBehavior(.paging)
        .scrollIndicators(.hidden)
        .scrollPosition(id: $scrolledID)
        .ignoresSafeArea()
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                let imageName = scrolledID?.isFavorite ?? false ? "heart.fill" : "heart"
                Button("favorite", systemImage: imageName) { setFavorite() }
                Spacer()
                Button("delete", systemImage: "trash") { isShowingAlert = true }
            }
        }
        .confirmationDialog("Delete Photo", isPresented: $isShowingAlert) {
            Button("Delete Photo", role: .destructive) {
                guard let photo = scrolledID,
                      let photoIndex = album.photos.firstIndex(of: photo) else { return }
                context.delete(album.photos[photoIndex]) // this doesn't update ui
                album.photos.remove(at: photoIndex) // to update ui
            }
        } message: {
            Text("This Photo will be deleted from the library.")
        }
    }
    
    private func setFavorite() {
        guard let photo = scrolledID else { return }
        let favorites = albums[1]
        
        if photo.isFavorite == true {
            if let index = favorites.photos.firstIndex(of: photo) {
                favorites.photos.remove(at: index)
            }
        } else {
            favorites.photos.append(photo)
        }
        
        photo.isFavorite.toggle()
    }
}
