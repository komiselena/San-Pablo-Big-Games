//
//  OutlinedText.swift
//  San Pablo big games
//
//  Created by Mac on 22.05.2025.
//
import SwiftUI

struct OutlinedText: ViewModifier {
    let outlineWidth: CGFloat
    let outlineColor: Color
    
    func body(content: Content) -> some View {
        ZStack {
            // Белая обводка (рисуем текст 4 раза со смещением)
            content
                .foregroundColor(outlineColor)
                .shadow(color: outlineColor, radius: 0, x: -outlineWidth, y: 0)
                .shadow(color: outlineColor, radius: 0, x: outlineWidth, y: 0)
                .shadow(color: outlineColor, radius: 0, x: 0, y: -outlineWidth)
                .shadow(color: outlineColor, radius: 0, x: 0, y: outlineWidth)
            
            // Основной текст
            content
                .foregroundColor(.brown3)
        }
    }
}

// Extension для удобного использования
extension View {
    func brownOutlinedText(outlineWidth: CGFloat = 1, outlineColor: Color = .white) -> some View {
        self.modifier(OutlinedText(outlineWidth: outlineWidth, outlineColor: outlineColor))
    }
}
