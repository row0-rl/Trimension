import AppKit
import AVKit

class DynamicWallpaperView: NSObject, NSWindowDelegate {
    var path: URL
    let window = NSWindow(contentRect: NSScreen.main!.frame,
                         styleMask: [.borderless, .fullSizeContentView],
                         backing: .buffered,
                         defer: false)
    var playerView: AVPlayerView!
    var playerItem: AVPlayerItem!
    var player: AVPlayer!

    init(path: URL) {
        self.path = path
        super.init()
        createWindow()
    }

    func createWindow() {
        playerItem = AVPlayerItem(url: path)
        player = AVPlayer(playerItem: playerItem)
        player.isMuted = true
        
        let firstFrameGenerator = AVAssetImageGenerator(asset: self.playerItem.asset)
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
            
            let fileName = (path.lastPathComponent as NSString).deletingPathExtension + "_static.tiff"
            let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
            try imageData.write(to: fileURL)
            try NSWorkspace.shared.setDesktopImageURL(fileURL, for: NSScreen.main!, options: [:])
        } catch {
            print("Failed to get the first frame.")
        }
        
        window.delegate = self
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

        playerView = AVPlayerView(frame: window.contentView!.frame)
        playerView.player = player
        playerView.videoGravity = .resizeAspectFill
        playerView.controlsStyle = .none
        
        window.contentView = playerView

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
