//
//  SliderWithTextField.swift
//  ColorChooserSwiftUI
//
//  Created by  Paul on 20.02.2022.
//

import SwiftUI

import SwiftUI

struct SliderWithTextField: View {
    @Binding var value: Double
    @FocusState private var textFieldHasFocus: Bool
    private let numberFormatter: NumberFormatter = {
        $0.locale = Locale.current
        $0.maximumFractionDigits = 1
        return $0
    }(NumberFormatter())
    
    @State private var width = 0.0
    @State private var textId = UUID()
    
    private let minValue = 0.0
    private let maxValue = 255.0
    
    var body: some View {
        HStack() {
            Slider(value: Binding(get: {
                value
            }, set: { newValue, _ in
                textFieldHasFocus = false
                value = newValue
            }),
                   in: minValue...maxValue)
            TextField("",
                      value: Binding(get: {
                value
            }, set: { newValue, _ in
                value = max(min(newValue, maxValue), minValue)
                if value != newValue {
                    textId = UUID()
                }
            }),
                      formatter: numberFormatter)
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.center)
                .keyboardType(.decimalPad)
                .focused($textFieldHasFocus)
                .frame(width: width / 4)
                .id(textId)
        }
        .readSize(onChange: { width = $0.width })
        .padding(.vertical)
    }
}

struct SliderWithTextField_Previews: PreviewProvider {
    static var previews: some View {
        SliderWithTextField(value: .constant(100.0))
    }
}
