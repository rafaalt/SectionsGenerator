//
//  FullScreenDelegate.swift
//  SectionsGenerator
//
//  Created by Rafael Torga on 21/08/24.
//

import SwiftUI

struct FullScreenDelegate: DropDelegate {
    @Binding var draggedSection: SectionModel?
    
    func performDrop(info: DropInfo) -> Bool {
        guard draggedSection != nil else { return false }
        self.draggedSection = nil
        return true
    }
    
    func dropEntered(info: DropInfo) { }
    
    func validateDrop(info: DropInfo) -> Bool {
        return false
    }
}

