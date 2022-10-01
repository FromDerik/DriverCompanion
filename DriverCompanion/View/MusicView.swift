//
//  MusicView.swift
//  DriverCompanion
//
//  Created by Derik Malcolm on 9/24/22.
//

import SwiftUI
import UIKit
import MediaPlayer

struct MusicView: View {
    @StateObject var musicController = MusicController()
    @Binding var isOpen: Bool
    @State private var isPlaying = false
    @State private var showingQueue = true
    
    @State private var progressViewPressed = false
    @GestureState private var progressViewDragTranslation: CGFloat = 0
    
    @Namespace private var animation
    
    var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .edgesIgnoringSafeArea([.leading, .bottom, .trailing])
                .frame(maxWidth: .infinity, maxHeight: isOpen ? .infinity : 64)
                .shadow(radius: 10)
            
            if isOpen {
                expandedView
            } else {
                minimizedView
            }
        }
        .onReceive(musicController.nowPlayingItemChangedNotificationPublisher) { _ in
            musicController.getNowPlayingInfo()
        }
        .onReceive(musicController.playBackStateNotificationPublisher) { _ in
            musicController.getPlaybackState()
        }
        .onReceive(timer) { _ in
            musicController.getPlaybackTime()
        }
        .onChange(of: musicController.playbackState) { newValue in
            // left off here. This isn't detected to initiate album art cover growth
            withAnimation(.spring()) {
                isPlaying = newValue == .playing
            }
        }
        .onTapGesture {
            withAnimation(.spring()) {
                isOpen.toggle()
            }
        }
    }
    
    var minimizedView: some View {
        HStack {
            Image(uiImage: (musicController.currentItem?.artwork?.image(at: .init(width: 48, height: 48))) ?? UIImage(named: "album")!)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 48, height: 48)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .clipped()
                .padding(.vertical, 8)
                .padding(.leading)
                .matchedGeometryEffect(id: "artwork", in: animation)
            
            VStack(alignment: .leading) {
                Text(musicController.currentItem?.title ?? "Song Title")
                    .lineLimit(1)
                    .matchedGeometryEffect(id: "title", in: animation)
            }
            .font(.title3)
            
            Spacer()
            
            playbackControls
        }
        .padding(.trailing)
    }
    
    var expandedView: some View {
        VStack(alignment: .center) {
//            if !showingQueue {
                Spacer()
                
                Image(uiImage: (musicController.currentItem?.artwork?.image(at: .init(width: Double.infinity, height: Double.infinity))) ?? UIImage(named: "album")!)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .clipped()
                    .scaleEffect(isPlaying ? 1.1 : 0.8)
                    .shadow(radius: isPlaying ? 20 : 0)
                    .matchedGeometryEffect(id: "artwork", in: animation)
                
                Spacer()
//            }
            
            HStack {
//                if showingQueue {
//                    Image(uiImage: (musicController.currentItem?.artwork?.image(at: .init(width: Double.infinity, height: Double.infinity))) ?? UIImage(named: "album")!)
//                        .renderingMode(.original)
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                        .clipped()
//                        .frame(width: 48, height: 48)
//                        .matchedGeometryEffect(id: "artwork", in: animation)
//                }
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(musicController.currentItem?.title ?? "Song Title")
                            .fontWeight(.semibold)
                            .lineLimit(1)
                        
                        if let isExplicit = musicController.currentItem?.isExplicitItem, isExplicit == true {
                            Image(systemName: "e.square.fill")
                        }
                    }
                    .matchedGeometryEffect(id: "title", in: animation)
                    
                    Text(musicController.currentItem?.artist ?? "Artist")
                        .foregroundColor(.secondary)
                        .matchedGeometryEffect(id: "artist", in: animation)
                }
                .font(.title2)
                .padding(.vertical)
                
                Spacer()
            }
            
