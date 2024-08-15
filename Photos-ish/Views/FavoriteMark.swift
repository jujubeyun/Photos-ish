//
//  FavoriteMark.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/14/24.
//

import SwiftUI

struct FavoriteMark: View {
    var body: some View {
        Image(systemName: "heart.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 15, height: 15)
            .foregroundStyle(Color(.white))
            .padding(6)
            .shadow(color: .black, radius: 8)
    }
}

#Preview {
    FavoriteMark()
}
