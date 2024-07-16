//
//  CustomTextField.swift
//  LogInObservation-End
//
//  Created by Paul Solt on 7/16/24.
//

import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    var placeholder: String
    var focus: LogInFocus // Focus of this UI element (Fixes tap area with additional padding)
    @FocusState var focusedField: LogInFocus?
    
    init(text: Binding<String>, placeholder: String, focus: LogInFocus, focusedField: LogInFocus? = nil) {
        self._text = text
        self.placeholder = placeholder
        self.focus = focus
        self.focusedField = focusedField
    }
    
    var body: some View {
        TextField(text: $text) {
            Text(placeholder)
        }
        .padding()
        .background(.background) // Dark mode support
        .clipShape(.rect(cornerRadius: 4))
        .autocorrectionDisabled()
        .onTapGesture {
            focusedField = focus    // Design Workaround: Tap the padding to activate the label
        }
        .submitLabel(.next)
        .focused($focusedField, equals: focus)
    }
}
