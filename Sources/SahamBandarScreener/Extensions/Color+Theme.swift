import SwiftUI

extension Color {
    // Background and Surface Themes
    static let appBackground = Color(red: 10/255, green: 14/255, blue: 23/255) // Deep Slate / Bloomberg Dark
    static let appCardBackground = Color(red: 18/255, green: 24/255, blue: 38/255)
    static let appCardSecondary = Color(red: 25/255, green: 33/255, blue: 50/255)
    static let appBorder = Color(red: 35/255, green: 46/255, blue: 68/255)
    
    // Financial Signal Indicators
    static let bandarGreen = Color(red: 16/255, green: 185/255, blue: 129/255) // Vibrant Emerald
    static let bandarGreenSoft = Color(red: 16/255, green: 185/255, blue: 129/255, opacity: 0.15)
    static let bandarRed = Color(red: 239/255, green: 68/255, blue: 68/255) // Vibrant Coral Red
    static let bandarRedSoft = Color(red: 239/255, green: 68/255, blue: 68/255, opacity: 0.15)
    
    // Golden Cross & Momentum
    static let goldenCrossGold = Color(red: 245/255, green: 158/255, blue: 11/255) // Rich Amber Gold
    static let goldenCrossGoldSoft = Color(red: 245/255, green: 158/255, blue: 11/255, opacity: 0.18)
    static let macdLineBlue = Color(red: 59/255, green: 130/255, blue: 246/255) // Electric Blue
    static let macdSignalOrange = Color(red: 249/255, green: 115/255, blue: 22/255) // Vivid Orange
    
    // Foreign Flow
    static let foreignFlowCyan = Color(red: 6/255, green: 182/255, blue: 212/255) // Cyan
    static let foreignFlowCyanSoft = Color(red: 6/255, green: 182/255, blue: 212/255, opacity: 0.18)
    
    // Text Accents
    static let textPrimary = Color.white
    static let textSecondary = Color(red: 148/255, green: 163/255, blue: 184/255) // Slate 400
    static let textMuted = Color(red: 100/255, green: 116/255, blue: 139/255) // Slate 500
}
