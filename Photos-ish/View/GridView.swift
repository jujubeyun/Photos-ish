//
//  GridView.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/9/24.
//

import SwiftUI

struct GridView: View {
    
    @State var scrolledID: Int?
    let album: Album
    let columnCount = 3
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: .init(repeating: .init(.flexible()), count: columnCount), spacing: 2) {
                ForEach(0..<album.photos.count, id: \.self) { i in
                    NavigationLink(value: i) {
                        RemoteImageView(urlString: album.photos[i].url)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width/3,
                                   height: UIScreen.main.bounds.width/3)
                            .clipped()
                    }
                }
            }
        }
        .scrollPosition(id: $scrolledID, anchor: .bottom)
        .navigationDestination(for: Int.self) { i in
            PhotoPagingView(album: album, selectedIndex: i)
        }
        .onAppear {
            scrolledID = album.photos.count-1
        }
    }
}

#Preview {
    GridView(album: .init(name: "test", date: Date()))
}
