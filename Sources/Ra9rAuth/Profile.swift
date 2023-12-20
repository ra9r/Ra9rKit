//
//  File.swift
//  
//
//  Created by Rodney Aiglstorfer on 12/20/23.
//



import SwiftUI

import FirebaseAuth

@Observable
public class Profile {
    public var uid: String
    public var email: String?
    public var photoUrl: String?
    public var phoneNumber: String?
    public var displayName: String?
    public var isAnonymous: Bool = false
    
    public init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
        self.phoneNumber = user.phoneNumber
        self.displayName = user.displayName
        self.isAnonymous = user.isAnonymous
    }
}
