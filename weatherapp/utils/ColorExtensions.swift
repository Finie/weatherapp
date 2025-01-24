//
//  ColorExtensions.swift
//  weatherapp
//
//  Created by fin on 24/01/2025.
//

// ColorExtensions.swift
import SwiftUI

extension Color {
    init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }
        
        var hexNumber: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&hexNumber)
        
        let red = Double((hexNumber & 0xFF0000) >> 16) / 255.0
        let green = Double((hexNumber & 0x00FF00) >> 8) / 255.0
        let blue = Double(hexNumber & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }

    // Predefined colors as static properties for reusability
    static let sunny = Color(hex: "47AB2F")
    static let cloudy = Color(hex: "54717A")
    static let rainy = Color(hex: "57575D")
}
