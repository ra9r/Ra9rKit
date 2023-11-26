//
//  PDFView.swift
//  Chemo-Buddy
//
//  Created by Rodney Aiglstorfer on 10/29/23.
//

import SwiftUI

import SwiftUI
import PDFKit

public struct PDFPreview: UIViewRepresentable {
    var url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
    public func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        return pdfView
    }
    
    public func updateUIView(_ pdfView: PDFView, context: Context) {
        pdfView.document = PDFDocument(url: url)
    }
}
