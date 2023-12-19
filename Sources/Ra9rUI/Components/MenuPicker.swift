//
//  MenuPicker.swift
//  Ra9rKit
//
//  Created by Rodney Aiglstorfer on 10/7/22.
//

import SwiftUI

public struct MenuPicker<T : Hashable>: View {
    var label: String
    @Binding var selection: T?
    var optionList: Array<T>
    var icon: ((T) -> Image)? = nil
    var title: (T) -> String
    
    public init(_ label: String,
                selection: Binding<T?>,
                options: Array<T>,
                title: @escaping (T) -> String,
                icon: ((T) -> Image)? = nil) {
        self.label = label
        self._selection = selection
        self.optionList = options
        self.title = title
        self.icon = icon
    }
    
    public var body: some View {
        HStack {
            Text(label)
            Spacer()
            Menu {
                ForEach(optionList, id:\.self) { t in
                    Button {
                        selection = t
                    } label: {
                        if let icon = self.icon {
                            HStack {
                                icon(t)
                                Text(title(t))
                            }
                        } else {
                            Text(title(t))
                        }
                    }
                }
            } label: {
                if let selection {
                    Text(title(selection))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    Image(systemName: "chevron.up.chevron.down")
                        .padding(.leading, 5)
                } else {
                    Text("- Select -")
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .opacity(0.5)
                }
            }
        }
    }
}

#Preview {
    struct Preview : View {
        @State var selectedOption: String?
        var body: some View {
            Form {
                MenuPicker("Sample Options",
                           selection: $selectedOption,
                           options: ["One", "Two", "Three"]) { option in
                    option
                } icon: { option in
                    Image(systemName: "plus")
                }
            }
        }
    }
    
    return Preview()
}
