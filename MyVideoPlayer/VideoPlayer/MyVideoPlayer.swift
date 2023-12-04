//
//  MyVideoPlayer.swift
//  MyVideoPlayer
//
//  Created by denver on 2023/11/29.
//
import AVKit
import SwiftUI

public struct MyVideoPlayer: UIViewControllerRepresentable {
    @ObservedObject var viewModel: MyVideoPlayerViewModel

    /// 영상 재생 관련 컨트롤러 노출 및 동작 여부
    var isDisplayPlaybackControls: Bool
    /// 선형 재생 여부 (선형 재생 시 되감기/넘어가기 동작 불가)
    var isRequireLinearPlayback: Bool
    /// 비디오 화면 리사이징
    var videoGravity: AVLayerVideoGravity
    /// 음소거 여부
    var isMuted: Bool
    /// PIP 재생 모드 허용 여부
    var isAllowPIP: Bool
    /// 화면 회전 지원
    var autorotate: Bool
    /// 화면 모드
    var interfaceMode: InterfaceOrientationMode
    /// 외부 디바이스 재생 연동
    var isAllowExternalPlayback: Bool
  
    public init(
        viewModel: MyVideoPlayerViewModel,
        isDisplayPlaybackControls: Bool = true,
        isRequireLinearPlayback: Bool = true,
        videoGravity: AVLayerVideoGravity = .resizeAspect,
        isMuted: Bool = false,
        isAllowPIP: Bool = true,
        autorotate: Bool = true,
        interfaceMode: InterfaceOrientationMode = .all,
        isAllowExternalPlayback: Bool = false
    ) {
      self.viewModel = viewModel
      self.isDisplayPlaybackControls = isDisplayPlaybackControls
      self.isRequireLinearPlayback = isRequireLinearPlayback
      self.videoGravity = videoGravity
      self.isMuted = isMuted
      self.isAllowPIP = isAllowPIP
      self.autorotate = autorotate
      self.interfaceMode = interfaceMode
      self.isAllowExternalPlayback = isAllowExternalPlayback
  }
  
  public func makeUIViewController(context: Context) -> AVPlayerViewController {
      let controller = CustomAVPlayerViewController(autorotate: autorotate, interfaceMode: interfaceMode)
    
      controller.player = viewModel.player
      controller.delegate = context.coordinator
      controller.showsPlaybackControls = isDisplayPlaybackControls
      controller.requiresLinearPlayback = isRequireLinearPlayback
      controller.videoGravity = videoGravity
      controller.allowsPictureInPicturePlayback = isAllowPIP
      controller.player?.allowsExternalPlayback = isAllowExternalPlayback
      controller.player?.isMuted = isMuted
   
      return controller
  }
  
  public func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
    uiViewController.player = viewModel.player
    uiViewController.allowsPictureInPicturePlayback = isAllowPIP
      uiViewController.player?.isMuted = isMuted
  }
  
  public func makeCoordinator() -> Coordinator {
    return Coordinator(self)
  }
  
  public class Coordinator: NSObject, AVPlayerViewControllerDelegate {
    let parent: MyVideoPlayer
    
    public init(_ parent: MyVideoPlayer) {
      self.parent = parent
    }
    
    public func playerViewControllerWillStartPictureInPicture(_ playerViewController: AVPlayerViewController) {
      parent.viewModel.pipStatus = .willStart
    }
    
    public func playerViewControllerDidStartPictureInPicture(_ playerViewController: AVPlayerViewController) {
      parent.viewModel.pipStatus = .didStart
    }
    
    public func playerViewControllerWillStopPictureInPicture(_ playerViewController: AVPlayerViewController) {
      parent.viewModel.pipStatus = .willStop
    }
    
    public func playerViewControllerDidStopPictureInPicture(_ playerViewController: AVPlayerViewController) {
      parent.viewModel.pipStatus = .didStop
    }
  }
}

// MARK: - 화면 모드
public enum InterfaceOrientationMode {
  case portrait
  case all
}

// MARK: - AVPlayerController
class CustomAVPlayerViewController: AVPlayerViewController {
  var autorotate: Bool
  var interfaceMode: InterfaceOrientationMode
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  init(
    autorotate: Bool = true,
    interfaceMode: InterfaceOrientationMode = .all
  ) {
    self.autorotate = autorotate
    self.interfaceMode = interfaceMode
    
    super.init(nibName: nil, bundle: nil)
  }
  
  // 회전 지원
  override var shouldAutorotate: Bool {
    return autorotate
  }
  
  // 세로, 전체 모드
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return interfaceMode == .portrait ? .portrait : .all
  }
}

