//
//  AppleMusicWidget.swift
//  Trimension
//
//  Created by Shiyuan Liu on 5/31/23.
//

import Foundation
import WebKit
import AVKit

class AppleMusicWidget: WidgetView {
    
    convenience init() {
        self.init(frame: .zero, configuration: WKWebViewConfiguration())
        
    }
    
}
