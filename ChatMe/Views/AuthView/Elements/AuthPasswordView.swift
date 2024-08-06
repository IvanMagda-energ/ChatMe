//
//  AuthPasswordView.swift
//  ChatMe
//
//  Created by Ivan Magda on 28.07.2024.
//

import SwiftUI

struct AuthPasswordView: View {
    @Binding var text: String
    var placeholder: String
    @FocusState var isFocused: FieldToFocus?
    @State private var isPasswordShown = false
    @Binding var isPasswordValid: Bool
    
    private var foregroundColor: Color {
        if isFocused != nil {
            return isPasswordValid ? .blue : .red
        } else {
            return isPasswordValid ? . white : .red
        }
    }
    
    var body: some View {
        HStack {
            Image(systemName: "lock")
                .font(.system(size: 22, weight: .heavy))
                .foregroundStyle(isFocused != nil ? .blue : .white)
            Group {
                if isPasswordShown {
                    TextField(
                        placeholder,
                        text: $text
                    )
                        .focused($isFocused, equals: .textField)
                } else {
                    SecureField(
                        placeholder,
                        text: $text
                    )
                        .focused($isFocused, equals: .secureField)
                }
            }
            .font(.system(size: 20, weight: .bold))
            .disableAutocorrection(true)
            .autocapitalization(.none)
                        
            Button {
                isPasswordShown.toggle()
            } label: {
                Image(systemName: "eye")
                    .foregroundStyle(isFocused != nil ? .blue : .white)
            }
        }
        .modifier(
            AuthTextFieldViewModifier(
                backgroundColor: isFocused != nil ? .white : .clear,
                foregroundColor: foregroundColor
            )
        )
        .onChange(of: isPasswordShown) {
            isFocused = isPasswordShown ? .textField : .secureField
                }
    }
}

#Preview {
    AuthPasswordView(text: .constant(""), placeholder: "Password", isPasswordValid: .constant(false))
}

enum FieldToFocus {
        case secureField, textField
    }
