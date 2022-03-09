import SwiftUI

struct FlexibleGrid<Items: Collection, Content: View>: View where Items.Element: Hashable {
    let availableWidth: CGFloat
    let items: Items
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Items.Element) -> Content
    @State var elementsSize: [Items.Element: CGSize] = [:]
    
    var body : some View {
        VStack(alignment: alignment, spacing: spacing) {
            ForEach(computeRows(), id: \.self) { rowElements in
                HStack(spacing: spacing) {
                    ForEach(rowElements, id: \.self) { element in
                        content(element)
                            .fixedSize()
                            .readSize { size in
                                elementsSize[element] = size
                            }
                    }
                }
            }
        }
    }
    
    func computeRows() -> [[Items.Element]] {
        var rows: [[Items.Element]] = [[]]
        var currentRow = 0
        var remainingWidth = availableWidth
        
        for item in items {
            let itemSize = elementsSize[item, default: CGSize(width: availableWidth, height: 1)]
            
            if remainingWidth - (itemSize.width + spacing) >= 0 {
                rows[currentRow].append(item)
            } else {
                currentRow = currentRow + 1
                rows.append([item])
                remainingWidth = availableWidth
            }
            
            remainingWidth = remainingWidth - (itemSize.width + spacing)
        }
        
        return rows
    }
}
