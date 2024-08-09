//
//  AlbumListView.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/9/24.
//

import SwiftUI

struct AlbumListView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: .init(repeating: .init(.flexible()), count: 2), spacing: 16) {
                    ForEach(0..<2) { i in
                        VStack(alignment: .leading, spacing: 0) {
                            placeholder
                            
                            Spacer(minLength: 4)
                                
                            Text(i == 0 ? "Recents" : "Favorites")
                            Text(i == 0 ? "30" : "5")
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
                        
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit") {
                        
                    }
                }
            }
        }
    }
    
    var placeholder: some View {
        ZStack {
            Color(.quaternarySystemFill)
                .imageScale(.large)
                .frame(width: UIScreen.main.bounds.width/2.3,
                       height: UIScreen.main.bounds.width/2.3)
                .clipShape(.rect(cornerRadius: 8))
            
            Image(systemName: "photo.on.rectangle")
                .resizable()
                .scaledToFit()
                .frame(width: 50)
                .foregroundStyle(Color(.quaternaryLabel))
        }
    }
}

#Preview {
    AlbumListView()
}
