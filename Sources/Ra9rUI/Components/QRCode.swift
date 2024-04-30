//
//  QRCode.swift
//  
//
//  Created by Rodney Aiglstorfer on 4/30/24.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

/// Creates a QRCode view using the data
///
/// Here is an example of generating a QRCode for a URL
/// ```
/// QRCode("https://google.com")
/// ```
///
/// Here is an example of generating a QRCode for an Email address
/// ```
/// QRCode("Jonny Drama <jdrama@aol.com>")
/// ```
public struct QRCode: View {
    private var data: String
    
    
    /// Creates a QRCode view using the data specified with infinite width and height
    /// - Parameter data: The data to encode in the QRCode (e.g. a URL, Email Address etc)
    public init(_ data: String) {
        self.data = data
    }
    
    public var body: some View {
        Image(uiImage: generateQRCode(from: data))
            .interpolation(.none)
            .resizable()
            .scaledToFit()
            .frame(width: .infinity, height: .infinity)
    }
    
    private func generateQRCode(from string: String) -> UIImage {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

#Preview {
    QRCode("Jonny Drama <jdrama@aol.com>")
}
