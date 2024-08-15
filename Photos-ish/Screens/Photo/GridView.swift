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
    @State private var isLandscape: Bool = false
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
            SelectableGridView(isAddingPhotos: $isAddingPhotos, album: album)
        }
        .onRotate { orientation in
            isLandscape = orientation.isLandscape
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
            LazyVGrid(columns: .init(repeating: .init(.flexible(), spacing: 2), count: columnCount), spacing: 2) {
                ForEach(photos, id: \.self) { photo in
                    NavigationLink(value: photo) {
                        RemoteImageView(photo: photo, imageContentMode: .fill, shouldShowFavoriteMark: true)
                            .aspectRatio(1, contentMode: .fit)
                    }
                }
            }
            .scrollTargetLayout()
        }
    }
}
