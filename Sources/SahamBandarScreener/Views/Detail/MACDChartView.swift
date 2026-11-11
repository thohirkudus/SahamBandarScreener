import SwiftUI
import Charts

public struct MACDChartView: View {
    public let stock: Stock
    @State private var selectedDate: Date? = nil
    
    public var selectedCandle: Candle? {
        guard let selectedDate = selectedDate else { return nil }
        return stock.candles.min(by: { abs($0.date.timeIntervalSince(selectedDate)) < abs($1.date.timeIntervalSince(selectedDate)) })
    }
    
    public var selectedMACD: MACDPoint? {
        guard let selectedDate = selectedDate else { return nil }
        return stock.technical.macdPoints.min(by: { abs($0.date.timeIntervalSince(selectedDate)) < abs($1.date.timeIntervalSince(selectedDate)) })
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            // Price Chart with iOS 17 Interactive Touch Scrubbing
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Pergerakan Harga (Daily)")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.textPrimary)
                        
                        if let candle = selectedCandle {
                            Text("Tgl \(candle.date.shortDateString): \(candle.close.formattedStockPrice)")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.goldenCrossGold)
                        } else {
                            Text("Sentuh & geser chart untuk inspeksi")
                                .font(.system(size: 10))
                                .foregroundColor(.textMuted)
                        }
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color.goldenCrossGold)
                            .frame(width: 6, height: 6)
                        Text("Bandar Avg: \(stock.bandarmology.bandarAvgPrice.formattedStockPrice)")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.goldenCrossGold)
                    }
                }
                
                Chart {
                    ForEach(stock.candles) { candle in
                        LineMark(
                            x: .value("Tanggal", candle.date),
                            y: .value("Harga", candle.close)
                        )
                        .foregroundStyle(Color.macdLineBlue)
                        .interpolationMethod(.catmullRom)
                        
                        AreaMark(
                            x: .value("Tanggal", candle.date),
                            yStart: .value("Min", minPrice(candles: stock.candles) * 0.98),
                            yEnd: .value("Harga", candle.close)
                        )
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.macdLineBlue.opacity(0.3), Color.macdLineBlue.opacity(0.0)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    }
                    
                    // Bandar Avg Cost Reference Line
                    RuleMark(y: .value("Bandar Avg", stock.bandarmology.bandarAvgPrice))
                        .lineStyle(StrokeStyle(lineWidth: 1.5, dash: [4, 4]))
                        .foregroundStyle(Color.goldenCrossGold)
                    
                    // iOS 17 Touch Crosshair Rule Mark
                    if let selectedDate = selectedDate {
                        RuleMark(x: .value("Selected", selectedDate))
                            .lineStyle(StrokeStyle(lineWidth: 1, dash: [2, 2]))
                            .foregroundStyle(Color.white.opacity(0.7))
                    }
                }
                .chartXSelection(value: $selectedDate)
                .chartYScale(domain: (minPrice(candles: stock.candles) * 0.97)...(maxPrice(candles: stock.candles) * 1.03))
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: 5)) { value in
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5)).foregroundStyle(Color.appBorder)
                        AxisValueLabel(format: .dateTime.day().month())
                            .foregroundStyle(Color.textMuted)
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .trailing, values: .automatic(desiredCount: 4)) { value in
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5)).foregroundStyle(Color.appBorder)
                        AxisValueLabel()
                            .foregroundStyle(Color.textMuted)
                    }
                }
                .frame(height: 160)
            }
            .padding(12)
            .background(Color.appCardBackground)
            .cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.appBorder, lineWidth: 1))
            
            // Dedicated MACD Subchart with iOS 17 Synchronized Touch Selection
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("MACD (12, 26, 9)")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.textPrimary)
                        
                        if let m = selectedMACD {
                            Text("MACD: \(String(format: "%.1f", m.macd)) | Signal: \(String(format: "%.1f", m.signal)) | Hist: \(String(format: "%.1f", m.histogram))")
                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                                .foregroundColor(m.histogram >= 0 ? .bandarGreen : .bandarRed)
                        }
                    }
                    
                    Spacer()
                    
                    // Legend
                    HStack(spacing: 8) {
                        HStack(spacing: 2) {
                            RoundedRectangle(cornerRadius: 1).fill(Color.macdLineBlue).frame(width: 10, height: 2)
                            Text("MACD").font(.system(size: 9)).foregroundColor(.textSecondary)
                        }
                        HStack(spacing: 2) {
                            RoundedRectangle(cornerRadius: 1).fill(Color.macdSignalOrange).frame(width: 10, height: 2)
                            Text("Signal").font(.system(size: 9)).foregroundColor(.textSecondary)
                        }
                        HStack(spacing: 2) {
                            RoundedRectangle(cornerRadius: 1).fill(Color.bandarGreen).frame(width: 5, height: 5)
                            Text("Hist").font(.system(size: 9)).foregroundColor(.textSecondary)
                        }
                    }
                }
                
                Chart {
                    // Zero Baseline
                    RuleMark(y: .value("Zero", 0))
                        .lineStyle(StrokeStyle(lineWidth: 1))
                        .foregroundStyle(Color.textMuted.opacity(0.5))
                    
                    // Histogram Bars
                    ForEach(stock.technical.macdPoints) { point in
                        BarMark(
                            x: .value("Tanggal", point.date),
                            y: .value("Histogram", point.histogram)
                        )
                        .foregroundStyle(point.histogram >= 0 ? Color.bandarGreen.opacity(0.7) : Color.bandarRed.opacity(0.7))
                    }
                    
                    // MACD Line
                    ForEach(stock.technical.macdPoints) { point in
                        LineMark(
                            x: .value("Tanggal", point.date),
                            y: .value("MACD", point.macd)
                        )
                        .foregroundStyle(Color.macdLineBlue)
                        .lineStyle(StrokeStyle(lineWidth: 2))
                    }
                    
                    // Signal Line
                    ForEach(stock.technical.macdPoints) { point in
                        LineMark(
                            x: .value("Tanggal", point.date),
                            y: .value("Signal", point.signal)
                        )
                        .foregroundStyle(Color.macdSignalOrange)
                        .lineStyle(StrokeStyle(lineWidth: 2))
                    }
                    
                    if let selectedDate = selectedDate {
                        RuleMark(x: .value("Selected", selectedDate))
                            .lineStyle(StrokeStyle(lineWidth: 1, dash: [2, 2]))
                            .foregroundStyle(Color.white.opacity(0.7))
                    }
                }
                .chartXSelection(value: $selectedDate)
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
                        AxisValueLabel()
                            .foregroundStyle(Color.textMuted)
                    }
                }
                .frame(height: 140)
            }
            .padding(12)
            .background(Color.appCardBackground)
            .cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.appBorder, lineWidth: 1))
        }
    }
    
    private func minPrice(candles: [Candle]) -> Double {
        candles.map { $0.low }.min() ?? stock.currentPrice * 0.95
    }
    
    private func maxPrice(candles: [Candle]) -> Double {
        candles.map { $0.high }.max() ?? stock.currentPrice * 1.05
    }
}
