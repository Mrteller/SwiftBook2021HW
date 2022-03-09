//
//  CustomGridView.swift
//  AwardsCollectionApp
//
//  Created by brubru on 07.03.2022.
//

import SwiftUI

struct CustomGridView<Content, T>: View where Content : View {
    let columns: Int
    let items: [T]
    let alignment: HorizontalAlignment
    let spacing: CGFloat
    let content: (_ itemSize: CGSize, _ item: T) -> Content
    
    var rows: Int {
        items.count / columns
    }
    
    var body: some View {
        GeometryReader { geometry in
            // Avoid negative values
            let sideSize = max((geometry.size.width - spacing * CGFloat(columns - 1)) / CGFloat(columns), 0)
            HStack{
                Spacer(minLength: 0)
                ScrollView {
                    VStack(alignment: alignment, spacing: spacing) {
                        ForEach(0...rows, id: \.self) { rowIndex in
                            HStack(spacing: spacing) {
                                ForEach(0..<columns) { columnIndex in
                                    if let index = indexFor(row: rowIndex, column: columnIndex) {
                                        content(CGSize(width: sideSize, height: sideSize), items[index])
                                    } else {
                                        //Spacer()
                                        //EmptyView()
                                        //Color.clear
                                    }
                                }
                            }
                        }
                    }
                }
                Spacer(minLength: 0)
            }
        }
    }
    
    private func indexFor(row: Int, column: Int) -> Int? {
        let index = row * columns + column
        return index < items.count ? index : nil
    }
    
}

struct CustomGridView_Previews: PreviewProvider {
    static var previews: some View {
        CustomGridView(columns: 3, items: [11, 3, 4, 7, 76, 2, 1], alignment: .center, spacing: 10) { itemSize, item in
            Text("\(item)")
                .frame(width: itemSize.width, height: itemSize.height)
                .border(.gray, width: 2)
        }
    }
}
