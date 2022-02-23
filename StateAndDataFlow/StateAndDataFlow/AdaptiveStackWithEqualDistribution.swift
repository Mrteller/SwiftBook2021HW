//
//  AdaptiveStackWithEqualDistribution.swift
//  StateAndDataFlow
//
//  Created by  Paul on 23.02.2022.
//

import SwiftUI

struct AdaptiveStackWithEqualDistribution<S: ShapeStyle>: View {
    @Binding var text: String
    var value: String?
    var valueShapeStyle: S
    @Environment(\.verticalSizeClass) var verticalSizeClass
    let prompt: String
    private var isVerticalSizeClassRegular: Bool {
        verticalSizeClass == .regular
    }
    
    var body: some View {
        if isVerticalSizeClassRegular {
            VStack(spacing: 8) {
                equalWidthTexts
            }
        } else {
            HStack(spacing: 8)  {
                equalWidthTexts
            }
        }
    }
    private var equalWidthTexts: some View {
        Group {
            TextField(prompt, text: $text)
                .multilineTextAlignment(isVerticalSizeClassRegular ? .center : .trailing)
                .font(.headline)
                .frame(maxWidth: .infinity,
                       alignment: isVerticalSizeClassRegular ? .center : .trailing)
                .onChange(of: text) { newName in
                    let trimmed = newName.trimmingCharacters(in: .whitespaces)
                    if trimmed != newName {
                        text = trimmed
                    }
                }
            Text(value ?? "")
                .font(.body)
                .foregroundStyle(valueShapeStyle)
                .frame(maxWidth: .infinity,
                       alignment: isVerticalSizeClassRegular ? .center : .leading)
        }
        .padding(2)
        .background(RoundedRectangle(cornerRadius: 5).stroke(Color.gray))
    }
}


struct AdaptiveStackWithEqualDistribution_Previews: PreviewProvider {

    static var previews: some View {
        let gradient = LinearGradient(colors: [.red, .purple], startPoint: .leading, endPoint: .bottomTrailing)
        AdaptiveStackWithEqualDistribution(text: .constant("Name"), value: "Value", valueShapeStyle: Color.green, prompt: "Enter your name...")
        AdaptiveStackWithEqualDistribution(text: .constant("Name"), value: "Value", valueShapeStyle: gradient, prompt: "Enter your password...")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
