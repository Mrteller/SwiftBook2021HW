//
//  ContentView.swift
//  Semaphore
//
//  Created by  Paul on 16.02.2022.
//

import SwiftUI

struct ColorCircle: View {
    let color: Color
    @Binding var isOn: Bool
    
    var body: some View {
        let shape = Circle()
        shape
            .foregroundColor(Color.gray.opacity(isOn ? 0 : 0.8))
            .overlay(shape.stroke(Color.white, lineWidth: 4))
            .background(shape.fill(color))
            .shadow(radius: 10)
            .onTapGesture {
                withAnimation {
                    isOn = true
                }
            }
    }
}

struct ColorCircle_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ColorCircle(color: .red, isOn: .constant(false))
                .frame(maxHeight: 60)
            Spacer().frame(maxHeight: 60)
        }
        .padding()
    }
}
