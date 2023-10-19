import AppKit
import AVKit

class WallpaperManager {
    
    static let shared = WallpaperManager()
    
    var screen: NSScreen
    var window: NSWindow
    var player: AVQueuePlayer?
    var playerLooper: AVPlayerLooper?
    var playerView: AVPlayerView?
//    var state: WallpaperState
//    
//    enum WallpaperState: String {
//        case stati = "static"
//        case video = "video"
//    }
    
    private init() {
        screen = NSScreen.main!
        window = NSWindow(contentRect: screen.frame,
                             styleMask: [.borderless, .fullSizeContentView],
                             backing: .buffered,
                               defer: false)
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
        window.isReleasedWhenClosed = false
    }
    
    func setVideo(url: URL) {
        let playerItem = AVPlayerItem(url: url)
        player = AVQueuePlayer(playerItem: playerItem)
        guard let player else {
            print("Cannot find wallpaper at the specified URL.")
            return
        }
        player.isMuted = true
        playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
        
        let firstFrameGenerator = AVAssetImageGenerator(asset: playerItem.asset)
        firstFrameGenerator.appliesPreferredTrackTransform = true
        let time = CMTimeMake(value: 0, timescale: 1)
        var actualTime = CMTimeMake(value: 0, timescale: 0)
        do {
            let imageRef = try firstFrameGenerator.copyCGImage(at: time, actualTime: &actualTime)
            let image = NSImage(cgImage: imageRef, size: .zero)
            
            guard let imageData = image.tiffRepresentation else {
                // handle the error
                return
            }
            
            let fileName = (url.lastPathComponent as NSString).deletingPathExtension + "_static.tiff"
            let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
            try imageData.write(to: fileURL)
            try NSWorkspace.shared.setDesktopImageURL(fileURL, for: screen, options: [:])
        } catch {
            print("Failed to get the first frame.")
        }
        playerView = AVPlayerView(frame: window.frame)
        guard let playerView else {
            return
        }
        playerView.player = player
        playerView.videoGravity = .resizeAspectFill
        playerView.controlsStyle = .none
        
        window.contentView = playerView

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.window.makeKeyAndOrderFront(nil)
            player.play()
        }
        
//        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: playerItem, queue: .main) { _ in
//            player.seek(to: CMTime.zero)
//            player.play()
//        }
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(resumeVid(_:)), name: NSWorkspace.didWakeNotification, object: nil)
    }

    
    
    func setStatic(url: URL) {
        window.close()
//        window = nil
        do {
            try NSWorkspace.shared.setDesktopImageURL(url, for: screen, options: [:])
        } catch {
            print(error)
        }
    }
    
    func stop() {
        window.close()
//        window.orderOut(nil)
    }
    
    @objc private func resumeVid(_ notification: NSNotification) {
        guard let player else {
            return
        }
        player.play()
    }
}
