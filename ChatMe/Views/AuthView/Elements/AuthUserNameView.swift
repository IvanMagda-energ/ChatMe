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
    @Binding var isEmailValid: Bool
    private var foregroundColor: Color {
        if isFocused {
            return isEmailValid ? .blue : .red
        } else {
            return isEmailValid ? . white : .red
        }
    }
    
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
                foregroundColor: foregroundColor
            )
        )
    }
}

#Preview {
    AuthUserNameView(text: .constant(""), isEmailValid: .constant(false))
}
