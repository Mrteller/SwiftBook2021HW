//
//  Person.swift
//  ContactsTableView
//
//  Created by  Paul on 28.12.2021.
//

struct Person {
    
    var name: String
    var surname: String
    var email: String
    var phone: String
    
    var fullName: String {
        "\(name) \(surname)"
    }
    
    static func randomPersons() -> [Person] {
        var persons = [Person]()
        let dataManager = DataManager.shared
        let surnames = dataManager.surnames.shuffled()
        let emails = dataManager.emails.shuffled()
        let phones = dataManager.phones.shuffled()
        
        for (index, name) in dataManager.names.shuffled().enumerated() {
            persons.append(Person(
                name: name,
                surname: surnames[index],
                email: emails[index],
                phone: phones[index]))
        }
        
        return persons
    }
}
