//
//  SemaphoreStateManager.swift
//  Semaphore
//
//  Created by  Paul on 17.02.2022.
//

import SwiftUI

struct SemaphoreLightModel: Identifiable, Hashable {
    var id = UUID()
    var state = false
    var color: Color
}

class SemaphoreStateManager : ObservableObject {
    
    var lights = [SemaphoreLightModel(color: .red), SemaphoreLightModel(color: .yellow), SemaphoreLightModel(color: .green)] {
        didSet {
            if let ndx = lights.firstIndex(where: { $0.id == selection}) {
                lights[ndx].state = false
            }
            selection = lights.first(where: { $0.state })?.id
            objectWillChange.send()
        }
    }
    
    private var selection: SemaphoreLightModel.ID?
    
    func next() {
        guard let idx = lights.firstIndex(where: { $0.state }) ?? lights.indices.first else { return }
        let next = lights.index(after: idx)
        lights[next == lights.endIndex ? lights.startIndex : next].state = true
    }
    
    func previous() {
        guard var idx = lights.firstIndex(where: { $0.state }) ?? lights.indices.first else { return }
        if idx == lights.startIndex {
            let lastIndex = lights.index(lights.endIndex, offsetBy: -1)
            lights[lastIndex].state = true
        } else {
            lights.formIndex(&idx, offsetBy: -1)
            lights[idx].state = true
        }
    }
}
