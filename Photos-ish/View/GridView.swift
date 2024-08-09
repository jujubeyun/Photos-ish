//
//  GridView.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/9/24.
//

import SwiftUI

struct GridView: View {
    @State var images: [CatImage] = []
    @State var isFetching = true
    let columnCount = 3
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ScrollView {
                    LazyVGrid(columns: .init(repeating: .init(.flexible()), count: columnCount), spacing: 2) {
                        ForEach(images, id: \.self) { image in
                            RemoteImageView(urlString: image.url)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width/CGFloat(columnCount),
                                       height: geometry.size.width/CGFloat(columnCount))
                                .clipped()
                        }
                    }
                }
                
                if isFetching {
                    LoadingView()
                }
            }
        }
        .task {
            do {
                images = try await NetworkManager.shared.fetchCatImages()
                isFetching = false
            } catch {
                // TODO: - handle errors
                print(error)
            }
        }
    }
}

#Preview {
    GridView()
}
