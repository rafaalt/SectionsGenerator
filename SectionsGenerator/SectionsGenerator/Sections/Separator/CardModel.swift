//
//  CardModel.swift
//  SectionsGenerator
//
//  Created by Rafael Torga on 17/08/24.
//

import Foundation
import SwiftUI

class CardModel: Section {
    var icon: String?
    var text: String
    var type: CardType?
    
    init(icon: String?, text: String, type: CardType?) {
        self.icon = icon
        self.text = text
        self.type = type
        super.init(sectionType: "SECTION_CARD")
    }
    
    override func getModelByProperties(properties: [String : String]) -> CardModel? {
        guard let text = getStringValue(value: "text", properties: properties) else { return nil}
        let icon = getStringValue(value: "icon",
                                  properties: properties)?.lowercased()
        let type = CardType.getByString(getStringValue(value: "type",
                                                         properties: properties))
        return CardModel(icon: icon, 
                         text: text,
                         type: type)
    }
    
    func getBackground() -> Color {
        switch type {
        case .white:
            return .white
        case .blue:
            return .blue
        case .orange:
            return .orange
        case .red:
            return .red
        default:
            return .gray
        }
    }
}

enum CardType {
    case white
    case blue
    case orange
    case red
    
    static func getByString(_ string: String?) -> CardType {
        guard let string = string else { return .blue }
        switch string.lowercased() {
        case "white":
            return .white
        case "blue":
            return .blue
        case "orange":
            return .orange
        case "red":
            return .red
        default:
            return .blue
        }
    }
}
