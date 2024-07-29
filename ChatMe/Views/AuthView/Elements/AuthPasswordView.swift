//
//  AuthPasswordView.swift
//  ChatMe
//
//  Created by Ivan Magda on 28.07.2024.
//

import SwiftUI

struct AuthPasswordView: View {
    @Binding var text: String
    var passwordFieldType: PasswordFieldType
    @FocusState var isFocused: FieldToFocus?
    @State private var isPasswordShown = false
    
    var body: some View {
        HStack {
            Image(systemName: "lock")
                .font(.system(size: 22, weight: .heavy))
                .foregroundStyle(isFocused != nil ? .blue : .white)
            
            Group {
                if isPasswordShown {
                    TextField(
                        passwordFieldType == .password ? "Password" : "Repeat password",
                        text: $text
                    )
                        .focused($isFocused, equals: .textField)
                } else {
                    SecureField(
                        passwordFieldType == .password ? "Password" : "Repeat password",
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
                foregroundColor: isFocused != nil ? .blue : .white
            )
        )
        .onChange(of: isPasswordShown) {
            isFocused = isPasswordShown ? .textField : .secureField
                }
    }
}

#Preview {
    AuthPasswordView(text: .constant(""), passwordFieldType: .password)
}

enum FieldToFocus {
        case secureField, textField
    }

enum PasswordFieldType {
    case password
    case repeatPassword
}
