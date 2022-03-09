//
//  AwardsView.swift
//  AwardsCollectionApp
//
//  Created by Alexey Efimov on 17.06.2021.
//

import SwiftUI

struct AwardsView: View {
    let awards = Award.getAwards()

    var activeAwards: [Award] {
        awards.filter { $0.awarded }
    }
    
    @State private var spacing: Float = 10
    @State private var itemWidth: Float = 0.8
    @State private var alignmentIndex: Int = 0
    
    private let alignments: [HorizontalAlignment] = [.leading, .center, .trailing]
    var body: some View {
        NavigationView {
            CustomGridView(columns: 2, items: activeAwards, alignment: alignments[alignmentIndex], spacing: CGFloat(spacing)) { itemSize, award in
                VStack {
                    award.awardView
                    Text(award.title)
                }
                .frame(width: itemSize.width * CGFloat(itemWidth), height: itemSize.height)
                .border(.gray, width: 2)
            }
            .navigationBarTitle("Awards")
        }
        .overlay(Settings(spacing: $spacing, itemWidth: $itemWidth, alignmentIndex: $alignmentIndex), alignment: .bottom)
    }
}

//struct AwardsView: View {
//    let awards = Award.getAwards()
//    let columns = [GridItem(.adaptive(minimum: 120, maximum: 200))]
//    var activeAwards: [Award] {
//        awards.filter { $0.awarded }
//    }
//
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                LazyVGrid(columns: columns) {
//                    ForEach(activeAwards, id: \.title) { award in
//                        VStack {
//                            award.awardView
//                            Text(award.title)
//                        }
//                    }
//                }
//            }.navigationTitle("Your awords: \(activeAwards.count)")
//        }
//    }
//}

struct AwardsView_Previews: PreviewProvider {
    static var previews: some View {
        AwardsView()
    }
}
