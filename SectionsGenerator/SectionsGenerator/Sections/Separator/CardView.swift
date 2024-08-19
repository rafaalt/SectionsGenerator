//
//  CardView.swift
//  SectionsGenerator
//
//  Created by Rafael Torga on 17/08/24.
//

import SwiftUI

struct CardView: View {
    var model: CardModel
    
    var body: some View {
        HStack {
            Image(systemName: model.icon ?? "")
            Text(model.text)
                .bold()
                .font(.title2)
                .foregroundStyle(.black)
        }
        .frame(height: 50)
        .frame(maxWidth: .infinity)
        .background(model.getBackground())
        .clipShape(.rect(cornerRadius: 8))
    }
}

#Preview {
    CardView(model: .init(icon: "heart", text: "TEXTO", type: .red))
}
