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
    var body: some View {
        NavigationView {
            CustomGridView(columns: 2, items: activeAwards) { itemSize, award in
                VStack {
                    award.awardView
                    Text(award.title)
                }
                //.aspectRatio(itemSize.width / itemSize.height, contentMode: .fit)
                .frame(width: itemSize.width, height: itemSize.height)
                .border(.gray, width: 2)
            }
            .navigationBarTitle("Awards")
        }
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
