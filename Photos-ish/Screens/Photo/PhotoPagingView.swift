//
//  PhotoPagingView.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/12/24.
//

import SwiftUI

struct PhotoPagingView: View {
    @Environment(\.modelContext) var context
    @State var scrolledID: Photo?
    @State var isShowingAlert = false
    let album: Album
    let selectedPhoto: Photo
    let photos: [Photo]
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: .init(repeating: .init(.flexible()), count: 1), spacing: 0) {
                ForEach(photos, id: \.self) { photo in
                    VStack {
                        RemoteImageView(urlString: photo.url)
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
                Button("favorite", systemImage: imageName) {
                    scrolledID?.isFavorite.toggle()
                }
                
                Spacer()
                
                Button("delete", systemImage: "trash") {
                    isShowingAlert = true
                }
            }
        }
        .confirmationDialog("Delete Photo", isPresented: $isShowingAlert) {
            Button("Delete Photo", role: .destructive) {
                guard let photo = scrolledID,
                      let photoIndex = album.photos.firstIndex(of: photo) else { return }
                context.delete(album.photos[photoIndex])
                album.photos.remove(at: photoIndex) // to update ui
            }
        } message: {
            Text("This Photo will be deleted from the library.")
        }
    }
}

#Preview {
    NavigationStack {
        PhotoPagingView(album: .init(name: "test", date: .now),
                        selectedPhoto: .init(url: "", date: .now),
                        photos: [])
    }
}
