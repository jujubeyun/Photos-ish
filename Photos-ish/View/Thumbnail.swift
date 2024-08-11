//
//  Thumbnail.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/11/24.
//

import SwiftUI

struct Thumbnail: View {
    
    let urlString: String?
    
    var body: some View {
        if let urlString {
            RemoteImageView(urlString: urlString)
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width/2.3,
                       height: UIScreen.main.bounds.width/2.3)
                .clipShape(.rect(cornerRadius: 8))
        } else {
            placeholder
        }
            
    }
    
    var placeholder: some View {
        ZStack {
            Color(.quaternarySystemFill)
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
    Thumbnail(urlString: "")
}
