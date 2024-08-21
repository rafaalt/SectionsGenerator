//
//  MyTextField.swift
//  SectionsGenerator
//
//  Created by Rafael Torga on 17/08/24.
//

import SwiftUI

struct MyTextField: View {
    var placeholder: String
    @Binding var value: String
    
    var body: some View {
        TextField(placeholder, text: $value)
            .frame(maxWidth: .infinity)
            .font(.largeTitle)
            .background(Color("lightOrange"))
            .multilineTextAlignment(.center)
            .clipShape(.rect(cornerRadius: 8))
            .padding(.vertical, 8)
    }
}

#Preview {
    MyTextField(placeholder: "placeholder", value: .constant(""))
}
