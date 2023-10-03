import SwiftUI
import Supabase
import AppKit


@main
struct TrimensionApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
//                .background(Color.black.opacity(0.1))
                .background(BlurEffect(material: .fullScreenUI).ignoresSafeArea())
                .preferredColorScheme(.dark)
//                .onAppear {
//                    if let window = NSApplication.shared.windows.first {
//                        window.ignoresMouseEvents = true
//                        window.backgroundColor = .red
//                        print("window")
//                    }
//                }
//                .onReceive(NotificationCenter.default.publisher(for: NSWindow.didBecomeKeyNotification)) { notification in
//                    if let window = notification.object as? NSWindow {
//                        window.backgroundColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0.8)
//                        let visualEffectView = NSVisualEffectView()
//                        visualEffectView.material = .fullScreenUI //.fullScreenUI more transparent/brighter
//                        visualEffectView.state = .active
//                        visualEffectView.blendingMode = .behindWindow
//                        visualEffectView.alphaValue = 1.0
////                        window.contentView? = visualEffectView
//                    }
//                }
        }
        .windowStyle(.hiddenTitleBar)
    }
}

struct BlurEffect: NSViewRepresentable {
    var material: NSVisualEffectView.Material
    func makeNSView(context: Self.Context) -> NSView {
        let visualEffectView = NSVisualEffectView()
        visualEffectView.material = material
        visualEffectView.state = .active
        visualEffectView.blendingMode = .behindWindow
        visualEffectView.alphaValue = 1.0
        return visualEffectView
    }
    func updateNSView(_ nsView: NSView, context: Context) { }
}
