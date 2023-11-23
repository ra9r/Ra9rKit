//
//  SimpleMenuPicker.swift
//  Ra9rKit
//
//  Created by Rodney Aiglstorfer on 11/6/22.
//

import SwiftUI

public struct SimpleMenuPicker<OPT : Hashable>: View {
    var title: String
    @Binding var selection: OPT?
    var options: [OPT]
    var label: KeyPath<OPT, String>
    var icon: KeyPath<OPT, ImageResource>?
    
    public init(_ title: String,
         selection: Binding<OPT?>,
         options: [OPT],
         label: KeyPath<OPT, String>,
         icon: KeyPath<OPT, ImageResource>? = nil) {
        self.title = title
        self._selection = selection
        self.options = options
        self.label = label
        self.icon = icon
    }
    
    public var body: some View {
        HStack {
            Text(title)
            Spacer()
            Menu {
                ForEach(options, id:\.self) { option in
                    if let icon = self.icon {
                        Button {
                            selection = option
                        } label: {
                            HStack {
                                Image(option[keyPath: icon])
                                Text(option[keyPath: label])
                            }
                        }
                    } else {
                        Button {
                            selection = option
                        } label: {
                            Text(option[keyPath: label])
                        }
                    }
                }
            } label: {
                HStack {
                    if let selection {
                        Text(selection[keyPath: label])
                            .foregroundColor(Color.black)
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    } else {
                        Text("- Select -")
                            .foregroundColor(Color.black)
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    Image(systemName: "chevron.up.chevron.down")
                        .padding(.leading, 5)
                }
                
            }
        }
    }
}

#Preview {
    Form {
        SimpleMenuPicker<String>("Sample", 
                                 selection: .constant("Foo"),
                                 options: ["Foo", "Bar", "Gar"],
                                 label: \.localizedUppercase)
    }
}

