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
    @State var alertType: AlertType?
    @State var titleText = ""
    @State var isEditing = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: .init(repeating: .init(.flexible()), count: 2), spacing: 16) {
                    ForEach(albums) { album in
                        AlbumThumbnailView(alertType: $alertType, 
                                           isShowingAlert: $isShowingAlert,
                                           isEditing: isEditing,
                                           album: album)
                    }
                }
                .padding()
            }
            .navigationTitle("Albums")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("", systemImage: "plus") { showAlert(alertType: .add) }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(isEditing ? "Done" : "Edit") { isEditing.toggle() }
                }
            }
            .task {
                do {
                    try await setup()
                } catch {
                    print(error.localizedDescription)
                }
                
            }
            .alert(alertType?.title ?? "Alert", isPresented: $isShowingAlert, presenting: alertType) { alert in
                switch alert {
                case .add:
                    TextField(alert.title, text: $titleText)
                        .font(.footnote)
                    Button("Save") { saveAlbum() }
                    Button("Cancel", role: .cancel) { titleText = "" }
                case .delete(let album):
                    Button("Delete", role: .destructive) { context.delete(album) }
                    Button("Cancel", role: .cancel) {}
                }
            } message: { alert in Text(alert.message) }
        }
    }
    
    private func showAlert(alertType: AlertType) {
        self.alertType = alertType
        isShowingAlert = true
    }
    
    private func saveAlbum() {
        let newAlbum = Album(name: titleText, date: Date())
        context.insert(newAlbum)
        titleText = ""
    }
    
    private func setup() async throws {
        guard albums.isEmpty else { return }
        let recents = Album(name: "Recents", date: Date(), isEditable: false)
        let photos = try await fetchPhotos()
        recents.photos = photos
        let favorites = Album(name: "Favorites", date: Date(), isEditable: false)
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
