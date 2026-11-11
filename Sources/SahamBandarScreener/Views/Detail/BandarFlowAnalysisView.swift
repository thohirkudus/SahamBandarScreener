import SwiftUI
import Charts

public struct BandarFlowAnalysisView: View {
    public let stock: Stock
    
    public var body: some View {
        VStack(spacing: 16) {
            // Metrics Summary
            HStack(spacing: 10) {
                flowBox(
                    label: "Foreign Flow 1H",
                    value: stock.bandarmology.foreignFlow.netForeign1D.formattedIDRValue,
                    isPositive: stock.bandarmology.foreignFlow.isPositive1D
                )
                flowBox(
                    label: "Foreign Flow 5H",
                    value: stock.bandarmology.foreignFlow.netForeign5D.formattedIDRValue,
                    isPositive: stock.bandarmology.foreignFlow.isPositive5D
                )
                flowBox(
                    label: "Foreign Flow 20H",
                    value: stock.bandarmology.foreignFlow.netForeign20D.formattedIDRValue,
                    isPositive: stock.bandarmology.foreignFlow.netForeign20D > 0
                )
            }
            
            // 20-Day Foreign Inflow/Outflow Bar Chart
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Aliran Dana Asing (20 Hari Terakhir)")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.textPrimary)
                    Spacer()
                    Text("Partisipasi: \(Int(stock.bandarmology.foreignFlow.foreignParticipationRate * 100))%")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.foreignFlowCyan)
                }
                
                let recentCandles = Array(stock.candles.suffix(20))
                
                Chart {
                    RuleMark(y: .value("Zero", 0))
                        .lineStyle(StrokeStyle(lineWidth: 1))
                        .foregroundStyle(Color.textMuted.opacity(0.5))
                    
                    ForEach(recentCandles) { candle in
                        BarMark(
                            x: .value("Tanggal", candle.date),
                            y: .value("Net Foreign (IDR)", candle.foreignNetValue)
                        )
                        .foregroundStyle(candle.foreignNetValue >= 0 ? Color.foreignFlowCyan : Color.bandarRed)
                        .cornerRadius(3)
                    }
                }
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: 5)) { value in
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5)).foregroundStyle(Color.appBorder)
                        AxisValueLabel(format: .dateTime.day().month())
                            .foregroundStyle(Color.textMuted)
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .trailing, values: .automatic(desiredCount: 3)) { value in
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5)).foregroundStyle(Color.appBorder)
                        AxisValueLabel {
                            if let doubleVal = value.as(Double.self) {
                                Text(doubleVal.formattedIDRValue)
                                    .font(.system(size: 9))
                                    .foregroundColor(.textMuted)
                            }
                        }
                    }
                }
                .frame(height: 180)
                
                // Flow Interpretation Note
                HStack(spacing: 6) {
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 11))
                        .foregroundColor(.foreignFlowCyan)
                    Text(stock.bandarmology.foreignFlow.isConsistentInflow
                         ? "Akumulasi konsisten: Aliran dana asing positif baik di rentang 1 hari maupun 5 hari perdagangan."
                         : "Aliran dana fluktuatif: Perhatikan volume inflow lanjutan pada sesi berikutnya.")
                        .font(.system(size: 11))
                        .foregroundColor(.textSecondary)
                }
                .padding(.top, 4)
            }
            .padding(14)
            .background(Color.appCardBackground)
            .cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.appBorder, lineWidth: 1))
        }
    }
    
    private func flowBox(label: String, value: String, isPositive: Bool) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.textSecondary)
            Text(value)
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundColor(isPositive ? .foreignFlowCyan : .bandarRed)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(Color.appCardBackground)
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.appBorder, lineWidth: 1))
    }
}
