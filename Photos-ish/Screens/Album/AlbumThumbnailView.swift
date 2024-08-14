//
//  AlbumThumbnailView.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/11/24.
//

import SwiftUI

struct AlbumThumbnailView: View {
    
    @Binding var alertType: AlertType?
    @Binding var isShowingAlert: Bool
    let isEditing: Bool
    let album: Album
    
    var lastPhotoURLString: String? {
        album.sortedPhotos.last?.url
    }
    
    var body: some View {
        NavigationLink(value: album) {
            VStack(alignment: .leading, spacing: 0) {
                AsyncImage(url: URL(string: lastPhotoURLString ?? "")) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width/2.3,
                                   height: UIScreen.main.bounds.width/2.3)
                            .clipShape(.rect(cornerRadius: 8))
                    default:
                        placeholder
                    }
                }
                
                Spacer()
                    
                Text(album.name)
                    .font(.subheadline)
                Text("\(album.photos.count)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .overlay(alignment: .topLeading) {
            if isEditing && album.isEditable { deleteButton }
        }
        .opacity(isEditing && !album.isEditable ? 0.3 : 1)
        .animation(.easeInOut, value: isEditing)
    }
    
    var placeholder: some View {
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
    
    var deleteButton: some View {
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

#Preview {
    AlbumThumbnailView(alertType: .constant(.add), 
                       isShowingAlert: .constant(false),
                       isEditing: true,
                       album: Album(name: "Test", date: Date(),isEditable: true))
}
