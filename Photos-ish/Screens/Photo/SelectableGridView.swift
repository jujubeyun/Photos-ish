//
//  SelectableGridView.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/14/24.
//

import SwiftUI
import SwiftData

struct SelectableGridView: View {
    @Environment(\.modelContext) var context
    @Query(sort: [SortDescriptor<Photo>(\.date, order: .forward)]) var photos: [Photo]
    @Binding var isShowingAlert: Bool
    @State var selectedPhotos: [Photo] = []
    let album: Album
    let columnCount = 3
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: .init(repeating: .init(.flexible()), count: columnCount), spacing: 2) {
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
                        isShowingAlert = false
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        selectedPhotos.forEach { photo in
                            album.photos.append(photo)
                        }
                        
                        isShowingAlert = false
                    }
                }
            }
        }
    }
}

#Preview {
    SelectableGridView(isShowingAlert: .constant(true),
                      album: .init(name: "test", date: .now))
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
