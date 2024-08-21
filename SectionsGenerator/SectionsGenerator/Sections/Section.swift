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
    
    func toString() -> String {
        var string = "{\n"
        string += "\t\"sectionType\": \"\(sectionType)\""
        let mirror = Mirror(reflecting: self)
        
        for child in mirror.children {
            guard let propertyName = child.label else { continue }
            string += ",\n"
            string += "\t\"\(propertyName)\": \"\(child.value)\""
        }
        string += "\n}"
        return string
    }
    
    func getModelByProperties(properties: [String : String]) -> Section? {
        return nil
    }
    
    func getStringValue(value: String, properties: [String : String]) -> String? {
        if let result = properties[value] {
            return result
        }
        return nil
    }
    
    func getBoolValue(value: String, properties: [String : String]) -> Bool? {
        guard let string = getStringValue(value: value, properties: properties)
        else { return nil }
        switch string.lowercased() {
        case "false":
            return false
        case "true":
            return true
        default:
            return nil
        }
    }
    
    
}
