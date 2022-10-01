//
//  MusicController.swift
//  DriverCompanion
//
//  Created by Derik Malcolm on 9/25/22.
//

import Foundation
import MediaPlayer

class MusicController: ObservableObject {
    let player = MPMusicPlayerController.systemMusicPlayer
    let nowPlayingItemChangedNotificationPublisher = NotificationCenter.default.publisher(for: .MPMusicPlayerControllerNowPlayingItemDidChange)
    let playBackStateNotificationPublisher = NotificationCenter.default.publisher(for: .MPMusicPlayerControllerPlaybackStateDidChange)
    
    @Published var currentItem: MPMediaItem?
    @Published var playbackState: MPMusicPlaybackState?
    @Published var playbackTime: TimeInterval = 0
    
    init() {
        player.beginGeneratingPlaybackNotifications()
        getPlaybackState()
        
        MPMediaLibrary.requestAuthorization { status in
            if status == .authorized {
                DispatchQueue.main.async {
                    self.getNowPlayingInfo()
                }
            }
        }
    }
    
    func getNowPlayingInfo() {
        self.currentItem = player.nowPlayingItem
    }
    
    func getPlaybackState() {
        self.playbackState = player.playbackState
    }
    
    func getPlaybackTime() {
        self.playbackTime = player.currentPlaybackTime
    }
    
    func playOrPause() {
        switch playbackState {
        case .stopped, .paused, .interrupted, .none:
            player.play()
        case .playing, .seekingForward, .seekingBackward:
            player.pause()
        @unknown default:
            break
        }
    }
    
    func seekBackwards() {
        player.beginSeekingBackward()
    }
    
    func seekForwards() {
        player.beginSeekingForward()
    }
    
    func previousTrackOrSkiptoBeginning() {
        if player.currentPlaybackTime < 10 {
            player.skipToPreviousItem()
        } else {
            player.skipToBeginning()
        }
    }
    
    
    func nextTrack() {
        player.skipToNextItem()
    }
}
