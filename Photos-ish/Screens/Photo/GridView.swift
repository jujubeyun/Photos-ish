//
//  GridView.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/9/24.
//

import SwiftUI
import SwiftData

struct GridView: View {
    @Environment(\.modelContext) var context
    @Query(sort: [SortDescriptor<Album>(\.date, order: .forward)]) var albums: [Album]
    @State var scrolledID: Photo?
    @State var isShowingAlert = false
    @State var selectedPhotos: [Photo] = []
    let album: Album
    let photos: [Photo]
    let columnCount = 3
    let isSelectingPhotos: Bool
    
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
            NavigationStack {
                GridView(album: albums[0], photos: albums[0].sortedPhotos, isSelectingPhotos: true)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Cancel") {
                                isShowingAlert = false
                            }
                        }
                        
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Add") {
                                
                            }
                        }
                    }
            }
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
                    if isSelectingPhotos {
                        let isSelected = selectedPhotos.contains(photo)
                        RemoteImageView(photo: photo)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width/3,
                                   height: UIScreen.main.bounds.width/3)
                            .clipped()
                            .contentShape(Rectangle())
                            .opacity(isSelected ? 0.5 : 1.0)
                            .onTapGesture {
                                if isSelected {
                                    selectedPhotos.removeAll { $0 == photo}
                                } else {
                                    selectedPhotos.append(photo)
                                }
                            }
                            .overlay(alignment: .bottomTrailing) {
                                if isSelected {
                                    SelectionMark()
                                }
                            }
                    } else {
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
            }
            .scrollTargetLayout()
        }
    }
}

#Preview {
    GridView(album: .init(name: "test", date: Date()), photos: [], isSelectingPhotos: false)
}
