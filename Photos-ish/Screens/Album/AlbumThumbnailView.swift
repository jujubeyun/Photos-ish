//
//  AlbumThumbnailView.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/11/24.
//

import SwiftUI
import SwiftData

struct AlbumThumbnailView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: [SortDescriptor<Album>(\.date, order: .forward)]) private var albums: [Album]
    @Binding var alertType: AlertType?
    @Binding var isShowingAlert: Bool
    let isEditing: Bool
    let album: Album
    
    private var lastPhoto: Photo? {
        album.sortedPhotos.last
    }
    
    var body: some View {
        NavigationLink(value: album) {
            VStack(alignment: .leading, spacing: 0) {
                AsyncImage(url: URL(string: lastPhoto?.url ?? "")) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width/2.3,
                                   height: UIScreen.main.bounds.width/2.3)
                            .clipShape(.rect(cornerRadius: 8))
                            .overlay(alignment: .bottomLeading) {
                                let favorites = albums[1]
                                if lastPhoto?.isFavorite ?? false && album.id == favorites.id {
                                    FavoriteMark(size: 15)
                                }
                            }
                    default:
                        placeholder
                    }
                }
                .padding(.bottom, 4)
                    
                Text(album.name)
                    .font(.subheadline)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Text("\(album.photos.count)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .buttonStyle(PlainButtonStyle()) // to prevent changing text color to blue
        .overlay(alignment: .topLeading) {
            if isEditing && album.isEditable { deleteButton }
        }
        .opacity(isEditing && !album.isEditable ? 0.3 : 1)
        .animation(.easeInOut, value: isEditing)
    }
    
    private var placeholder: some View {
        ZStack {
            Color(.quaternarySystemFill)
                .frame(width: UIScreen.main.bounds.width/2.3,
                       height: UIScreen.main.bounds.width/2.3)
                .clipShape(.rect(cornerRadius: 8))
            
            Image(systemName: "photo.on.rectangle")
                .resizable()
                .scaledToFit()
                .frame(width: 50)
                .foregroundStyle(Color(.quaternaryLabel))
        }
    }
    
    private var deleteButton: some View {
        Button {
            alertType = .delete(album: album)
            isShowingAlert = true
        } label: {
            ZStack {
                Circle()
                    .foregroundStyle(.red)
                
                Image(systemName: "minus")
                    .foregroundStyle(.white)
                    .imageScale(.small)
            }
            .frame(width: 20)
            .offset(x: -10, y: -10)
        }
    }
}
