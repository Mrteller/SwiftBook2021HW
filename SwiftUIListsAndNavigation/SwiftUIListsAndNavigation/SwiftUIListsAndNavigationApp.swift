//
//  SwiftUIListsAndNavigationApp.swift
//  SwiftUIListsAndNavigation
//
//  Created by  Paul on 02.03.2022.
//

import SwiftUI

@main
struct SwiftUIListsAndNavigationApp: App {
    @StateObject private var personManager = PersonManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(personManager)
        }
    }
}
