//
//  ButtonModel.swift
//  SectionsGenerator
//
//  Created by Rafael Torga on 16/08/24.
//

import Foundation

class ButtonModel: Section {
    var text: String
    var icon: String?
    var type: ButtonType?
    var size: String?
    var alignment: String?
    var isEnabled: Bool?
    
    init(text: String, icon: String? = nil, type: ButtonType? = nil, size: String? = nil, alignment: String? = nil, isEnabled: Bool? = nil) {
        self.text = text
        self.icon = icon
        self.type = type
        self.size = size
        self.alignment = alignment
        self.isEnabled = isEnabled
        super.init(sectionType: "STANDALONE_BUTTON")
    }
    
    override func getModelByProperties(properties: [String : String]) -> ButtonModel? {
        guard let text = getStringValue(value: "text", properties: properties) else { return nil}
        let icon = getStringValue(value: "icon",
                                  properties: properties)
        let type = ButtonType.getByString(getStringValue(value: "type",
                                                         properties: properties))
        let size = getStringValue(value: "size",
                                  properties: properties)
        let alignment = getStringValue(value: "alignment",
                                       properties: properties)
        let isEnabled = getBoolValue(value: "isEnabled",
                                     properties: properties)
        return ButtonModel(text: text,
                           icon: icon,
                           type: type,
                           size: size,
                           alignment: alignment,
                           isEnabled: isEnabled)
    }
    
    func getType() -> ButtonType {
        return type ?? .primary
    }
}

enum ButtonType {
    case primary
    case secondary
    
    static func getByString(_ string: String?) -> ButtonType {
        guard let string = string else { return .primary }
        switch string.lowercased() {
        case "primary":
            return .primary
        case "secondary":
            return .secondary
        default:
            return .primary
        }
    }
}
