//
//  AuthUserNameView.swift
//  ChatMe
//
//  Created by Ivan Magda on 28.07.2024.
//

import SwiftUI

struct AuthUserNameView: View {
    @Binding var text: String
    @FocusState var isFocused
    
    var body: some View {
        HStack {
            Image(systemName: "person")
                .font(.system(size: 22, weight: .heavy))
                .foregroundStyle(isFocused ? .blue : .white)
            
            TextField("User name", text: $text)
                .focused($isFocused)
                .font(.system(size: 20, weight: .bold))
        }
        .modifier(
            AuthTextFieldViewModifier(
                backgroundColor: isFocused ? .white : .clear,
                foregroundColor: isFocused ? .blue : .white
            )
        )
    }
}

#Preview {
    AuthUserNameView(text: .constant(""))
}
