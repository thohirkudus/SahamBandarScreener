import SwiftUI

public struct BrokerSummaryView: View {
    public let stock: Stock
    
    public var body: some View {
        VStack(spacing: 14) {
            // Concentration Ratio & Spread Header
            HStack(spacing: 10) {
                concentrationCard(
                    title: "CR3 (Top 3)",
                    value: "\(Int(stock.bandarmology.brokerSummary.cr3 * 100))%",
                    subtitle: "Dominasi Pembeli",
                    accent: .goldenCrossGold
                )
                concentrationCard(
                    title: "CR5 (Top 5)",
                    value: "\(Int(stock.bandarmology.brokerSummary.cr5 * 100))%",
                    subtitle: "Konsentrasi Pasar",
                    accent: .bandarGreen
                )
                concentrationCard(
                    title: "Net Spread",
                    value: stock.bandarmology.brokerSummary.buyerSellerDiff.formattedIDRValue,
                    subtitle: "Buyer vs Seller",
                    accent: stock.bandarmology.brokerSummary.buyerSellerDiff >= 0 ? .bandarGreen : .bandarRed
                )
            }
            
            // Broker Comparison Tables
            HStack(alignment: .top, spacing: 10) {
                // Top Buyers Column
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "arrow.down.right.circle.fill")
                            .foregroundColor(.bandarGreen)
                        Text("Top 5 Buyer")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.textPrimary)
                    }
                    
                    ForEach(stock.bandarmology.brokerSummary.topBuyers) { broker in
                        brokerRow(broker: broker, isBuyer: true)
                    }
                }
                .padding(10)
                .background(Color.appCardBackground)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.appBorder, lineWidth: 1))
                
                // Top Sellers Column
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "arrow.up.right.circle.fill")
                            .foregroundColor(.bandarRed)
                        Text("Top 5 Seller")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.textPrimary)
                    }
                    
                    ForEach(stock.bandarmology.brokerSummary.topSellers) { broker in
                        brokerRow(broker: broker, isBuyer: false)
                    }
                }
                .padding(10)
                .background(Color.appCardBackground)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.appBorder, lineWidth: 1))
            }
            
            // Dominant Side Callout
            HStack(spacing: 8) {
                Image(systemName: "shield.lefthalf.filled")
                    .foregroundColor(.goldenCrossGold)
                Text("Profil Pembeli Terbesar: \(stock.bandarmology.brokerSummary.dominantBuyerSide)")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.textPrimary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(10)
            .background(Color.appCardSecondary)
            .cornerRadius(8)
        }
    }
    
    private func brokerRow(broker: BrokerDetail, isBuyer: Bool) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(broker.code)
                    .font(.system(size: 12, weight: .black, design: .monospaced))
                    .foregroundColor(.textPrimary)
                
                if broker.isForeign {
                    Text("F")
                        .font(.system(size: 8, weight: .black))
                        .foregroundColor(.appBackground)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 1)
                        .background(Color.foreignFlowCyan)
                        .cornerRadius(3)
                }
                
                Spacer()
                
                Text(broker.netValue.formattedIDRValue)
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundColor(isBuyer ? .bandarGreen : .bandarRed)
            }
            
            HStack {
                Text(broker.name)
                    .font(.system(size: 9))
                    .foregroundColor(.textMuted)
                    .lineLimit(1)
                
                Spacer()
                
                Text("@\(Int(broker.avgPrice))")
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(.textSecondary)
            }
        }
        .padding(.vertical, 3)
    }
    
    private func concentrationCard(title: String, value: String, subtitle: String, accent: Color) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.textSecondary)
            Text(value)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(accent)
            Text(subtitle)
                .font(.system(size: 8))
                .foregroundColor(.textMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8)
        .background(Color.appCardBackground)
        .cornerRadius(8)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.appBorder, lineWidth: 1))
    }
}
