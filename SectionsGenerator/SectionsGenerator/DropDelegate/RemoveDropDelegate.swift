//
//  PreviewDropDelegate.swift
//  SectionsGenerator
//
//  Created by Rafael Torga on 16/08/24.
//

import SwiftUI

struct RemoveDropDelegate: DropDelegate {
    @Binding var sections: [SectionModel]
    @Binding var draggedSection: SectionModel?
    let isFromPreview: Bool
    
    func performDrop(info: DropInfo) -> Bool {
        guard let draggedSection = draggedSection else { return false }
        if isFromPreview {
            withAnimation(.snappy) {
                if let sourceIndex = sections.firstIndex(of: draggedSection) {
                    sections.remove(at: sourceIndex)
                }
            }
        }
        return true
    }
    
    func dropEntered(info: DropInfo) { }
}
