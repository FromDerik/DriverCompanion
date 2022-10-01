//
//  PlainOrFilledButtonStyle.swift
//  DriverCompanion
//
//  Created by Derik Malcolm on 9/25/22.
//

import SwiftUI

struct PlainOrFilledButtonStyle: ButtonStyle {
    var filled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(filled ? .clear : .primary)
            .padding(5)
            .background(
                Group {
                    if filled {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(Color(UIColor.secondarySystemFill))
                            .mask {
                                configuration.label
                            }
                    }
                }
            )
    }
}
