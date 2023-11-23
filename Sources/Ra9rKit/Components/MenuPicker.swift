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
    var icon: ((T) -> ImageResource)? = nil
    var title: (T) -> String
    
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
                                Image(icon(t))
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
        MenuPicker(label: "Sample Options",
                   selectedOption: .constant("One"),
                   optionList: ["One", "Two", "Three"]) { option in
            option
        }
    }
}
