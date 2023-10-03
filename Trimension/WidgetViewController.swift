//
//  WidgetViewController.swift
//  Trimension
//
//  Created by Shiyuan Liu on 5/21/23.
//

import Foundation
import AppKit
import WebKit
import SwiftUI

class WidgetViewController: NSViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        self.view = WidgetView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

//        webView = WKWebView(frame: self.view.bounds)
//        self.view.addSubview(webView)
//        webView.navigationDelegate = self
//
//        // Load your HTML content here
//        let htmlString = "<html><div>HelloWorld</div></html>"
//        webView.loadHTMLString(htmlString, baseURL: nil)
    }

//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
//            if let contentHeight = height as? CGFloat {
//                print("Content height: \(contentHeight)")
//            }
//        })
//
//        webView.evaluateJavaScript("document.body.scrollWidth", completionHandler: { (width, error) in
//            if let contentWidth = width as? CGFloat {
//                print("Content width: \(contentWidth)")
//            }
//        })
//    }
}
