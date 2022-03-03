//
//  ContentView.swift
//  SwiftUIListsAndNavigation
//
//  Created by  Paul on 02.03.2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NameList()
                .tabItem {
                    Label("Persons", systemImage: "person.3.fill")
                }
            ContactList()
                .tabItem {
                    Label("Numbers", systemImage: "phone.fill")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PersonManager())
    }
}
