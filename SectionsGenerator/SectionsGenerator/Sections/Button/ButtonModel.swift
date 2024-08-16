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
    
    func getType() -> ButtonType {
        return type ?? .primary
    }
}

enum ButtonType {
    case primary
    case secondary
}
