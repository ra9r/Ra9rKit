//
//  WebView.swift
//  ChemoBuddy
//
//  Created by Rodney Aiglstorfer on 10/10/22.
//

import SwiftUI
import WebKit

public struct WebView : UIViewRepresentable {
    
    var url: URL
    
    public func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    public func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

#Preview {
    WebView(url: URL(string: "https://chemobuddy.app")!)
        .ignoresSafeArea()
}
