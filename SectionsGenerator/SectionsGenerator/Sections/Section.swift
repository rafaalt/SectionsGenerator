//
//  Section.swift
//  SectionsGenerator
//
//  Created by Rafael Torga on 16/08/24.
//

import Foundation

class Section {
    var sectionType: String
    
    init(sectionType: String) {
        self.sectionType = sectionType
    }
    
    func listProperties() -> [VarType]{
        let mirror = Mirror(reflecting: self)
        
        var types: [VarType] = []
        
        for child in mirror.children {
            guard let propertyName = child.label else { continue }
            
            let isOptional = Mirror(reflecting: child.value).displayStyle == .optional
            
            if isOptional {
                types.append(.init(name: propertyName, isOptional: true))
            } else {
                types.append(.init(name: propertyName, isOptional: false))
            }
        }
        return types
    }
}
