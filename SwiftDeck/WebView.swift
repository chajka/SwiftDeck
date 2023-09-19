//
//  WebView.swift
//  SwiftDeck
//
//  Created by Чайка on 2023/09/19.
//

import SwiftUI
import WebKit
import Combine

class WebViewModel: ObservableObject {
    @Published var link: String
    @Published var didFinishLoading: Bool = false
    @Published var pageTitle: String

    init (link: String, didFinishLoading: Bool = false, pageTitle: String = "") {
        self.link = link
        self.pageTitle = ""
    }// end init
}// end class WebViewModel

struct WebView: NSViewRepresentable {
}
