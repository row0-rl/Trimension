//
//  DynamicWallpaperView.swift
//  Trimension
//
//  Created by Shiyuan Liu on 1/12/23.
//

//import SwiftUI
import AppKit
import AVKit

class DynamicWallpaperView: NSObject, NSWindowDelegate {
    var window: NSWindow!
    var playerView: AVPlayerView!
    var playerItem: AVPlayerItem!
    var player: AVPlayer!

    override init() {
        super.init()
        createWindow()
    }

    func createWindow() {
        // Create the window
        window = NSWindow(contentRect: NSScreen.main!.frame,
                          styleMask: [.borderless, .fullSizeContentView],
                          backing: .buffered,
                          defer: false)

        // Set the window level to be the background
        window.level = .init(Int(CGWindowLevelForKey(CGWindowLevelKey.desktopWindow)))
        window.ignoresMouseEvents = true
        window.isMovableByWindowBackground = false
        window.collectionBehavior = [
            .canJoinAllSpaces,
            .stationary,
            .fullScreenPrimary,
            .ignoresCycle
        ]
        window.backgroundColor = .clear
        window.hasShadow = false

        // Create the player view
        playerView = AVPlayerView(frame: window.contentView!.frame)
//        window.contentView!.addSubview(playerView)
        window.contentView = playerView
//        window.contentView?.layer = playerLayer
        window.delegate = self

        // Create the player
        let url = Bundle.main.url(forResource: "video2", withExtension: "mp4")
        guard let url else {
            print("Cannot find target wallpaper file.")
            return
        }
        playerItem = AVPlayerItem(url: url)
//        playerItem = AVPlayerItem(url: URL(fileURLWithPath: "/Users/row0/Desktop/DynamicWallpapers/iPlaySoft.com_10-blade-runne.mp4"))
//        print(playerItem.asset.isPlayable)
        player = AVPlayer(playerItem: playerItem)
        player.isMuted = true
        playerView.player = player
        playerView.videoGravity = .resizeAspectFill

        let firstFrameGenerator = AVAssetImageGenerator(asset: self.playerItem.asset)
        firstFrameGenerator.appliesPreferredTrackTransform = true
        var time = CMTimeMake(value: 0, timescale: 1)
        var actualTime = CMTimeMake(value: 0, timescale: 0)
        do {
            print("Current thread: \(Thread.current)")

            let imageRef = try firstFrameGenerator.copyCGImage(at: time, actualTime: &actualTime)
            let image = NSImage(cgImage: imageRef, size: .zero) 
            
            guard let imageData = image.tiffRepresentation else {
                // handle the error
                return
            }
            
            let fileName = "static.tiff"
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent(fileName)
            
            do {
                try imageData.write(to: fileURL)
                // use the fileURL
                try NSWorkspace.shared.setDesktopImageURL(fileURL, for: NSScreen.main!, options: [:])
                
            } catch {
                // handle the error
            }
            
            //            NSWorkspace.shared.set
        } catch {
            print("Failed to get the first frame.")
        }


        

        
        // Show the window
        window.makeKeyAndOrderFront(nil)
        player.play()
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: playerItem, queue: .main) { _ in
            self.player.seek(to: CMTime.zero)
            self.player.play()
        }
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(resumeVid(_:)), name: NSWorkspace.didWakeNotification, object: nil)
        
    }
    
    @objc private func resumeVid(_ notification: NSNotification) {
        self.player.play()
    }
}
