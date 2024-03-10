//
//  ClearTextFieldButton.swift
//  iOSTodoListThesis
//
//  Created by David Mansourian on 2024-02-29.
//

import Foundation
import SwiftUI

struct ClearTextFieldButton: ViewModifier {
    @Binding var text: String
    var color: Color
    
    func body(content: Content) -> some View {
        HStack {
            content
            !text.isEmpty ? clearButton : nil
        }
    }
}

extension ClearTextFieldButton {
    private var clearButton: some View {
        Button(action: {text = ""}, label: {
            Image(systemName: "multiply.circle")
        })
        .padding(.trailing, 10)
        .font(.footnote)
        .foregroundStyle(color)
    }
}

extension View {
    func clearTextFieldButton(text: Binding<String>, color: Color) -> some View {
        modifier(ClearTextFieldButton(text: text, color: color))
    }
}
