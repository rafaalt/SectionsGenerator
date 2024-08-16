//
//  SectionDropDelegate.swift
//  SectionsGenerator
//
//  Created by Rafael Torga on 16/08/24.
//

import SwiftUI

struct SectionDropDelegate: DropDelegate {
    let section: SectionModel?
    @Binding var currentSections: [SectionModel]
    @Binding var anotherSections: [SectionModel]
    @Binding var draggedSection: SectionModel?
    let isLastItem: Bool
    
    func performDrop(info: DropInfo) -> Bool {
        guard let draggedSection = draggedSection else { return false }
        withAnimation(.snappy) {
            if let sourceIndex = currentSections.firstIndex(of: draggedSection) {
                let duplicatedItem = SectionModel(model: draggedSection)
                currentSections[sourceIndex] = duplicatedItem
            }
        }
        return true
    }
    
    func dropEntered(info: DropInfo) {
        guard let draggedSection = draggedSection else { return }
        if let section = section {
            withAnimation(.snappy) {
                if draggedSection != section {
                    if let sourceIndex = currentSections.firstIndex(of: draggedSection) {
                        if isLastItem {
                            currentSections.move(fromOffsets: IndexSet(integer: sourceIndex), toOffset: currentSections.endIndex)
                        } else {
                            currentSections.move(fromOffsets: IndexSet(integer: sourceIndex), toOffset: currentSections.firstIndex(of: section) ?? 0)
                        }
                    } else if anotherSections.firstIndex(of: draggedSection) != nil {
                        let destinationIndex = isLastItem ? currentSections.endIndex : (currentSections.firstIndex(of: section) ?? 0)
                        currentSections.insert(draggedSection, at: destinationIndex)
                    }
                }
            }
        } else {
            if let sourceIndex = currentSections.firstIndex(of: draggedSection) {
                currentSections.move(fromOffsets: IndexSet(integer: sourceIndex), toOffset: currentSections.endIndex)
            } else if anotherSections.firstIndex(of: draggedSection) != nil {
                currentSections.append(draggedSection)
            }
        }
    }
}
