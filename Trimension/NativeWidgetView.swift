//
//  ClockWidgetView.swift
//  Trimension
//
//  Created by Shiyuan Liu on 1/13/23.
//

import SwiftUI
import AppKit
import WebKit

class NativeWidgetView: NSView {
    private var timer: Timer?
//    private var isDragging: Bool
    
    convenience init() {
        self.init(frame: .zero)
        let backgroundColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        wantsLayer = true
        layer?.backgroundColor = backgroundColor.cgColor
        layer?.cornerRadius = 10
    }
        
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        if self.superview != nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        } else {
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc func updateTime() {
        self.setNeedsDisplay(self.bounds)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        let currentTime = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        let time = dateFormatter.string(from: currentTime)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: NSColor.white,
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: NSFont(name: "Apple SD Gothic Neo Heavy", size: 60)
        ]
        
        let textRect = dirtyRect.insetBy(dx: 8, dy: 8)
        time.draw(in: textRect, withAttributes: attributes)
    }
    
    override func updateTrackingAreas() {
        let trackingArea = NSTrackingArea(rect: self.bounds, options: [.mouseEnteredAndExited, .activeAlways], owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea)
    }
    
    override func mouseEntered(with event: NSEvent) {
        print("Mouse entered view")
        window!.makeKey()
    }
    
}
