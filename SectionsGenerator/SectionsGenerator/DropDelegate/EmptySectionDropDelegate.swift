//
//  EmptySectionDropDelegate.swift
//  SectionsGenerator
//
//  Created by Rafael Torga on 16/08/24.
//

import Foundation
import SwiftUI

struct EmptySectionDropDelegate: DropDelegate {
    @Binding var currentItemArray: [SectionModel]
    @Binding var otherItemArray: [SectionModel]
    @Binding var draggedItem: SectionModel?
    
    func performDrop(info: DropInfo) -> Bool {
        guard let draggedItem = draggedItem else { return false }
        
        withAnimation(.snappy) {
            if let sourceIndex = otherItemArray.firstIndex(of: draggedItem) {
                let duplicatedItem = SectionModel(model: draggedItem)
                currentItemArray.append(duplicatedItem)
            }
        }
        
        return true
    }
}