//            if showingQueue {
//                List {
//                    Section {
//                        ForEach(0..<25) { _ in
//                            HStack {
//                                Image(uiImage: (musicController.currentItem?.artwork?.image(at: .init(width: Double.infinity, height: Double.infinity))) ?? UIImage(named: "album")!)
//                                    .renderingMode(.original)
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                                    .clipped()
//                                    .frame(width: 48, height: 48)
//
//                                VStack {
//                                    Text(musicController.currentItem?.title ?? "Song Title")
//                                    Text(musicController.currentItem?.artist ?? "Artist")
//                                }
//                            }
//                        }
//                    } header: {
//                        HStack {
//                            Text("Playing Next")
//                                .fontWeight(.semibold)
//
//                            Spacer()
//
//                            Button {
//
//                            } label: {
//                                Image("shuffle.square.fill")
//                            }
//
//                            Button {
//
//                            } label: {
//                                Image("repeat.square.fill")
//                            }
//
//                            Button {
//
//                            } label: {
//                                Image("infinity.square.fill")
//                            }
//
//                        }
//                        .padding()
//                        .foregroundColor(.primary)
//
//                    }
//                    .listRowBackground(Color.clear)
//                }
//                .listStyle(.plain)
//                .scrollContentBackground(.hidden)
//            }
            
            progressView
            
            playbackControls
            
            HStack {
                Button {
                    withAnimation(.spring()) {
                        self.showingQueue.toggle()
                    }
                } label: {
                    if showingQueue {
                        Image("list.bullet.square.fill")
                            .imageScale(.large)
                            .font(.title3)
                    } else {
                        Image(systemName: "list.bullet")
                            .imageScale(.large)
                            .font(.title3)
                    }
                }
                .frame(width: 28, height: 28)
                .foregroundColor(.secondary)

            }
            
            Spacer()
        }
        .padding(.horizontal, 32)
    }
    
    var progressView: some View {
        let longPressGesture = LongPressGesture(minimumDuration: 0.01)
            .onChanged { value in
                withAnimation(.spring()) {
                    progressViewPressed.toggle()
                }
            }
        let dragGesture = DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .updating($progressViewDragTranslation, body: { value, state, _ in
                withAnimation(.spring()) {
                    state = value.translation.width
                }
            })
            .onEnded { value in
                withAnimation(.spring()) {
                    progressViewPressed.toggle()
                }
            }
        
        let combined = longPressGesture.sequenced(before: dragGesture)
        
        return VStack {
            ProgressView(value: musicController.playbackTime, total: musicController.currentItem?.playbackDuration ?? 1000)
                .progressViewStyle(CustomProgressViewStyle(pressed: $progressViewPressed, translation: progressViewDragTranslation))
            
            HStack {
                Text(currentDurationString(for: musicController.playbackTime))
                    .foregroundColor(progressViewPressed ? .primary : .secondary)
                Spacer()
                Text("-" + remainingDurationString(for: (musicController.currentItem?.playbackDuration ?? 0) - musicController.playbackTime))
                    .foregroundColor(progressViewPressed ? .primary : .secondary)
            }
        }
        .scaleEffect(progressViewPressed ? 1.1 : 1)
        .gesture(combined)
    }
    
    var playbackControls: some View {
        HStack {
            if isOpen {
                Button {
                    musicController.previousTrackOrSkiptoBeginning()
                } label: {
                    Image(systemName: "backward.fill")
                        .font(isOpen ? .system(size: 36) : .system(size: 20))
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.primary)
                        .padding(isOpen ? 8 : 4)
                }
                .buttonStyle(CustomButtonStyle())
            }
            
            if isOpen {
                Spacer()
            }
            
            Button {
                musicController.playOrPause()
            } label: {
                Image(systemName: playbackImageName)
                    .font(isOpen ? .system(size: 40) : .system(size: 20))
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.primary)
                    .padding(isOpen ? 8 : 4)
            }
            .buttonStyle(CustomButtonStyle())
            .matchedGeometryEffect(id: "playButton", in: animation)
            
            if isOpen {
                Spacer()
            }
            
            Button {
                musicController.nextTrack()
            } label: {
                Image(systemName: "forward.fill")
                    .font(isOpen ? .system(size: 36) : .system(size: 20))
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.primary)
                    .padding(isOpen ? 8 : 4)
            }
            .buttonStyle(CustomButtonStyle())
            .matchedGeometryEffect(id: "nextButton", in: animation)
        }
        .matchedGeometryEffect(id: "playbackControls", in: animation)
    }
    
    var playbackImageName: String {
        switch musicController.playbackState {
        case .stopped, .paused, .interrupted, .none:
            return "play.fill"
        case .playing, .seekingForward, .seekingBackward:
            return "pause.fill"
        @unknown default:
            return "play.fill"
        }
    }
    
    var formatter: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }
    
    func currentDurationString(for duration: TimeInterval?) -> String {
        return formatter.string(from: duration ?? 0)!
            .replacingOccurrences(of: #"^00[:.]0?|^0"#, with: "", options: .regularExpression)
    }
    
    func remainingDurationString(for duration: TimeInterval) -> String {
        return formatter.string(from: .now, to: .now.addingTimeInterval(duration))!
            .replacingOccurrences(of: #"^00[:.]0?|^0"#, with: "", options: .regularExpression)
    }
}

struct MusicView_Previews: PreviewProvider {
    static var previews: some View {
        MusicView(isOpen: .constant(true))
    }
}
