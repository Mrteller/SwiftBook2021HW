//
//  PersonManager.swift
//  SwiftUIListsAndNavigation
//
//  Created by  Paul on 03.03.2022.
//

import SwiftUI

final class PersonManager: ObservableObject {
    @Published var persons = Person.randomPersons()
}
