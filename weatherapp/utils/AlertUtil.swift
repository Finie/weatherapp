//
//  AlertUtil.swift
//  weatherapp
//
//  Created by fin on 24/01/2025.
//

import SwiftUI

struct AlertUtil {
    static func showAlert(message: String, isPresented: Binding<Bool>) -> Alert {
        Alert(
            title: Text("Error occurred‼️"),
            message: Text(message),
            dismissButton: .default(Text("OK"))
        )
    }
}
