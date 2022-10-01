//
//  CustomButtonStyle.swift
//  DriverCompanion
//
//  Created by Derik Malcolm on 9/25/22.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    @State private var tapped = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .background(configuration.isPressed ? Color.secondary.opacity(0.25) : .clear)
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 0.75 : 1, anchor: .center)
            .animation(.linear(duration: 0.3), value: configuration.isPressed)
            .animation(.linear(duration: 0.3), value: tapped)
            .onChange(of: configuration.isPressed) { newValue in
                if newValue {
                    self.tapped = newValue
                }
            }
    }
}

extension ButtonStyle {
    static func custom() -> any ButtonStyle {
        CustomButtonStyle()
    }
}
