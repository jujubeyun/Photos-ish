//
//  AlbumListView.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/9/24.
//

import SwiftUI
import SwiftData

struct AlbumListView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: [SortDescriptor<Album>(\.date, order: .forward)]) private var albums: [Album]
    @State private var isShowingAlert: Bool = false
    @State private var alertType: AlertType?
    @State private var titleText = ""
    @State private var isEditing = false
    @State private var isLandscape: Bool = false
    
    var columnCount: Int {
        isLandscape ? 4 : 2
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    LazyVGrid(columns: .init(repeating: .init(.flexible(), spacing: 16), count: columnCount), spacing: 16) {
                        ForEach(albums, id: \.self) { album in
                            AlbumThumbnailView(alertType: $alertType,
                                               isShowingAlert: $isShowingAlert,
                                               isEditing: isEditing,
                                               album: album)
                            .contentShape(Rectangle())
                            .aspectRatio(0.8, contentMode: .fill)
                        }
                    }
                    .padding()
                }
                
                if albums.isEmpty {
                    LoadingView()
                }
            }
            .navigationTitle("Albums")
            .navigationDestination(for: Album.self) { album in
                GridView(album: album, photos: album.sortedPhotos)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Add", systemImage: "plus") { showAlert(alertType: .add) }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(isEditing ? "Done" : "Edit") { isEditing.toggle() }
                }
            }
            .task {
                if albums.isEmpty {
                    do {
                        let catImages = try await NetworkManager.shared.fetchCatImages()
                        preload(images: catImages)
                    } catch {
                        handle(error: error)
                    }
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
                case .invalidURL, .invalidResponse, .invalidData, .unknown:
                    Button("OK") {}
                }
            } message: { alert in
                Text(alert.message)
            }
            .onRotate { orientation in
                isLandscape = orientation.isLandscape
            }
        }
    }
}

extension AlbumListView {
    private func preload(images: [CatResponse]) {
        let recents = Album(name: "Recents", date: Date(), isEditable: false)
        let favorites = Album(name: "Favorites", date: Date(), isEditable: false)
        context.insert(recents)
        context.insert(favorites)
        
        images.forEach {
            let photo = Photo(url: $0.url, date: .now)
            context.insert(photo)
            recents.photos.append(photo)
        }
    }
    
    private func showAlert(alertType: AlertType) {
        self.alertType = alertType
        isShowingAlert = true
    }
    
    private func saveAlbum() {
        guard !titleText.isEmpty else { return }
        let newAlbum = Album(name: titleText, date: Date())
        context.insert(newAlbum)
        titleText = ""
    }
    
    private func handle(error: Error) {
        if let error = error as? NetworkError {
            switch error {
            case .invalidURL:
                showAlert(alertType: .invalidURL)
            case .invalidResponse:
                showAlert(alertType: .invalidResponse)
            case .invalidData:
                showAlert(alertType: .invalidData)
            }
        } else {
            showAlert(alertType: .unknown)
        }
    }
}

#Preview {
    AlbumListView()
        .modelContainer(for: Album.self)
}
