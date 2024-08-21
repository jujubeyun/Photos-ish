//
//  GridView.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/9/24.
//

import SwiftUI
import SwiftData

struct GridView: View {
    @Query(sort: [SortDescriptor<Album>(\.date, order: .forward)]) private var albums: [Album]
    @State private var scrolledID: Photo?
    @State private var isAddingPhotos = false
    let isLandscape: Bool
    let album: Album
    let photos: [Photo]
    
    var columnCount: Int {
        isLandscape ? 5 : 3
    }
    
    var body: some View {
        ZStack {
            GridViewSection
            
            if photos.isEmpty {
                emptyView
            }
        }
        .onAppear { scrolledID = photos.last}
        .scrollPosition(id: $scrolledID)
        .navigationDestination(for: Photo.self) { photo in
            PhotoPagingView(album: album, selectedPhoto: photo, photos: photos)
        }
        .toolbar {
            if album.isEditable {
                Button("add Photos", systemImage: "plus") {
                    isAddingPhotos = true
                }
            }
        }
        .sheet(isPresented: $isAddingPhotos) {
            SelectableGridView(isLandscape: isLandscape, isAddingPhotos: $isAddingPhotos, album: album)
        }
    }
    
    private var emptyView: some View {
        let isFavorites = album.id == albums[1].id
        return VStack {
            Text("No Photos")
                .font(.title).bold()
            
            Text(isFavorites ? "You can add photos here by clicking heart button on photos." : "Ciick plus button at the top right to add cat photos.")
                .foregroundStyle(.gray)
        }
        .padding()
        .offset(y: isLandscape ? 0 : -50)
    }
    
    private var GridViewSection: some View {
        ScrollView {
            LazyVGrid(columns: .init(repeating: .init(.flexible(), spacing: 2), count: columnCount), spacing: 2) {
                ForEach(photos, id: \.self) { photo in
                    NavigationLink(value: photo) {
                        RemoteImageView(photo: photo, imageContentMode: .fill, shouldShowFavoriteMark: true, isGrid: true)
                            .aspectRatio(1, contentMode: .fit)
                    }
                }
            }
            .scrollTargetLayout()
        }
    }
}
