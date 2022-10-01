//
//  CustomProgressView.swift
//  DriverCompanion
//
//  Created by Derik Malcolm on 9/25/22.
//

import SwiftUI

struct CustomProgressViewStyle: ProgressViewStyle {
    @Binding var pressed: Bool
//    @GestureState private var translation: CGFloat = 0
    var translation: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0
//        let longPressGesture = LongPressGesture(minimumDuration: 0.01)
//            .onChanged { value in
//                withAnimation(.spring()) {
//                    pressed.toggle()
//                }
//            }
//        let dragGesture = DragGesture(minimumDistance: 0, coordinateSpace: .local)
//            .updating($translation, body: { value, state, _ in
//                withAnimation(.spring()) {
//                    state = value.translation.width
//                }
//            })
//            .onEnded { value in
//                withAnimation(.spring()) {
//                    pressed.toggle()
//                }
//            }
//        
//        let combined = longPressGesture.sequenced(before: dragGesture)
        
        return GeometryReader { geo in
            RoundedRectangle(cornerRadius: 10)
                .fill(.secondary.opacity(0.5))
                .overlay(alignment: .leading) {
                    Rectangle()
                        .fill(.primary)
                        .frame(width: max(geo.size.width * fractionCompleted + translation, 0))
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
//                .scaleEffect(pressed ? 1.1 : 1)
        }
        .frame(height: pressed ? 16 : 8)
//        .gesture(combined)
    }
}

struct CustomProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView(value: 1, total: 100)
            .progressViewStyle(CustomProgressViewStyle(pressed: .constant(false), translation: 0))
            .padding()
    }
}
