//
//  WidgetWindowDelegate.swift
//  Trimension
//
//  Created by Shiyuan Liu on 1/17/23.
//

import AppKit

class WidgetWindowDelegate: NSWindowController, NSWindowDelegate {
    func windowDidResize(_ notification: Notification) {
//        print("The window was resized!")
    }
    
    func windowDidResignKey(_ notification: Notification) {
//        print("Resign")
        if let window = notification.object as? NSWindow {
            window.contentView?.layer?.backgroundColor = .clear
        }
    }
    
    func windowDidBecomeKey(_ notification: Notification) {
//        print("Become key")
        if let window = notification.object as? NSWindow {
            window.contentView?.layer?.backgroundColor = .black
        }
    }
    
}
