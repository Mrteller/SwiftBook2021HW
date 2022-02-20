//
//  SliderWithTextFieldAndAlert.swift
//  ColorChooserSwiftUI
//
//  Created by  Paul on 20.02.2022.
//

import SwiftUI

struct SliderWithTextFieldAndAlert: View {
    enum ConversionError: LocalizedError {
        case notANumber, numberOutOfRange
        var errorDescription: String? {
            switch self {
            case .notANumber:
                return NSLocalizedString("Not a number", comment: "Alert")
            case .numberOutOfRange:
                return NSLocalizedString("Number is out of range", comment: "Alert")
            }
        }
    }
    
    init(_ val: Binding<Double>) {
        _value = val
        _valueText = .init(initialValue: String(format: "%.1f", val.wrappedValue))
    }
    @Binding var value: Double
    @State private var valueText: String
    @State private var conversionError: ConversionError?
    @State private var showAlert = false
    
    @FocusState var textFieldHasFocus: Bool
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
        HStack {
            Slider(value: Binding(get: {
                value
            }, set: { newValue, _ in
                textFieldHasFocus = false
                value = newValue
                valueText = numberFormatter.string(from: NSNumber(value: value))!
                textId = UUID()
            }),
                   in: minValue...maxValue)
            TextField("", text: $valueText)
                .focused($textFieldHasFocus)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.center)
                .frame(width: width / 4)
                .id(textId)
                .onChange(of: textFieldHasFocus) { hasFocus in
                    if !hasFocus  {
                        Self._printChanges()
                        guard let number = numberFormatter.number(from: valueText)?.doubleValue
                        else {
                            valueText = numberFormatter.string(from: NSNumber(value: value))!
                            conversionError = .notANumber
                            showAlert = true
                            return
                        }
                        if  !(minValue...maxValue ~= number) {
                            valueText = numberFormatter.string(from: NSNumber(value: value))!
                            conversionError = .numberOutOfRange
                            showAlert = true
                            return
                        }
                        value = number
                    }
                }
                .alert(isPresented: $showAlert, error: conversionError) {}
        }
        .readSize(onChange: { width = $0.width })
        .padding(.vertical)
    }
}

struct SliderWithTextFieldAndAlert_Previews: PreviewProvider {
    static var previews: some View {
        SliderWithTextFieldAndAlert(.constant(100))
    }
}
