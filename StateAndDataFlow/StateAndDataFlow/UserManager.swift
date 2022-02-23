//
//  UserManager.swift
//  StateAndDataFlow
//
//  Created by brubru on 21.02.2022.
//

import Foundation
import SwiftUI

class UserManager: ObservableObject {
    var isRegister: Bool { !name.isEmpty }
    @AppStorage("username") private(set) var name = ""
    
    func setUsernameTo(_ newName: String) {
        if !newName.isEmpty {
            name = newName
        }
    }
    
    func logout() {
            name = ""
    }
}
