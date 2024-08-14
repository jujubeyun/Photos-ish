//
//  GridView.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/9/24.
//

import SwiftUI

struct GridView: View {
    
    @State var scrolledID: Photo?
    @State var isShowingAlert = false
    let album: Album
    let photos: [Photo]
    let columnCount = 3
    
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
                    isShowingAlert = true
                }
            }
        }
        .sheet(isPresented: $isShowingAlert) {
            SelectableGridView(isShowingAlert: $isShowingAlert, album: album)
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
    }
}

#Preview {
    GridView(album: .init(name: "test", date: Date()), photos: [])
}
