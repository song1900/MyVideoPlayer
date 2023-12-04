//
//  PlayerItemObserver.swift
//  MyVideoPlayer
//
//  Created by denver on 2023/12/04.
//

import AVKit
import Combine

public class PlayerItemObserver {
    @Published var status: AVPlayerItem.Status?
    
    private var cancellable: AnyCancellable?
    init(playerItem: AVPlayerItem? = nil) {
        guard let playerItem = playerItem else { return }
        cancellable = playerItem
            .publisher(for: \.status)
            .sink { self.status = $0 }
    }
    
    deinit {
        cancellable?.cancel()
    }
}
