//
//  AnimatedSideBar.swift
//  SideMenuStudy
//
//  Created by Rodney Aiglstorfer on 4/14/24.
//

import SwiftUI

public struct AnimatedSideBar<Content: View, MenuView: View, Background: View>: View {
    /// Customization Options
    public var rotatesWhenExpands: Bool = true
    public var disablesInteractions: Bool = true
    public var sideMenuWidth: CGFloat = 200
    public var cornerRadius: CGFloat = 25
    @Binding public  var showMenu: Bool
    public var content: Content
    public var menuView: MenuView
    public var background: Background
    /// View Properties
    @GestureState private var isDragging: Bool = false
    @State private var offsetX: CGFloat = 0
    @State private var lastOffsetX: CGFloat = 0
    /// Used to Dim content view when side bar is being dragged
    @State private var progress: CGFloat = 0
    
    public init(
        rotatesWhenExpands: Bool = true,
        disablesInteractions: Bool = true,
        sideMenuWidth: CGFloat = 200,
        cornerRadius: CGFloat = 25,
        showMenu: Binding<Bool>,
        @ViewBuilder content: () -> Content,
        @ViewBuilder menuView: () -> MenuView,
        @ViewBuilder background: () -> Background
    ) {
        self.rotatesWhenExpands = rotatesWhenExpands
        self.disablesInteractions = disablesInteractions
        self.sideMenuWidth = sideMenuWidth
        self.cornerRadius = cornerRadius
        self._showMenu = showMenu
        self.content = content()
        self.menuView = menuView()
        self.background = background()
    }

    public var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.safeAreaInsets ?? .zero
            
            HStack(spacing: 0) {
                GeometryReader { _ in
                    sideMenuFrame(safeArea)
                }
                .frame(width: sideMenuWidth)
                /// Clipping Menu Interaction Beyond it's Width
                .contentShape(.rect)
                
                GeometryReader { _ in
                    content
                }
                .frame(width: size.width)
                .overlay {
                    if disablesInteractions && progress > 0 {
                        Rectangle()
                            .fill(.black.opacity(progress * 0.2))
                            .onTapGesture {
                                withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                                    reset()
                                }
                            }
                    }
                }
                .mask {
                    RoundedRectangle(cornerRadius: progress * cornerRadius)
                }
                .scaleEffect(rotatesWhenExpands ? 1 - (progress * 0.1) : 1, anchor: .trailing)
                .rotation3DEffect(.init(degrees: rotatesWhenExpands ? (progress * -15) : 0), axis: (x: 0.0, y: 1.0, z: 0.0))
            }
            .frame(width: size.width + sideMenuWidth, height: size.height)
            .offset(x: -sideMenuWidth)
            .offset(x: offsetX)
            .contentShape(.rect)
            .simultaneousGesture(drawGesture)
        }
        .background(background)
        .ignoresSafeArea()
        .onChange(of: showMenu, initial: true) { oldValue, newValue in
            withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                if newValue {
                    showSideBar()
                } else {
                    reset()
                }
            }
        }
    }
    
    @ViewBuilder
    private func sideMenuFrame(_ safeArea: UIEdgeInsets) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            menuView
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 20)
        .padding(.top, safeArea.top)
        .padding(.bottom, safeArea.bottom)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .environment(\.colorScheme, .dark)
    }
    
    // Drag Gesture
    private var drawGesture: some Gesture {
        DragGesture()
            .updating($isDragging) { _, out, _ in
                out = true
            }.onChanged { value in
                // hack to fix the fact that the edge gesture for the NavigationStack isn't working since our
                // gesture is interfering with it.  To avoid this simply ignore touches on teh leading edge.
                guard value.startLocation.x > 10 else { return }
                
                let translationX = isDragging ? max(min(value.translation.width + lastOffsetX, sideMenuWidth), 0) : 0
                offsetX = translationX
                calculateProgress()
            }.onEnded { value in
                // hack to fix the fact that the edge gesture for the NavigationStack isn't working since our
                // gesture is interfering with it.  To avoid this simply ignore touches on teh leading edge.
                guard value.startLocation.x > 10 else { return }
                
                withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                    let velocityX = value.velocity.width / 0
                    let total = velocityX + offsetX
                    
                    if total > (sideMenuWidth * 0.5) {
                        showSideBar()
                    } else {
                        reset()
                    }
                }
            }
    }
    ///  Show's Side Bar
    private func showSideBar() {
        offsetX = sideMenuWidth
        lastOffsetX = offsetX
        showMenu = true
        calculateProgress()
    }
    
    /// Reset's to it's Initial State
    private func reset() {
        offsetX = 0
        lastOffsetX = 0
        showMenu = false
        calculateProgress()
    }
    
    /// Convert offset into series of progress ranging from 0 - 1
    private func calculateProgress() {
        progress = max(min(offsetX / sideMenuWidth, 1), 0)
    }
}
