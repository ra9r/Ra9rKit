//
//  SwiftUIView.swift
//  
//
//  Created by Rodney Aiglstorfer on 3/15/24.
//

import SwiftUI

public struct RulerPicker: View {
    // Picker Range
    var range = 0...100
    // Configuration
    var config: RulerConfig
    // Selected value
    @Binding var value: CGFloat
    // View Property
    @State private var isLoaded: Bool = false
    
    public var body: some View {
        GeometryReader {
            let size = $0.size
            let horizontalPadding = size.width / 2
            
            ScrollView(.horizontal) {
                HStack(spacing: config.spacing) {
                    let count = range.upperBound - range.lowerBound
                    let totalSteps = config.steps * count
                    
                    ForEach(0...totalSteps, id: \.self) { index in
                        let remainder = index % config.steps
                        let hashHeight = hashHeight(index: index)
                        
                        Divider()
                            .background(remainder == 0 ? Color.primary : .gray)
                            .frame(width: 0, height: hashHeight, alignment: .center)
                            .frame(maxHeight: 20, alignment: .bottom)
                            .overlay(alignment: .bottom) {
                                if remainder == 0 && config.showsText {
                                    labelText(index: index)
                                }
                            }
                    }
                }
                .frame(height: size.height)
                .scrollTargetLayout()
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: .init(get: {
                let position: Int? = isLoaded ? (Int(value) * config.steps) / config.multiplier : nil
                return position
            }, set: { newValue in
                if let newValue {
                    value = (CGFloat(newValue) / CGFloat(config.steps)) * CGFloat(config.multiplier)
                }
            }))
            // Center Mark
            .overlay(alignment: .center) {
                Rectangle()
                    .frame(width: 1, height: 40)
                    .padding(.bottom, 20)
            }
            .safeAreaPadding(.horizontal, horizontalPadding)
            .onAppear {
                if !isLoaded { isLoaded = true}
            }
        }

    }
    
    func labelText(index: Int) -> some View {
        Text("\((index / config.steps) * config.multiplier) ")
            .font(.caption)
            .fontWeight(.semibold)
            .textScale(.secondary)
            .fixedSize()
            .offset(y:20)
    }
    
    func hashHeight(index: Int) -> CGFloat {
        for (divisor, specialValue) in config.hashHeights {
            if index % divisor == 0 {
                return specialValue
            }
        }
        return config.hashHeight
    }
}

public struct RulerConfig: Equatable, Hashable {
    public var steps: Int
    public var spacing: CGFloat
    public var multiplier: Int
    public var showsText: Bool = true
    public var hashHeight: CGFloat = 10
    public var hashHeights: [Int: CGFloat]
    
    public static var basic = RulerConfig(steps: 10, spacing: 10, multiplier: 1, showsText: true, hashHeights: [
        10: 20
    ])
    
    public static var metric = RulerConfig(steps: 10, spacing: 10, multiplier: 1, showsText: true, hashHeights: [
        5: 15,
        10: 20
    ])
    
    public static var imperial16 = RulerConfig(steps: 16, spacing: 10, multiplier: 1, showsText: true, hashHeight: 5, hashHeights: [
        2: 10,
        4: 15,
        8: 20
    ])
    
    public static var imperial8 = RulerConfig(steps: 8, spacing: 10, multiplier: 1, showsText: true, hashHeight: 5, hashHeights: [
        2: 10,
        4: 20
    ])
}

// MARK: - Preview Wrapper

private struct RulerPickerPreview: View {
    @State private var config: RulerConfig = .imperial8
    @State private var value: CGFloat = 10
    
    var body: some View {
        NavigationStack {
            VStack {
                SpinningNumber(value: $value, uom: UnitLength.inches)
                    .padding(.bottom, 3)
                
                RulerPicker(config: config, value: $value)
                    .frame(height: 60)
                    .padding()
                
                VStack(alignment: .leading) {
                    Picker("Options", selection: $config) {
                        Text("Basic").tag(RulerConfig.basic)
                        Text("Metric").tag(RulerConfig.metric)
                        Text("Imperial 8").tag(RulerConfig.imperial8)
                        Text("Imperial 16").tag(RulerConfig.imperial16)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                }.padding()
            }
            .navigationTitle("Wheel Picker")
        }
    }
}

#Preview {
    RulerPickerPreview()
}
