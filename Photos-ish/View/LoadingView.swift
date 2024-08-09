//
//  LoadingView.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/9/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .padding(.bottom, 30)
                .controlSize(.extraLarge)
            
            Text("Fetching cat images from server..")
        }
    }
}

#Preview {
    LoadingView()
}
