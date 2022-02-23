//
//  UserManager.swift
//  StateAndDataFlow
//
//  Created by brubru on 21.02.2022.
//

import Foundation
import SwiftUI

class UserManager: ObservableObject {
    var isRegister: Bool {
        !name.isEmpty
    }
    @AppStorage("username") var name = ""
}
