//
//  MenuPicker.swift
//  Ra9rKit
//
//  Created by Rodney Aiglstorfer on 10/7/22.
//

import SwiftUI

public struct MenuPicker<T : Hashable>: View {
    var label: String
    @Binding var selectedOption: T
    var optionList: Array<T>
    var icon: ((T) -> Image)? = nil
    var title: (T) -> String
    
    public init(_ label: String,
                selection: Binding<T>,
                options: Array<T>,
                title: @escaping (T) -> String,
                icon: ((T) -> Image)? = nil) {
        self.label = label
        self._selectedOption = selection
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
                        selectedOption = t
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
                Text(title(selectedOption))
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                Image(systemName: "chevron.up.chevron.down")
                    .padding(.leading, 5)
            }
        }
    }
}

#Preview {
    Form {
        MenuPicker("Sample Options",
                   selection: .constant("One"),
                   options: ["One", "Two", "Three"]) { option in
            option
        } icon: { option in
            Image(systemName: "plus")
        }
    }
}
