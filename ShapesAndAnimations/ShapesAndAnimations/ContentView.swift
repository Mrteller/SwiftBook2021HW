//
//  ContentView.swift
//  ShapesAndAnimations
//
//  Created by  Paul on 06.03.2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var count: CGFloat = 5
    @State private var innerRatio: CGFloat = 1
    
    @State private var scale = CGSize(width: 0.5, height: 0.5)
    @State private var starOpacity = 0.0
    
    var scaleGesture: some Gesture {
        MagnificationGesture()
            .onChanged { size in
                scale = CGSize(width: size, height: size)
            }
    }
    
    var body: some View {
        VStack {
            ZStack {
                Star(count: count, innerRatio: innerRatio)
                    .inset(by: 80)
                    .strokeBorder(lineWidth: 5)
                    .aspectRatio(contentMode: .fit)
                StarView(count: count, innerRatio: innerRatio, scale: scale)
                    .animation(.easeOut, value: scale)

                    .opacity(starOpacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.5).delay(0.1)) {
                            starOpacity = 1
                        }
                    }
            }
            .gesture(scaleGesture)
            VStack(alignment: .sliderLeading) {
                HStack {
                    Text("Count : ")
                    Slider(value: $count, in: 1...10)
                        .frame(width: 150)
                        .alignmentGuide(.sliderLeading) { d in d[.leading] }
                    Text("\(count, specifier: "%.2f")")
                }
                HStack {
                    Text("InnerRatio : ")
                    Slider(value: $innerRatio, in: 0...2)
                        .frame(width: 150)
                        .alignmentGuide(.sliderLeading) { d in d[.leading] }
                    Text("\(innerRatio, specifier: "%.2f")")
                }
            }
            Text("Pinch the shape to resize")
                .font(.footnote)
        }
        .padding()
    }
}

extension HorizontalAlignment {
    private enum SliderLeading : AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            return context[HorizontalAlignment.center]
        }
    }
    static let sliderLeading = HorizontalAlignment(SliderLeading.self)
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
