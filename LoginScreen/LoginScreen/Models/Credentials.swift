//
//  Credentials.swift
//  LoginScreen
//
//  Created by  Paul on 17.12.2021.
//

import Foundation

struct Credentials: Hashable, CustomStringConvertible {
    let login: String
    let password: String

    var description: String {
        "\(login)\n\(password)"
    }
    
    static var `default` = Credentials(login: "teller", password: "pass")
}

struct Person {
    
    struct Project {
        let name: String
        let htmlURL: URL
    }
    
    let name: String
    let userName: String
    let bio: String
    let birthDate: Date?
    let avatarURL: URL?
    let projects: [Project]
    
    static var `default` = Person(
        name: "Mr Teller",
        userName: "mrteller",
        bio: "Some info",
        birthDate: dateFormatter.date(from: "23/02/1990"),
        avatarURL: URL(string: "https://avatars.githubusercontent.com/u/39244601?v=4"),
        projects: [
            Project(name: "SwiftBook2021HW",
                    htmlURL: URL(string: "https://github.com/Mrteller/SwiftBook2021HW")!),
            Project(name: "MatrixEnter",
                    htmlURL: URL(string: "https://github.com/Mrteller/MatrixEnter")!),
            Project(name: "CasinoRoulette",
                    htmlURL: URL(string: "https://github.com/Mrteller/CasinoRoulette")!)
        ]
    )
}

/// Simulation of session to some remote storage. It could be a singelton instead.
struct Session {
    
    static func getPerson(login: String?, password: String?) -> Result<Person, Error> {
        // We do not report back if login is valid or not, just remind if it's empty
        switch (login, password) {
        case (_, _) where (login == nil || login?.isEmpty ?? true) :
            return .failure("Username is not provided.")
        case (_, _) where (password == nil || password?.isEmpty ?? true) :
            return .failure("Password is not provided.")
        case let (login?, password?):
            if let person = personWith(login, password) {
                return .success(person)
            } else {
                return .failure("Incorrect credentials:\n\(login)\\\(password)")
            }
        default:
            return .failure("Failed to log in")
        }
    }
    
    private static func personWith(_ login: String, _ password: String) -> Person? {
        userDirectory[Credentials(login: login, password: password).hashValue] // IRL it would be some hash function with `salt`
    }
    
    // At server-side credentials are stored as hashes in some database key-value storage or table
    private static let userDirectory = [Credentials.default.hashValue : Person.default]
    
}

// TODO: rewrite as extension
let dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "DD/MM/YYYY"
    return df
}()
