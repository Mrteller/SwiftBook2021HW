import SwiftUI

class ContentViewModel: ObservableObject {
    
    @Published var originalItems =
"""
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
""".components(separatedBy: .whitespacesAndNewlines)
    
    @Published var spacing: CGFloat = 8
    @Published var padding: CGFloat = 8
    @Published var wordCount: Int = 75
    @Published var alignmentIndex = 0
    
    var words: [String] {
        Array(originalItems.prefix(wordCount))
    }
    
    let alignments: [HorizontalAlignment] = [.leading, .center, .trailing]
    
    var alignment: HorizontalAlignment {
        alignments[alignmentIndex]
    }
}

struct ContentView: View {
    @StateObject var model = ContentViewModel()
    
    var body: some View {
        ScrollView {
                FlexibleGridFit(
                    items: model.words,
                    spacing: model.spacing,
                    alignment: model.alignment
                ) { item in
                    Text(verbatim: item)
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.mint.opacity(0.2))
                                .blur(radius: 2)
                        )
                }
                .padding(.horizontal, model.padding)
        }
        .overlay(Settings(model: model), alignment: .bottom)
    }
}

struct Settings: View {
    @ObservedObject var model: ContentViewModel
    let alignmentName: [String] = ["leading", "center", "trailing"]
    
    var body: some View {
        VStack {
            Stepper(value: $model.wordCount, in: 0...model.originalItems.count) {
                Text("\(model.wordCount) words")
            }
            
            HStack {
                Text("Padding")
                Slider(value: $model.padding, in: 0...60) { Text("") }
            }
            
            HStack {
                Text("Spacing")
                Slider(value: $model.spacing, in: 0...40) { Text("") }
            }
            
            HStack {
                Text("Alignment")
                Picker("Choose alignment", selection: $model.alignmentIndex) {
                    ForEach(0..<model.alignments.count) {
                        Text(alignmentName[$0])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Button {
                model.originalItems.shuffle()
            } label: {
                Text("Shuffle")
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
