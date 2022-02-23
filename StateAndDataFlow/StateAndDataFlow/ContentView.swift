//
//  ContentView.swift
//  StateAndDataFlow
//
//  Created by brubru on 21.02.2022.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var user: UserManager
    @StateObject private var timer = TimeCounter()
    
    var body: some View {
        VStack(spacing: 40) {
            Text("Hi, \(user.name)")
                .font(.largeTitle)
                .offset(x: 0, y: 100)
            Text("\(timer.counter)")
                .font(.largeTitle)
                .offset(x: 0, y: 100)
            Spacer()
            Button(action: timer.startTimer) {
                Text("\(timer.buttonTitle)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .button(backgroundFill: .red)
            Spacer()
            Button(action: user.logout) {
                Text("Logout")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .button(backgroundFill: .blue)

//            Button(action: user.logout) {
//                Label("Logout", systemImage: "rectangle.portrait.and.arrow.right.fill")
//            }
            Spacer()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//struct ButtonView: View {
//    @ObservedObject var timer: TimeCounter
//
//    var body: some View {
//        Button(action: timer.startTimer) {
//            Text("\(timer.buttonTitle)")
//                .font(.title)
//                .fontWeight(.bold)
//                .foregroundColor(.white)
//        }
//        .button(backgroundFill: .red)
//
//        Button(action: user.logout) {
//            Text("Logout")
//                .font(.title)
//                .fontWeight(.bold)
//                .foregroundColor(.white)
//        }
//        .button(backgroundFill: .blue)
//    }
//}

struct ButtonModifier<S: ShapeStyle>: ViewModifier {
    let valueShapeStyle: S
    func body(content: Content) -> some View {
        content
            .frame(width: 200, height: 60)
            .background(valueShapeStyle)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.black, lineWidth: 4)
            )
    }
}

extension View {
    func button<S: ShapeStyle>(backgroundFill: S) -> some View {
        self.modifier(ButtonModifier(valueShapeStyle: backgroundFill))
    }
}
