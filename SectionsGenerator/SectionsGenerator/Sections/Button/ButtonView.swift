//
//  ButtonView.swift
//  SectionsGenerator
//
//  Created by Rafael Torga on 16/08/24.
//

import SwiftUI

struct ButtonView: View {
    var model: ButtonModel
    var body: some View {
        HStack {
            Text(model.text)
                .foregroundStyle(model.getType() == .primary ? .white : .orange)
        }
        .frame(height: 40)
        .frame(maxWidth: .infinity)
        .background(model.getType() == .primary ? .orange : .white)
        .border(model.getType() == .primary ? .clear : .orange, width: 3)
        .clipShape(.rect(cornerRadius: 8))
        
    }
}

#Preview {
    ButtonView(model: .init(text: "Text", type: .secondary))
}
