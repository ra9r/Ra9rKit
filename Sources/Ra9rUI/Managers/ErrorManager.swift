//
//  File.swift
//  
//
//  Created by Rodney Aiglstorfer on 12/19/23.
//

import SwiftUI

@MainActor
public class ErrorManager : ObservableObject {
    
    @Published var error: Error?
    
    var showError: Binding<Bool> {
        Binding<Bool> {
            guard let error = self.error else {
                return false
            }
            print("** Error: \(error.localizedDescription) **")
            return true
        } set: { newShowError in
            if newShowError == false {
                self.error = nil
            }
        }
    }
    
    init() {
        
    }
}