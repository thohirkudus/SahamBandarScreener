import SwiftUI

public struct ScreeningHeaderStatsView: View {
    public let primeSetupCount: Int
    public let totalInflowToday: Double
    public let goldenCrossCount: Int
    
    public var body: some View {
        HStack(spacing: 12) {
            // Prime Setup Box
            StatItemCard(
                title: "Prime Setup",
                value: "\(primeSetupCount) Saham",
                subtitle: "Bandar + MACD",
                icon: "flame.fill",
                accentColor: .goldenCrossGold
            )
            
            // Foreign Inflow Box
            StatItemCard(
                title: "Foreign Inflow",
                value: totalInflowToday.formattedIDRValue,
                subtitle: "Net Buy Hari Ini",
                icon: "arrow.up.right.circle.fill",
                accentColor: .foreignFlowCyan
            )
            
            // Golden Cross Box
            StatItemCard(
                title: "Golden Cross",
                value: "\(goldenCrossCount) Saham",
                subtitle: "Bullish Cross",
                icon: "bolt.fill",
                accentColor: .bandarGreen
            )
        }
        .padding(.horizontal)
    }
}

private struct StatItemCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let accentColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(accentColor)
                Text(title)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.textSecondary)
            }
            
            Text(value)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            
            Text(subtitle)
                .font(.system(size: 9, weight: .regular))
                .foregroundColor(.textMuted)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.appCardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.appBorder, lineWidth: 1)
                )
        )
    }
}
