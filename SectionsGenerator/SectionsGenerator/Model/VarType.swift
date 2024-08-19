//
//  VarType.swift
//  SectionsGenerator
//
//  Created by Rafael Torga on 16/08/24.
//

import Foundation

struct VarType: Identifiable {
    var id: UUID = .init()
    var name: String
    var isOptional: Bool
}
