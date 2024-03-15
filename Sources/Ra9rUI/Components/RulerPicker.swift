//
//  SwiftUIView.swift
//  
//
//  Created by Rodney Aiglstorfer on 3/15/24.
//

import SwiftUI

public struct RulerPicker: View {
    var config: Config
    @Binding var value: CGFloat
    // View Property
    @State private var isLoaded: Bool = false
    
    public var body: some View {
        GeometryReader {
            let size = $0.size
            let horizontalPadding = size.width / 2
            
            ScrollView(.horizontal) {
                HStack(spacing: config.spacing) {
                    let totalSteps = config.steps * config.count
                    
                    ForEach(0...totalSteps, id: \.self) { index in
                        let remainder = index % config.steps
                        
                        Divider()
                            .background(remainder == 0 ? Color.primary : .gray)
                            .frame(width: 0, height: remainder == 0 ? 20 : 10, alignment: .center)
                            .frame(maxHeight: 20, alignment: .bottom)
                            .overlay(alignment: .bottom) {
                                if remainder == 0 && config.showsText {
                                    Text("\((index / config.steps) * config.multiplier) ")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .textScale(.secondary)
                                        .fixedSize()
                                        .offset(y:20)
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
    
    struct Config: Equatable {
        var count: Int
        var steps: Int = 10
        var spacing: CGFloat = 5
        var multiplier: Int = 10
        var showsText: Bool = true
    }
}

// MARK: - Preview Wrapper

private struct RulerPickerPreview: View {
    @State private var config: RulerPicker.Config = .init(count: 30, multiplier: 1)
    @State private var value: CGFloat = 10
    let countOptions = [10, 50, 100]
    let stepOptions = [5, 10]
    let multiplierOptions = [1, 10]
    
    var body: some View {
        NavigationStack {
            VStack {
                SpintText(uom: "kg", value: $value)
                    .padding(.bottom, 3)
                
                RulerPicker(config: config, value: $value)
                    .frame(height: 60)
                    .padding()
                
                VStack(alignment: .leading) {
                    Text("Count")
                    Picker("Options", selection: $config.count) {
                        ForEach(countOptions, id: \.self) { option in
                            Text("\(option)").tag(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Text("Multiplier")
                    Picker("Multiplier", selection: $config.multiplier) {
                        ForEach(multiplierOptions, id: \.self) { option in
                            Text("\(option)").tag(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Text("Steps")
                    Picker("Steps", selection: $config.steps) {
                        ForEach(stepOptions, id: \.self) { option in
                            Text("\(option)").tag(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Text("Spacing")
                    Slider(value: $config.spacing, in: 5...20, step: 1)
                } .padding()
            }
            .navigationTitle("Wheel Picker")
        }
    }
}

#Preview {
    RulerPickerPreview()
}
