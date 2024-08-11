//
//  AlbumListView.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/9/24.
//

import SwiftUI
import SwiftData

struct AlbumListView: View {
    @Environment(\.modelContext) var context
    @Query(sort: [SortDescriptor<Album>(\.date, order: .forward)]) var albums: [Album]
    @State var isShowingAlert: Bool = false
    @State var titleText = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: .init(repeating: .init(.flexible()), count: 2), spacing: 16) {
                    ForEach(albums) { album in
                        let latestPhoto = album.photos.sorted { $0.date < $1.date }.first
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Thumbnail(urlString: latestPhoto?.url)
                            
                            Spacer(minLength: 4)
                                
                            Text(album.name)
                                .font(.subheadline)
                            Text("\(album.photos.count)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Albums")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("", systemImage: "plus") {
                        isShowingAlert = true
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit") {
                        
                    }
                }
            }
            .task {
                do {
                    try await setup()
                } catch {
                    print(error.localizedDescription)
                }
                
            }
            .alert("New Album", isPresented: $isShowingAlert) {
                TextField("Title", text: $titleText)
                    .font(.footnote)
                Button("Save") { saveAlbum() }
                Button("Cancel", role: .cancel) { titleText = "" }
            } message: {
                Text("Enter a name for this album.")
            }
        }
    }
    
    private func saveAlbum() {
        let newAlbum = Album(name: titleText, timestamp: Date())
        context.insert(newAlbum)
        titleText = ""
    }
    
    private func setup() async throws {
        guard albums.isEmpty else { return }
        let recents = Album(name: "Recents", timestamp: Date())
        let photos = try await fetchPhotos()
        recents.photos = photos
        let favorites = Album(name: "Favorites", timestamp: Date())
        context.insert(recents)
        context.insert(favorites)
    }
    
    private func fetchPhotos() async throws -> [Photo] {
        let images = try await NetworkManager.shared.fetchCatImages()
        let photos = convert(images: images)
        return photos
    }
    
    private func convert(images: [CatImage]) -> [Photo] {
        images.map { Photo(id: $0.id, url: $0.url, date: Date()) }
    }
}

#Preview {
    AlbumListView()
        .modelContainer(for: [Album.self])
}
