//
//  AlbumThumbnailView.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/11/24.
//

import SwiftUI

struct AlbumThumbnailView: View {
    
    let album: Album
    
    var body: some View {
        let latestPhoto = album.photos.sorted { $0.date < $1.date }.first
        
        VStack(alignment: .leading, spacing: 0) {
            if let urlString = latestPhoto?.url {
                RemoteImageView(urlString: urlString)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width/2.3,
                           height: UIScreen.main.bounds.width/2.3)
                    .clipShape(.rect(cornerRadius: 8))
            } else {
                placeholder
            }
            
            Spacer(minLength: 4)
                
            Text(album.name)
                .font(.subheadline)
            Text("\(album.photos.count)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
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
}

#Preview {
    AlbumThumbnailView(album: Album(name: "Test", timestamp: Date()))
}
