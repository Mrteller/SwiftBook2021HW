//
//  ContentView.swift
//  ColorChooserSwiftUI
//
//  Created by  Paul on 20.02.2022.
//

import SwiftUI

struct ContentView: View {
    @State private var redValue = 128.0
    @State private var greenValue = 128.0
    @State private var blueValue = 128.0
    var body: some View {
        TabView {
            VStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .foregroundColor(Color(.sRGB, red: redValue/255, green: greenValue/255, blue: blueValue/255, opacity: 1))
                SliderWithTextField(value: $redValue)
                    .tint(.red)
                SliderWithTextField(value: $greenValue)
                    .tint(.green)
                SliderWithTextField(value: $blueValue)
                    .tint(.blue)
            }
            .tabItem {
                Label("General", systemImage: "text.bubble.fill")
            }
            
            VStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .foregroundColor(Color(.sRGB, red: redValue/255, green: greenValue/255, blue: blueValue/255, opacity: 1))
                SliderWithTextFieldAndAlert($redValue)
                    .tint(.red)
                SliderWithTextFieldAndAlert($greenValue)
                    .tint(.green)
                SliderWithTextFieldAndAlert($blueValue)
                    .tint(.blue)
            }
            .tabItem {
                Label("Alert", systemImage: "exclamationmark.bubble.fill")
            }
            
        }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        hideKeyboard()
                    }
                }
            }
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
