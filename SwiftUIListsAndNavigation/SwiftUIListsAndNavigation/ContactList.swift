//
//  ContactList.swift
//  SwiftUIListsAndNavigation
//
//  Created by  Paul on 03.03.2022.
//

import SwiftUI

struct ContactList: View {
    @EnvironmentObject var personManager: PersonManager
    var body: some View {
        NavigationView {
            List(personManager.persons) { person in
                Section(person.fullName) {
                    Label(person.phone, systemImage: "phone")
                    Label(person.email, systemImage: "envelope")
                }
            }
            .navigationTitle("Contact list")
        }
    }
}

struct ContactList_Previews: PreviewProvider {
    static var previews: some View {
        ContactList()
            .environmentObject(PersonManager())
    }
}
