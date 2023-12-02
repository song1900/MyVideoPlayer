//
//  MyVideoPlayerApp.swift
//  MyVideoPlayer
//
//  Created by denver on 2023/11/29.
//

import SwiftUI

@main
struct MyVideoPlayerApp: App {
    var body: some Scene {
        WindowGroup {
            VideoPlayerView(viewModel: .init(contentURL: "https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4"))
        }
    }
}
