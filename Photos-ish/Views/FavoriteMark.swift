//
//  FavoriteMark.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/14/24.
//

import SwiftUI

struct FavoriteMark: View {
    
    let size: CGFloat
    
    var body: some View {
        Image(systemName: "heart.fill")
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .foregroundStyle(Color(.white))
            .padding(6)
            .shadow(color: .black, radius: 8)
    }
}

#Preview {
    FavoriteMark(size: 12)
}
