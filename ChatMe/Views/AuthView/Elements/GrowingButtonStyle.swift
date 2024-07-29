//
//  GrowingButtonStyle.swift
//  ChatMe
//
//  Created by Ivan Magda on 29.07.2024.
//

import Foundation
import SwiftUI

struct GrowingButtonStyle: ButtonStyle {
    var backgroundColor: Color
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(backgroundColor)
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
