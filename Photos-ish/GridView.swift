//
//  GridView.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/9/24.
//

import SwiftUI

struct GridView: View {
    let columns: [GridItem] = .init(repeating: .init(.flexible() ,spacing: 2), count: 3)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(0..<30) { i in
                    Color(.blue)
                        .scaledToFit()
                }
            }
        }
    }
}

#Preview {
    GridView()
}
