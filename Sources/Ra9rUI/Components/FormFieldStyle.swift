//
//  FormFieldStyle.swift
//  
//
//  Created by Rodney Aiglstorfer on 3/9/24.
//

import SwiftUI

public struct FormFieldStyle: TextFieldStyle {
    let label: String
    
    public init(_ label: String) {
        self.label = label
    }
    
    // Hidden function to conform to this protocol
    public func _body(configuration: TextField<Self._Label>) -> some View {
        LabeledContent(label) {
            configuration
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview {
    
    Form {
        TextField("Name Here", text: .constant(""))
            .textFieldStyle(FormFieldStyle("Name"))
    }
    
}
