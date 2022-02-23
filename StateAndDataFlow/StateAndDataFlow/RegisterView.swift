//
//  RegisterView.swift
//  StateAndDataFlow
//
//  Created by brubru on 21.02.2022.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var user: UserManager
    @State private var name = ""
    @State private var password = ""
    var body: some View {
        VStack {
            AdaptiveStackWithEqualDistribution(
                text: $name,
                value: "Symbols: \(name.count)",
                valueShapeStyle: isValidName(name) ? .green : .red, prompt: "Enter your name...")
                .padding(.bottom)
            AdaptiveStackWithEqualDistribution(
                text: $password,
                value: "Symbols: \(password.count)",
                valueShapeStyle: isValidPassword(password,lengthRange: 4...20) ?
                    .linearGradient(colors: [.green, .blue], startPoint: .top, endPoint: .bottom) :
                        .linearGradient(colors: [.red, .purple], startPoint: .top, endPoint: .bottom),
                prompt: "Enter your password...")
                .padding(.bottom)
            Button(action: { user.setUsernameTo(name)}) {
                Label("Ok", systemImage: "checkmark.circle.fill")
            }
            .disabled(!isValidName(name)) // TODO: || !isValidPassword(password,lengthRange: 4...20)
        }
        .padding(.horizontal)
    }
}

extension RegisterView {
    private func isValidName(_ name: String) -> Bool {
       let nameRegex = "^\\w{3,18}$"
       let validateNamePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
       return validateNamePredicate.evaluate(with: name)
    }
    private func isValidPassword<R: RangeExpression>(_ name: String, lengthRange: R) -> Bool where R.Bound == Int {
        guard  lengthRange ~= name.count else { return false }
        return name.allSatisfy{ $0.isASCII }
    }    
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
