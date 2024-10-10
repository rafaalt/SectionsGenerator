//
//  SectionView.swift
//  SectionsGenerator
//
//  Created by Rafael Torga on 31/07/24.
//

import SwiftUI

struct SectionView: View {
    
    var model: SectionModel
    
    var body: some View {
        getView()
    }
    
    func getView() -> some View {
        switch model.section.sectionType {
        case "STANDALONE_BUTTON": 
            guard let model = model.section as? ButtonModel else { return AnyView(defaultView) }
            return AnyView(ButtonView(model: model))
        case "SECTION_CARD":
            guard let model = model.section as? CardModel else { return AnyView(defaultView) }
            return AnyView(CardView(model: model))
        default:
            return AnyView(defaultView)
        }
    }
    
    var defaultView: some View {
        VStack {
            HStack {
                Image(systemName: "heart")
                    .foregroundStyle(.white)
                Text(model.section.sectionType)
                    .bold()
                    .foregroundStyle(.white)
            }
            Text("\(model.id)")
                .bold()
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(.pink)
        .clipShape(.rect(cornerRadius: 10))
    }
}
