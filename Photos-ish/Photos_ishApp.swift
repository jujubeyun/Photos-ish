//
//  Photos_ishApp.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/9/24.
//

import SwiftUI
import SwiftData

@main
struct Photos_ishApp: App {
    @AppStorage("isFirstTimeLaunch") private var isFirstTimeLaunch: Bool = true
    
    var body: some Scene {
        WindowGroup {
            AlbumListView()
                .modelContainer(AlbumContainer.create(shouldCreateDefaults: &isFirstTimeLaunch))
        }
    }
}
