import SwiftUI

public struct StockRowCardView: View {
    public let stock: Stock
    public let isWatchlisted: Bool
    public let onWatchlistTapped: () -> Void
    
    public var body: some View {
        VStack(spacing: 10) {
            // Top Row: Ticker, Name, Price, and Score Gauge
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(stock.ticker)
                            .font(.system(size: 18, weight: .black, design: .rounded))
                            .foregroundColor(.textPrimary)
                        
                        Text(stock.sector.rawValue)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.textSecondary)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.appCardSecondary)
                            .cornerRadius(4)
                    }
                    
                    Text(stock.name)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.textSecondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                // Price & Percentage
                VStack(alignment: .trailing, spacing: 2) {
                    Text(stock.currentPrice.formattedStockPrice)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.textPrimary)
                    
                    HStack(spacing: 2) {
                        Image(systemName: stock.change >= 0 ? "arrow.up.right" : "arrow.down.right")
                            .font(.system(size: 10, weight: .bold))
                        Text(stock.changePercent.formattedPercentChange)
                            .font(.system(size: 12, weight: .bold))
                    }
                    .foregroundColor(stock.change >= 0 ? .bandarGreen : .bandarRed)
                }
                
                // Confluence Score Radial Gauge
                MetricGaugeView(score: stock.confluenceScore, label: "Skor Setup")
                    .padding(.leading, 6)
            }
            
            Divider()
                .background(Color.appBorder)
            
            // Middle Row: Dual Signal Badges (Bandarmology + MACD)
            HStack(spacing: 8) {
                // Bandar Accumulation Pill
                if stock.bandarmology.accumulationStatus == .bigAccumulation {
                    StatusPillView(
                        text: stock.bandarmology.accumulationStatus.shortLabel,
                        icon: "crown.fill",
                        foregroundColor: .bandarGreen,
                        backgroundColor: .bandarGreenSoft,
                        isEmphasized: true
                    )
                } else if stock.bandarmology.accumulationStatus.isAccumulation {
                    StatusPillView(
                        text: stock.bandarmology.accumulationStatus.shortLabel,
                        icon: "chart.line.uptrend.xyaxis",
                        foregroundColor: .bandarGreen,
                        backgroundColor: .bandarGreenSoft
                    )
                } else {
                    StatusPillView(
                        text: stock.bandarmology.accumulationStatus.shortLabel,
                        icon: "arrow.left.arrow.right",
                        foregroundColor: .textMuted,
                        backgroundColor: Color.appCardSecondary
                    )
                }
                
                // MACD Golden Cross Pill
                if stock.technical.isGoldenCrossToday {
                    StatusPillView(
                        text: "⚡ GOLDEN CROSS (Hari Ini)",
                        icon: "bolt.fill",
                        foregroundColor: .goldenCrossGold,
                        backgroundColor: .goldenCrossGoldSoft,
                        isEmphasized: true
                    )
                } else if stock.technical.crossStatus.isGoldenCross {
                    StatusPillView(
                        text: stock.technical.crossStatus.title,
                        icon: "checkmark.seal.fill",
                        foregroundColor: .goldenCrossGold,
                        backgroundColor: .goldenCrossGoldSoft
                    )
                } else {
                    StatusPillView(
                        text: stock.technical.crossStatus.title,
                        icon: "waveform.path",
                        foregroundColor: .textMuted,
                        backgroundColor: Color.appCardSecondary
                    )
                }
                
                Spacer()
                
                // Watchlist Toggle Button
                Button(action: onWatchlistTapped) {
                    Image(systemName: isWatchlisted ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 14))
                        .foregroundColor(isWatchlisted ? .goldenCrossGold : .textMuted)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            
            // Bottom Row: Foreign Flow + Top Broker Concentration
            HStack(spacing: 12) {
                // Foreign Flow
                HStack(spacing: 4) {
                    Image(systemName: "globe.asia.australia.fill")
                        .font(.system(size: 11))
                        .foregroundColor(.foreignFlowCyan)
                    
                    Text("Foreign:")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.textMuted)
                    
                    Text(stock.bandarmology.foreignFlow.netForeign1D.formattedIDRValue)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(stock.bandarmology.foreignFlow.isPositive1D ? .foreignFlowCyan : .bandarRed)
                }
                
                // Broker Concentration CR3
                HStack(spacing: 4) {
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.goldenCrossGold)
                    
                    Text("CR3:")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.textMuted)
                    
                    Text("\(Int(stock.bandarmology.brokerSummary.cr3 * 100))%")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.textPrimary)
                    
                    // Top 3 broker codes
                    let topCodes = stock.bandarmology.brokerSummary.topBuyers.prefix(3).map { $0.code }.joined(separator: ",")
                    Text("(\(topCodes))")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.appCardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(
                            stock.confluenceScore >= 90 ? Color.goldenCrossGold.opacity(0.4) : Color.appBorder,
                            lineWidth: stock.confluenceScore >= 90 ? 1.5 : 1
                        )
                )
        )
    }
}
