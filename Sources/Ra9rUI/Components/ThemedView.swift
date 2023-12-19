// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

struct ThemedView <Content : View>: View {
    @EnvironmentObject private var errManager: ErrorManager
    
    public var color = Color.theme.accent
    public var background = Color.theme.background
    public var image: ImageResource = .background
    
    @ViewBuilder var content: Content

    var body: some View {
        ZStack {
            backgroundColor
            backgroundSVGOverlay
            backgroundGradients
            VStack {
                content
            }
        }
        .alert(isPresented: errManager.showError) {
            Alert(title: Text("Error"),
                  message: Text(errManager.error!.localizedDescription))
        }
    }
    
    private var backgroundColor: some View {
        background
            .ignoresSafeArea()
    }
    
    private var backgroundSVGOverlay: some View {
        SVGImage(image: .background, color: color)
            .frame(width: UIScreen.main.bounds.width)
            .opacity(0.4)
    }
    
    private var backgroundGradients: some View {
        VStack {
            // Top gradient
            LinearGradient(
                colors: [background, background.opacity(0), background],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            .opacity(0.8)
        }
    }
}

#Preview {
    NavigationStack {
        ThemedView {
            List {
                NavigationLink("Hello!") {
                    ThemedView {
                        Text("Hello all")
                    }
                }
                .navigationTitle("Settings")
//                .navigationBarTitleDisplayMode(.inline)
            }
            .scrollContentBackground(.hidden)
        }
    }
    .environmentObject(ErrorManager())
}
