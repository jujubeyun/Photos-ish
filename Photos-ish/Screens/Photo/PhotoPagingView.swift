//
//  PhotoPagingView.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/12/24.
//

import SwiftUI

struct PhotoPagingView: View {
    @Environment(\.modelContext) var context
    @State var index: Int?
    @State var isShowingAlert = false
    let album: Album
    let selectedIndex: Int
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: .init(repeating: .init(.flexible()), count: 1), spacing: 0) {
                ForEach(0..<album.photos.count, id: \.self) { i in
                    RemoteImageView(urlString: album.photos[i].url)
                        .scaledToFit()
                        .containerRelativeFrame(.horizontal)
                }
            }
            .scrollTargetLayout()
        }
        .onAppear { index = selectedIndex }
        .scrollTargetBehavior(.paging)
        .scrollIndicators(.hidden)
        .scrollPosition(id: $index)
        .ignoresSafeArea()
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                let photo = album.photos[safe: index]
                let imageName = photo?.isFavorite ?? false ? "heart.fill" : "heart"
                Button("favorite", systemImage: imageName) {
                    photo?.isFavorite.toggle()
                }
                
                Spacer()
                
                Button("delete", systemImage: "trash") {
                    isShowingAlert = true
                }
            }
        }
        .confirmationDialog("Delete Photo", isPresented: $isShowingAlert) {
            Button("Delete Photo", role: .destructive) {
                guard let index else { return }
                context.delete(album.photos[index])
                album.photos.remove(at: index) // to update ui
            }
        } message: {
            Text("This Photo will be deleted from the library.")
        }
    }
}

#Preview {
    NavigationStack {
        PhotoPagingView(album: Album(name: "test", date: Date()), selectedIndex: 0)
    }
}
