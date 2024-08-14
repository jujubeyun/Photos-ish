//
//  GridView.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/9/24.
//

import SwiftUI

struct GridView: View {
    
    @State private var scrolledID: Photo?
    @State private var isAddingPhotos = false
    let album: Album
    let photos: [Photo]
    
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
            SelectableGridView(isAddingPhotos: $isAddingPhotos, album: album)
        }
    }
    
    private var emptyView: some View {
        VStack {
            Text("No Photos")
                .font(.title).bold()
            
            Text("Ciick plus sign at the top right to add cat photos.")
                .foregroundStyle(.gray)
        }
        .padding()
        .offset(y: -50)
    }
    
    private var GridViewSection: some View {
        ScrollView {
            LazyVGrid(columns: .init(repeating: .init(.flexible()), count: 3), spacing: 2) {
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
    }
}
