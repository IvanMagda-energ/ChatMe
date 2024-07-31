//
//  AuthTextFieldViewModifier.swift
//  ChatMe
//
//  Created by Ivan Magda on 28.07.2024.
//

import Foundation
import SwiftUI

struct AuthTextFieldViewModifier: ViewModifier {
    var backgroundColor: Color
    var foregroundColor: Color
    var textFieldHeight: CGFloat = 58
    
    func body(content: Content) -> some View {
            content
                .padding()
                .frame(height: textFieldHeight)
                .foregroundColor(foregroundColor)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: textFieldHeight / 2))
        .overlay(
            RoundedRectangle(cornerRadius: textFieldHeight / 2)
                .stroke(.white, lineWidth: 4)
        )
        .shadow(radius: 10)
    }
}
