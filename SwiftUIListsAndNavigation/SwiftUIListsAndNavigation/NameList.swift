//
//  ContactList.swift
//  SwiftUIListsAndNavigation
//
//  Created by  Paul on 03.03.2022.
//

import SwiftUI

struct NameList: View {
    @EnvironmentObject var personManager: PersonManager
    var body: some View {
        NavigationView {
            List(personManager.persons) { person in
                NavigationLink(person.fullName) {
                    VStack {
                        Image(systemName: "person")
                        //  .resizable(capInsets: .init(top: 10, leading: 100, bottom: 10, trailing: 100), resizingMode: .stretch)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 200)
                        List {
                            Label(person.phone, systemImage: "phone")
                            Label(person.email, systemImage: "envelope")
                        }
                        .listStyle(.plain)
                        Spacer()
                    }
                    .navigationTitle(person.fullName)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Name list")
        }
    }
}

struct NameList_Previews: PreviewProvider {
    static var previews: some View {
        NameList()
            .environmentObject(PersonManager())
    }
}
