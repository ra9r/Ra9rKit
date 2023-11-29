//
//  SwiftUIView.swift
//  Ra9rKit
//
//  Created by Rodney Aiglstorfer on 11/23/23.
//

import SwiftUI

public struct SequencePicker<T : Hashable, Content>: View where Content: View {
    @Binding var selected: T?
    var sequence: [T]
    var current: T
    let content: (T, Bool, Bool) -> Content
    
    @Namespace private var namespace
    
    public init(sequence: [T],
                selected: Binding<T?>,
                current: T,
                content: @escaping (T, Bool, Bool) -> Content)
    {
        self.sequence = sequence
        self.current = current
        self._selected = selected
        self.content = content
    }
    
    public var body: some View {
        ScrollViewReader { pos in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(sequence, id: \.self) { item in
                        let selected = isSelected(item)
                        ZStack {
                            if selected {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.accentColor.gradient)
                                    .matchedGeometryEffect(id: "itemBG", in: namespace)
                            }
                            VStack(alignment: .center) {
                                Spacer()
                                content(item, isCurrent(item), selected)
                                if isCurrent(item) {
                                    Circle()
                                        .fill(selected ? Color.white : Color.black)
                                        .frame(width: 5, height: 5)
                                } else {
                                    Circle()
                                        .fill(Color.white.opacity(0))
                                        .frame(width: 5, height: 5)
                                }
                                Spacer()
                            }
                        }
                        .foregroundColor(selected ? Color.white : Color.black)
                        .frame(width: 30, height: 50)
                        .onTapGesture {
                            withAnimation(.spring){
                                self.selected = item
                            }
                        }
                        .id(item)
                    }
                }
                .scrollTargetLayout()
                
            }
            .scrollTargetBehavior(.viewAligned)
            .frame(height: 80)
            .onAppear() {
                if selected == nil {
                    self.selected = current
                    pos.scrollTo(current)
                }
            }
        }
    }
}

extension SequencePicker {
    func isCurrent(_ item: T) -> Bool {
        return item.hashValue == self.current.hashValue
    }
    
    func isSelected(_ item: T) -> Bool {
        if let selected = self.selected {
            return item.hashValue == selected.hashValue
        }
        return false
    }
}

#Preview("Cycle Example") {
    struct Cycle: Hashable {
        var index: Int
        var start: Date
    }
    
    func makeSamples() -> [Cycle] {
        let now = Date.now
        let cal = Calendar.current
        do {
            return try Array(0...24).map<Cycle>({ ndx in
                let start = cal.date(byAdding: .day, value: ndx, to: now)
                return Cycle(index: ndx, start: start!)
            })
        } catch {
            return []
        }
    }
    
   
    struct Preview: View {
        @State var selectedCycle: Cycle?
        var cycles: [Cycle] = makeSamples()
        var body: some View {
            Group {
                if let selectedCycle {
                    Text(selectedCycle.start.formatted("MMM dd, YYYY"))
                }
                SequencePicker(sequence: cycles,
                               selected: $selectedCycle,
                               current: cycles[10]) { item, isCurrent, isSelected in
                    Group {
                        Text("Cycle")
                            .minimumScaleFactor(0.6)
                        Text("\(item.index)")
                    }
                }
                
            }.padding()
        }
    }
    
    return Preview()
}
