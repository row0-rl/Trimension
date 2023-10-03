////
////  WallpaperWindow.swift
////  Trimension
////
////  Created by Shiyuan Liu on 1/12/23.
////
//
//import AppKit
//import Foundation
//
//class WallpaperWindow: NSWindow {
//    convenience init(contentRect: NSRect, screen: NSScreen) {
//        self.init(contentRect: contentRect,
//                  styleMask: [.borderless, .fullSizeContentView],
//                  backing: .buffered,
//                  defer: true,
//                  screen: screen)
//    }
//    
//    private func setup() {
//        level = .init(Int(CGWindowLevelForKey(CGWindowLevelKey.desktopWindow)))
//        hasShadow = false
////        isReleasedWhenClosed = false
//        isMovableByWindowBackground = false
//        ignoresMouseEvents = true
//        collectionBehavior = [
//            .canJoinAllSpaces, // 出瑞在所有桌面
//            .stationary // 缩放不影响壁纸
//        ]
////        contentView = VideoContentView()
//    }
//}
