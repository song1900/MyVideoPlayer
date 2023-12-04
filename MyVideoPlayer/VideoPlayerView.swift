//
//  VideoPlayerView.swift
//  MyVideoPlayer
//
//  Created by denver on 2023/12/02.
//
import SwiftUI

public struct VideoPlayerView: View {
    @StateObject private var myVideoPlayerViewModel = MyVideoPlayerViewModel()
  
    public var body: some View {
        MyVideoPlayer(viewModel: myVideoPlayerViewModel)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
            .onReceive(myVideoPlayerViewModel.playerItemObserver.$status, perform: { status in
                switch status {
                case .readyToPlay:
                    print("read to play")
                    myVideoPlayerViewModel.play()
                case .failed:
                    print("failed")
                default:
                    print("default")
                }
            })
            .onReceive(myVideoPlayerViewModel.$pipStatus, perform: { status in
                print(status.rawValue)
            })
            .onAppear {
                myVideoPlayerViewModel.media = Media(url: "https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4")
            }
    }
}

