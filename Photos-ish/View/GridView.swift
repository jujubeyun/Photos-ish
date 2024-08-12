//
//  GridView.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/9/24.
//

import SwiftUI
import SwiftData

struct GridView: View {
    let photos: [Photo]
    @State var scrolledID: Photo?
    let columnCount = 3
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ScrollView {
                    LazyVGrid(columns: .init(repeating: .init(.flexible()), count: columnCount), spacing: 2) {
                        ForEach(photos, id: \.self) { photo in
                            RemoteImageView(urlString: photo.url)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width/CGFloat(columnCount),
                                       height: geometry.size.width/CGFloat(columnCount))
                                .clipped()
                        }
                    }
                }
                .scrollPosition(id: $scrolledID, anchor: .bottom)
            }
        }
        .onAppear {
            scrolledID = photos.last 
        }
    }
}

#Preview {
    GridView(photos: [])
        .modelContainer(for: [Photo.self])
}
