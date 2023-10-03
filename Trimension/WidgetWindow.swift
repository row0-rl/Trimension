//
//  WidgetWindow.swift
//  Trimension
//
//  Created by Shiyuan Liu on 1/14/23.
//

import AppKit
import WebKit

class WidgetWindow: NSWindow {
    private var trackingArea: NSTrackingArea?
    let widgetWindowDelegate: WidgetWindowDelegate = WidgetWindowDelegate()
    
    override var canBecomeKey: Bool { get { return true } }
    
    override var canBecomeMain: Bool { get { return true } }
        
    convenience init(_ widgetView: NSView) {
        let screen = NSScreen.main!
        let width: CGFloat = 700
        let height: CGFloat = 400
//        let fittingsize: NSSize = widgetView.fittingSize
//        print(fittingsize.width)
//        print(widgetView.enclosingScrollView!.contentSize.width)
//        widgetView.scrollView.contentSize.width
        
        //NSRect(x: screen.frame.midX-width/2, y: screen.frame.midY-height/2, width: width, height: height)
        self.init(contentRect: NSRect(x: screen.frame.midX-width/2, y: screen.frame.midY-height/2, width: width, height: height),
                  styleMask: [.resizable, .borderless],
                  backing: .buffered,
                  defer: false,
                  screen: screen
        )
//        widgetWindowDelegate = WidgetWindowDelegate()
        delegate = widgetWindowDelegate
        level = .init(Int(CGWindowLevelForKey(CGWindowLevelKey.backstopMenu)))
        collectionBehavior = [
            .stationary,
        ]
        aspectRatio = NSSize(width: width, height: height)
        backgroundColor = .clear
        hasShadow = false
        isMovable = true
        isMovableByWindowBackground = true
        ignoresMouseEvents = false
        isOpaque = false
        
        let visualEffectView = NSVisualEffectView()
        visualEffectView.material = .fullScreenUI
        visualEffectView.state = .active
        
//        widgetView.setFrameOrigin(NSPoint(x: 1000, y: 0))
        
//        let viewcontroller = WidgetViewController()
//        contentViewController=viewcontroller
//        contentView = NSView(frame: .zero)
        contentView = widgetView
//        contentView?.setFrameOrigin(NSPoint(x: width/2, y: -height/2))
//        contentView?.addSubview(viewcontroller.view)
//        contentView?.addSubview(visualEffectView)
        
        let options: NSTrackingArea.Options = [.mouseEnteredAndExited, .activeInKeyWindow, .inVisibleRect]
        let trackingArea = NSTrackingArea(rect: self.contentView!.bounds, options: options, owner: self, userInfo: nil)
        self.contentView?.addTrackingArea(trackingArea)
        
        makeKeyAndOrderFront(nil)
//        orderFrontRegardless()
    }
    
//    override func update() {
//        super.update()
////        print(level)
//        orderFront(nil)
//    }
//
//    override func mouseDown(with event: NSEvent) {
//        super.mouseDown(with: event)
//        print("mousedown")
//    }
    
    func clicked() {
//        print("clicked")
//        print(contentView!.bounds.width)
//        makeKeyAndOrderFront(nil)
//        print(level.rawValue)
    }
    
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
//        makeKey()
        print("entered")
    }

    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        print("mouse exited")
    }
    
}
