//
//  PDFBuilder.swift
//  Chemo-Buddy
//
//  Created by Rodney Aiglstorfer on 10/29/23.
//

import SwiftUI

/// Sample usage:
///  ````
///  import SwiftUI
///
///  @MainActor
///  struct ContentView: View {
///     @State var pdfURL: URL? = nil
///     var body: some View {
///         VStack {
///             if let pdfURL {
///                PDFPreview(url: pdfURL)
///                     .frame(maxWidth: .infinity, maxHeight: .infinity)
///             } else {
///                 Button("Generate PDF") {
///                   self.pdfURL = PDFBuilder("MyPDF").build([AnyView(CoverPage()), AnyView(SecondPage())])
///                 }
///             }
///         }
///     }
///     // rest of class here ...
///  }
///  ````
public class PDFRenderer {
    
    /// The rect that represents a paper size.  Default is a A4/Letter
    var box: CGRect
    
    /// Name of the PDF file (don't include '.pdf').  Defaults to "output".
    var fileName: String
    
    public init(_ fileName: String, box: CoreFoundation.CGRect? = nil) {
        self.fileName = fileName
        self.box = box ?? CGRect(x: 0, y: 0, width: 612, height: 792)
    }
    
    @MainActor
    public func render(toDirectory dir: URL, views: [AnyView]) -> URL? {
        // create a URL for the file in a document directory
        let pdfUrl = dir.appending(path: "\(self.fileName).pdf")
        
        // create the content to render the PDF
        guard let pdfContext = CGContext(pdfUrl as CFURL, mediaBox: &self.box, nil) else {
            print("[App Error]: Failed to create context for rending \(self.fileName).pdf")
            return nil
        }
        
        // convert the views into ImageRenderers
        let renderers = views.map { view in
            ImageRenderer(content: view.frame(width: box.width, height: box.height))
        }
        
        // loop over the renderers and add a PDF page to the document
        for renderer in renderers {
            
            // 3: Start the rendering process
            renderer.render { size, context in
                
                
                // 6: Start a new PDF page
                pdfContext.beginPDFPage(nil)
                
                // 7: Render the SwiftUI view data onto the page
                context(pdfContext)
                
                // 8: End the page and close the file
                pdfContext.endPDFPage()
            }
        }
        
        pdfContext.closePDF()
        
        // return the URL to the PDF that was generated
        return pdfUrl
    }
}

