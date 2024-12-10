//
//  ColorExtension.swift
//  FetchRecipeApp
//
//  Created by Tinghe Guo on 12/9/24.
//

import SwiftUI

extension Color {
    // hex reader
    init(hex: String) {
        var sanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if sanitized.hasPrefix("#") {
            sanitized.removeFirst()
        }
        var rgbValue: UInt64 = 0xFFFFFF
        Scanner(string: sanitized).scanHexInt64(&rgbValue)
        
        let red   = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue  = Double((rgbValue & 0x0000FF)      ) / 255.0
        self = Color(red: red, green: green, blue: blue)
    }
    
    // hex colors
    static let lightGreen = Color(hex: "#f3f7f2")
    static let fetchOrange = Color(hex: "#f9b456")
    static let lightGray = Color(hex: "#f2f2f7")
    static let CardColor4 = Color(hex: "#dce3d2")
    static let CardColor2 = Color(hex: "#f5f3e7")
    static let CardColor1 = Color(hex: "#f7e6d5")
    static let CardColor5 = Color(hex: "#e6ebf0")
    static let CardColor3 = Color(hex: "#ece2f0")
}
