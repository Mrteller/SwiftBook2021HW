//
//  Models.swift
//  LoginScreen
//
//  Created by  Paul on 17.12.2021.
//

import Foundation
import UIKit

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
        var isFavorite = false
    }
    
    let name: String
    let userName: String
    let bio: String
    let birthDate: Date?
    let avatarURL: URL?
    let projects: [Project]?
    let pictures: [String]? // This wants to be `[URL]`
    
    static var `default` = Person(
        name: "Mr Teller",
        userName: "mrteller",
        bio:
            """
            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
            """,
        birthDate: dateFormatter.date(from: "23/02/1990"),
        avatarURL: URL(string: "https://avatars.githubusercontent.com/u/39244601?v=4"),
        projects: [
            Project(name: "SwiftBook2021HW",
                    htmlURL: URL(string: "https://github.com/Mrteller/SwiftBook2021HW")!,
                    isFavorite: true),
            Project(name: "MatrixEnter",
                    htmlURL: URL(string: "https://github.com/Mrteller/MatrixEnter")!),
            Project(name: "CasinoRoulette",
                    htmlURL: URL(string: "https://github.com/Mrteller/CasinoRoulette")!),
            Project(name: "SwiftBookPractice",
                    htmlURL: URL(string: "https://github.com/Mrteller/SwiftBookPractice")!)
        ], pictures: [
            "mic", "mic.fill", "message", "message.fill", "sun.min", "sun.min.fill", "sunset", "sunset.fill", "pencil",
            "pencil.circle", "highlighter", "pencil.and.outline", "personalhotspot", "network", "icloud",
            "icloud.fill", "car", "car.fill", "bus", "bus.fill", "flame", "flame.fill", "bolt", "bolt.fill"
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
