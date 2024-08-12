//
//  PhotoPagingView.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/12/24.
//

import SwiftUI

struct PhotoPagingView: View {
    
    @State var index: Int?
    let photos: [Photo]
    let selectedIndex: Int
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: .init(repeating: .init(.flexible()), count: 1), spacing: 0) {
                ForEach(0..<photos.count, id: \.self) { i in
                    RemoteImageView(urlString: photos[i].url)
                        .scaledToFit()
                        .containerRelativeFrame(.horizontal)
                }
            }
        }
        .onAppear { index = selectedIndex }
        .scrollTargetBehavior(.paging)
        .scrollIndicators(.hidden)
        .scrollPosition(id: $index, anchor: .center)
        .ignoresSafeArea()
    }
}

#Preview {
    PhotoPagingView(photos: Photo.samples, selectedIndex: 0)
}
