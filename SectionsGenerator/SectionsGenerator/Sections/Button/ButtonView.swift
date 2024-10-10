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
        .clipShape(.rect(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 3)
                .fill(model.getType() == .primary ? .clear : .orange)
        }
        
    }
}

#Preview {
    ButtonView(model: .init(text: "Text", type: .secondary))
}
