//
//  ScreenView.swift
//  SectionsGenerator
//
//  Created by Rafael Torga on 21/08/24.
//

import SwiftUI

struct ScreenView: View {
    @State var string = "iphone"
    var body: some View {
        HStack {
            Spacer()
            tela
            Spacer()
            tela
            Spacer()
            tela
            Spacer()
        }
        .frame(maxHeight: .infinity)
        .padding(.horizontal, 80)
    }
    
    var tela: some View {
        ZStack {
            VStack {
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.red)
            .clipShape(.rect(cornerRadius: 16))
            .padding(.vertical, 30)
            .padding(.leading, 35)
            .padding(.trailing, 45)
            Image(string)
                .resizable()
                .onTapGesture {
                    if string == "" {
                        string = "iphone"
                    } else {
                        string = ""
                    }
                }
        }
        .frame(width: 500, height: 955)
    }
}

#Preview {
    ScreenView()
}
