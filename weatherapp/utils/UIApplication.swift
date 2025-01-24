//
//  UIApplication.swift
//  weatherapp
//
//  Created by fin on 24/01/2025.
//

import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
