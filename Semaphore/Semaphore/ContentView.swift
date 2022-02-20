//
//  ContentView.swift
//  Semaphore
//
//  Created by  Paul on 16.02.2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var state = SemaphoreStateManager()

    var body: some View {
        VStack {
            ForEach($state.lights) { $item in
                ColorCircle(color: item.color, isOn: $item.state)
            }
            controlButtons
            .padding(.vertical)
        }
        .padding()
    }
    
    private var controlButtons: some View {
        HStack {
            Button {
                withAnimation {
                    state.previous()
                }
            } label: {
                Label("Previous", systemImage: "arrowshape.turn.up.left")
            }
            Spacer()
            Button {
                withAnimation {
                    state.next()
                }
            } label: {
                Label("Next", systemImage: "arrowshape.turn.up.right")
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
