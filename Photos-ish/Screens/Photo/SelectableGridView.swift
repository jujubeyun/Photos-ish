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
    @State private var isLandscape: Bool = false
    @Binding var isAddingPhotos: Bool
    let album: Album
    
    var columnCount: Int {
        isLandscape ? 5 : 3
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: .init(repeating: .init(.flexible(), spacing: 2), count: columnCount), spacing: 2) {
                    ForEach(photos, id: \.self) { photo in
                        let isSelected = selectedPhotos.contains(photo)
                        RemoteImageView(photo: photo, imageContentMode: .fill, shouldShowFavoriteMark: true, isGrid: true)
                            .contentShape(Rectangle())
                            .aspectRatio(1, contentMode: .fit)
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
            .onRotate { orientation in
                isLandscape = orientation.isLandscape
            }
        }
    }
}
