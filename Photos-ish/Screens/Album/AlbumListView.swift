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
            .navigationDestination(for: Album.self) { album in GridView(album: album) }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("", systemImage: "plus") { showAlert(alertType: .add) }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(isEditing ? "Done" : "Edit") { isEditing.toggle() }
                }
            }
            .task {
                if albums[0].photos.isEmpty {
                    do {
                        let catImages = try await NetworkManager.shared.fetchCatImages()
                        addCatImagesToRecents(images: catImages)
                    } catch {
                        print(error)
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
                }
            } message: { alert in Text(alert.message) }
        }
    }
}

extension AlbumListView {
    private func addCatImagesToRecents(images: [CatResponse]) {
        images.forEach {
            let photo = Photo(url: $0.url, date: .now, album: albums[0])
            albums[0].photos.append(photo)
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
}

#Preview {
    var shouldCreateDefaults = false
    return AlbumListView()
        .modelContainer(AlbumContainer.create(shouldCreateDefaults: &shouldCreateDefaults))
}
