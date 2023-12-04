//
//  MyVideoPlayerViewModel.swift
//  MyVideoPlayer
//
//  Created by denver on 2023/11/29.
//
import AVKit
import Combine

final public class MyVideoPlayerViewModel: ObservableObject {
    @Published var pipStatus: PipStatus = .unowned
    @Published var media: Media?

    let player = AVPlayer()
    private var cancellable: AnyCancellable?
  
    public init() {
        setAudioSessionCategory(value: .playback)
        
        // 앱에서 오디오를 재생할 때 다른 앱의 오디오를 일시 정지
        setAudioSessionActive(value: false, option: .notifyOthersOnDeactivation)
        
        cancellable = $media
          .compactMap({ $0 })
          .compactMap({ URL(string: $0.url) })
          .sink(receiveValue: { [weak self] in
              guard let self = self else { return }
              self.player.replaceCurrentItem(with: AVPlayerItem(url: $0))
          })
  }
  
    // 영상 재생
    func play() {
        player.play()
    }
  
    // 영상 정지
    func pause() {
        player.pause()
    }

    // 영상 음소거
    func mute(_ isMuted: Bool) {
        player.isMuted = isMuted
    }
    
    
  
    func setAudioSessionCategory(value: AVAudioSession.Category) {
        /*
         - ambient: 소리 재생이 주요기능이 아닌 앱을 위한 Category. 즉, 이 Category가 적용된 앱은 소리가 꺼진 상태에서도 성공적으로 동작합니다.
         - multiRoute: 개별 오디오 데이터 스트림을 서로 다른 출력 장치로 동시에 라우팅 시키기 위한 Category.
         - playAndRecord: 오디오 녹음(입력)및 재생(출력)을 위한 Category. VoIP (Voice over Internet Protocol) 앱 같은 곳에 쓰입니다.
         - playback: 사용하는데 있어서 녹음된 음악이나 소리 재생이 중요한 앱에 사용되는 Category.
         - record: 오디오 녹음을 위한 Category. 이 Category는 playback 오디오를 음소거시킵니다.
         - soloAmbient: 기본 audio session category.
         */
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(value)
        } catch {
            print("setting category error: \(error.localizedDescription)")
        }
    }
    
    func setAudioSessionActive(value: Bool, option: AVAudioSession.SetActiveOptions) {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(value, options: option)
        } catch {
            print("setting active error: \(error.localizedDescription)")
        }
    }

    
}

