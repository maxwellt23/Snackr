//
//  SnackrYoutubeView.swift
//  Snackr
//
//  Created by Tyler Maxwell on 4/8/25.
//

import SwiftUI
import WebKit

struct SnackrYoutubeView: UIViewRepresentable {
    let videoId: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let url = URL(string: "https://www.youtube.com/embed/\(videoId)") else { return }
        uiView.scrollView.isScrollEnabled = false
        uiView.load(URLRequest(url: url))
    }
}
