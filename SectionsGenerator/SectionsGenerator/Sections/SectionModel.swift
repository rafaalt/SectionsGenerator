//
//  SectionModel.swift
//  SectionsGenerator
//
//  Created by Rafael Torga on 31/07/24.
//

import Foundation

struct SectionModel: Identifiable, Equatable {
    var id: UUID = .init()
    var section: Section
    
    init(id: UUID, section: Section) {
        self.id = id
        self.section = section
    }
    
    init(section: Section) {
        self.section = section
    }
    
    init(model: SectionModel) {
        self.section = model.section
    }
    
    static func == (lhs: SectionModel, rhs: SectionModel) -> Bool {
        return lhs.id == rhs.id
    }
    
}

