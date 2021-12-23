//
//  Comparable+.swift
//  ColorChooser
//
//  Created by  Paul on 11.12.2021.
//

extension Comparable {
    func clamp(lowerBound: Self, upperBound: Self) -> Self {
        return min(max(self, lowerBound), upperBound)
    }
}
