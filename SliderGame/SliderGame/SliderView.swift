//
//  SliderView.swift
//  SliderGame
//
//  Created by  Paul on 27.02.2022.
//

import SwiftUI

struct SliderView: UIViewRepresentable {
    @Binding var value: Float
    var thumbTintAlpha: CGFloat

    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider()
        slider.value = value
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged),
            for: .valueChanged
        )
        return slider
    }

    func updateUIView(_ slider: UISlider, context: Context) {
        slider.value = value
        slider.thumbTintColor = .red.withAlphaComponent(thumbTintAlpha)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(value: $value)
    }
}

extension SliderView {
    class Coordinator: NSObject {
        @Binding private var value: Float

        init(value: Binding<Float>) {
            _value = value
        }
        
        @objc func valueChanged(_ sender: UISlider) {
            value = sender.value
        }

    }
}

struct SliderView_Previews: PreviewProvider {
    @State static var sliderValue: Float = 50
    static var previews: some View {
        SliderView(value: $sliderValue, thumbTintAlpha: 0.5)
    }
}
