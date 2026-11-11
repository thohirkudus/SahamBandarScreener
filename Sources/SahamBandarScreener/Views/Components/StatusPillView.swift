import SwiftUI

public struct StatusPillView: View {
    public let text: String
    public let icon: String?
    public let foregroundColor: Color
    public let backgroundColor: Color
    public var isEmphasized: Bool = false
    
    public init(text: String, icon: String? = nil, foregroundColor: Color, backgroundColor: Color, isEmphasized: Bool = false) {
        self.text = text
        self.icon = icon
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.isEmphasized = isEmphasized
    }
    
    public var body: some View {
        HStack(spacing: 4) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: isEmphasized ? 11 : 9, weight: .bold))
            }
            Text(text)
                .font(.system(size: isEmphasized ? 11 : 10, weight: .semibold))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .foregroundColor(foregroundColor)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(foregroundColor.opacity(isEmphasized ? 0.6 : 0.25), lineWidth: 1)
                )
        )
    }
}

public struct MetricGaugeView: View {
    public let score: Int
    public let label: String
    
    public var scoreColor: Color {
        if score >= 85 {
            return .bandarGreen
        } else if score >= 70 {
            return .goldenCrossGold
        } else if score >= 50 {
            return .foreignFlowCyan
        } else {
            return .bandarRed
        }
    }
    
    public var body: some View {
        VStack(spacing: 2) {
            ZStack {
                Circle()
                    .stroke(Color.appCardSecondary, lineWidth: 4)
                    .frame(width: 44, height: 44)
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(Double(score) / 100.0, 1.0)))
                    .stroke(scoreColor, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .frame(width: 44, height: 44)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut, value: score)
                
                Text("\(score)")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(.textPrimary)
            }
            
            Text(label)
                .font(.system(size: 9, weight: .medium))
                .foregroundColor(.textSecondary)
        }
    }
}
