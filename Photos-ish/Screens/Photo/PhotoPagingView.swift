//
//  PhotoPagingView.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/12/24.
//

import SwiftUI
import SwiftData

struct PhotoPagingView: View {
    @Environment(\.dismiss) private var dismiss
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
            Button("Delete", role: .destructive) {
                deletePhoto()
            }
        } message: {
            let message = album.isEditable ? "This photo will be removed from the album \"\(album.name)\"" : "This photo will be deleted permanantly."
            Text(message)
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
    
    private func deletePhoto() {
        guard let photo = scrolledID,
              let photoIndex = album.photos.firstIndex(of: photo) else { return }
        if !album.isEditable {
            context.delete(album.photos[photoIndex])
        }
            
        album.photos.remove(at: photoIndex)
        
        if album.photos.isEmpty {
            dismiss()
        }
    }
}
