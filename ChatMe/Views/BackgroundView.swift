//
//  BackgroundView.swift
//  ChatMe
//
//  Created by Ivan Magda on 28.07.2024.
//

import Foundation
import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.accentColor, .mint],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        }
    }
}
    
    #Preview {
        BackgroundView()
    }
