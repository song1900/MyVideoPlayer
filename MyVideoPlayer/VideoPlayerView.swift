//
//  VideoPlayerView.swift
//  MyVideoPlayer
//
//  Created by denver on 2023/12/02.
//
import SwiftUI

public struct VideoPlayerView: View {
    @StateObject var viewModel: VideoPlayerViewModel
    @StateObject private var myVideoPlayerViewModel = MyVideoPlayerViewModel()
  
    public var body: some View {
        GreenVideoPlayer(viewModel: myVideoPlayerViewModel)
            .onAppear {
                myVideoPlayerViewModel.media = Media(
                    url: viewModel.contentURL
                )
            }
    }
}

