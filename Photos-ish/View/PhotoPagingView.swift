//
//  PhotoPagingView.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/12/24.
//

import SwiftUI

struct PhotoPagingView: View {
    
    let photos: [Photo]
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: .init(repeating: .init(.flexible()), count: 1), spacing: 0) {
                ForEach(photos) { photo in
                    RemoteImageView(urlString: photo.url)
                        .scaledToFit()
                        .containerRelativeFrame(.horizontal)
                }
            }
        }
        .scrollTargetBehavior(.paging)
        .scrollIndicators(.hidden)
    }
}

#Preview {
    PhotoPagingView(photos: Photo.samples)
}
