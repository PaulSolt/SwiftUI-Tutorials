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
    var focus: LogInFocus // Focus of this UI element
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
        .autocorrectionDisabled()
        .padding()
        .background(.background) // Dark mode support
        .clipShape(.rect(cornerRadius: 4))
        .onTapGesture {
            focusedField = focus
        }
//        .focused($focusedField, equals: focus) // FIXME: Next button fails to advance between fields
    }
}
