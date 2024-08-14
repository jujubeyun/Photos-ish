//
//  SelectableGridView.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/14/24.
//

import SwiftUI
import SwiftData

struct SelectableGridView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: [SortDescriptor<Photo>(\.date, order: .forward)]) private var photos: [Photo]
    @State private var selectedPhotos: [Photo] = []
    @Binding var isAddingPhotos: Bool
    let album: Album
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: .init(repeating: .init(.flexible()), count: 3), spacing: 2) {
                    ForEach(photos, id: \.self) { photo in
                        selectableGrid(selectedPhotos: $selectedPhotos,
                                       photo: photo, 
                                       isSelected: selectedPhotos.contains(photo))
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        isAddingPhotos = false
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        selectedPhotos.forEach { photo in
                            album.photos.append(photo)
                        }
                        
                        isAddingPhotos = false
                    }
                }
            }
        }
    }
}

struct selectableGrid: View {
    
    @Binding var selectedPhotos: [Photo]
    let photo: Photo
    let isSelected: Bool
    
    var body: some View {
        RemoteImageView(photo: photo)
            .aspectRatio(contentMode: .fill)
            .frame(width: UIScreen.main.bounds.width/3,
                   height: UIScreen.main.bounds.width/3)
            .clipped()
            .contentShape(Rectangle())
            .opacity(isSelected ? 0.5 : 1.0)
            .onTapGesture {
                if isSelected {
                    selectedPhotos.removeAll { $0 == photo }
                } else {
                    selectedPhotos.append(photo)
                }
            }
            .overlay(alignment: .bottomTrailing) {
                if isSelected {
                    SelectionMark()
                }
            }
    }
}
