//
//  ColorWidgetView.swift
//  Trimension
//
//  Created by Shiyuan Liu on 5/21/23.
//

import Foundation
import AppKit
import WebKit

class WidgetView: WKWebView {
    
    var _dragShouldRepositionWindow: Bool = false
    var width: CGFloat?
    var height: CGFloat?
    
    convenience init() {
        self.init(frame: .zero, configuration: WKWebViewConfiguration())
    }
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        wantsLayer = true
        layer?.backgroundColor = .clear
        layer?.isOpaque = false
        layer?.cornerRadius = 30
        setValue(false, forKey: "drawsBackground")
        translatesAutoresizingMaskIntoConstraints = false
        
        if let url = Bundle.main.url(forResource: "WidgetHTML", withExtension: "html") {
            let request = URLRequest(url: url)
            self.load(request)
        }
        
//        frame = NSRect(origin: .zero, size: intrinsicContentSize)
//        print(frame.size.height)
        
        evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
                if complete != nil {
                    self.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                        print(height)
                    })
                }
        })

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func mouseDown(with: NSEvent) {
//        super.mouseDown(with: with)
//        _dragShouldRepositionWindow = true
//    }
//
//    override func mouseUp(with: NSEvent) {
//        super.mouseUp(with: with)
//        _dragShouldRepositionWindow = false
//    }
//
//    override func mouseDragged(with: NSEvent) {
//        super.mouseDragged(with: with)
//        if (_dragShouldRepositionWindow) {
//            window?.performDrag(with: with)
//        }
//    }
    
}
