//
//  VideoPlayerViewModel.swift
//  MyVideoPlayer
//
//  Created by denver on 2023/12/02.
//
import AVKit

final public class VideoPlayerViewModel: ObservableObject {
    enum ContentType {
        case video
        case unknown
    }
  
    @Published var contentURL: String
  
    var canPlay: Bool {
        let type = filterByExtension(url: contentURL)
        return type == .video
    }
  
    public init( contentURL: String) {
        self.contentURL = contentURL
    }
}

// MARK: - Business Logic
extension VideoPlayerViewModel {
    // 동영상 확장자 체크
    private func filterByExtension(url: String) -> ContentType {
        let videoExtensions: [String] = [
            "caf", "ttml", "au", "ts", "mqv", "pls",
            "flac", "dv", "amr", "mp1", "mp3", "ac3",
            "loas", "3gp", "aifc", "m2v", "m2t", "m4b",
            "m2a", "m4r", "aa", "webvtt", "aiff", "m4a",
            "scc", "mp4", "m4p", "mp2", "eac3", "mpa", "vob",
            "scc", "aax", "mpg", "wav", "mov", "itt", "xhe",
            "m3u", "mts", "mod", "vtt", "m4v", "3g2", "sc2",
            "aac", "mp4", "vtt", "m1a", "mp2", "avi", "m3u8",
        ]
        guard let fileExtension = URL(string: url)?.pathExtension.lowercased() else {
            return .unknown
        }

        if videoExtensions.contains(fileExtension) {
            return .video
        } else {
            return .unknown
        }
    }
}
