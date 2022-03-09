import SwiftUI

struct Settings: View {
    @Binding var spacing: Float
    @Binding var itemWidth: Float
    @Binding var alignmentIndex: Int
    let alignmentNames: [String] = ["leading", "center", "trailing"]
    
    var body: some View {
        VStack {
            HStack {
                Text("Spacing")
                Slider(value: $spacing, in: 0...40) { Text("\(spacing)") }
            }
            HStack {
                Text("Item width")
                Slider(value: $itemWidth, in: 0...1) { Text("\(itemWidth)") }
            }
            HStack {
                Text("Alignment")
                Picker("Choose alignment", selection: $alignmentIndex) {
                    ForEach(alignmentNames.indices) {
                        Text(alignmentNames[$0])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.mint, lineWidth: 4)
        )
        .padding()
    }
}

