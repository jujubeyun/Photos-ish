//
//  SelectionMark.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/14/24.
//

import SwiftUI

struct SelectionMark: View {
    var body: some View {
        Image(systemName: "checkmark.circle")
            .resizable()
            .scaledToFit()
            .foregroundStyle(.white)
            .background {
                Circle()
                    .foregroundStyle(.blue)
            }
            .frame(width: 20)
            .padding(6)
    }
}

#Preview {
    SelectionMark()
}
