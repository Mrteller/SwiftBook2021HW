import SwiftUI

struct FlexibleGridFit<Items: Collection, Content: View>: View where Items.Element: Hashable {
    let items: Items
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Items.Element) -> Content
    @State private var availableWidth: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: alignment, vertical: .center)) {
            Color.clear
                .frame(height: 1)
                .readSize { size in
                    availableWidth = size.width
                }
            
            FlexibleGrid(
                availableWidth: availableWidth,
                items: items,
                spacing: spacing,
                alignment: alignment,
                content: content
            )
        }
    }
}
