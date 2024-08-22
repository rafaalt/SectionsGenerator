//
//  EmptySectionDropDelegate.swift
//  SectionsGenerator
//
//  Created by Rafael Torga on 16/08/24.
//

import Foundation
import SwiftUI

struct EmptySectionDropDelegate: DropDelegate {
    @Binding var currentSectionArray: [SectionModel]
    @Binding var otherSectionArray: [SectionModel]
    @Binding var draggedSection: SectionModel?
    
    func performDrop(info: DropInfo) -> Bool {
        guard let draggedSection = draggedSection else { return false }
        
        withAnimation(.snappy) {
            let duplicatedSection = SectionModel(model: draggedSection)
            currentSectionArray.append(duplicatedSection)
        }
        self.draggedSection = nil
        return true
    }
}
