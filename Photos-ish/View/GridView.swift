//
//  GridView.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/9/24.
//

import SwiftUI

struct GridView: View {
    let photos: [Photo]
    @State var scrolledID: Int?
    let columnCount = 3
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ScrollView {
                    LazyVGrid(columns: .init(repeating: .init(.flexible()), count: columnCount), spacing: 2) {
                        ForEach(0..<photos.count, id: \.self) { i in
                            NavigationLink(value: i) {
                                RemoteImageView(urlString: photos[i].url)
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: geometry.size.width/CGFloat(columnCount),
                                           height: geometry.size.width/CGFloat(columnCount))
                                    .clipped()
                            }
                        }
                    }
                }
                .scrollPosition(id: $scrolledID, anchor: .bottom)
            }
        }
        .navigationDestination(for: Int.self) { i in
            PhotoPagingView(photos: photos, selectedIndex: i)
        }
        .onAppear {
            scrolledID = photos.count-1
        }
    }
}

#Preview {
    GridView(photos: Photo.samples)
}
