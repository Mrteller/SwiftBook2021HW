//
//  ContentView.swift
//  SliderGame
//
//  Created by  Paul on 27.02.2022.
//

import SwiftUI

struct ContentView: View {
    @State private var currentValue: Float = 30
    @State private var targetValue: Int = .random(in: 0...100)
    @State private var checkResultsIsPresented = false
    
    var body: some View {
        VStack {
            Text("Target value is: \(targetValue)")
            SliderView(value: $currentValue, thumbTintAlpha: CGFloat(computeScore()) / 100)
            Button("Check me") {
                checkResultsIsPresented.toggle()
            }
            .alert(Text("Your score"), isPresented: $checkResultsIsPresented, actions: {}, message: { Text("\(computeScore()) points") })
  
            Button("Try again") {
                targetValue = .random(in: 0...100)
            }
        }
        .padding(.horizontal)
    }
    
    private func computeScore() -> Int {
        let difference = abs(targetValue - Int(round(currentValue)))
        return 100 - difference
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
