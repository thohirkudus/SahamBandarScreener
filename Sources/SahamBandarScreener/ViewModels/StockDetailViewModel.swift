import SwiftUI
import Observation

@Observable
@MainActor
public final class StockDetailViewModel {
    public var stock: Stock
    public var selectedChartTab: ChartTab = .macdCombo
    
    public enum ChartTab: String, CaseIterable, Identifiable {
        case macdCombo = "MACD & Harga"
        case bandarFlow = "Foreign Flow (20H)"
        case brokerSummary = "Top 5 Broker"
        
        public var id: String { rawValue }
    }
    
    public init(stock: Stock) {
        self.stock = stock
    }
    
    /// Confluence checklist items for this stock
    public var analysisChecklist: [(title: String, passed: Bool, detail: String)] {
        var items: [(title: String, passed: Bool, detail: String)] = []
        
        // 1. Akumulasi Bandar
        let isAccum = stock.bandarmology.accumulationStatus.isAccumulation
        items.append((
            title: "Akumulasi Bandar / Smart Money",
            passed: isAccum,
            detail: isAccum
                ? "\(stock.bandarmology.accumulationStatus.rawValue) dengan CR3 \(Int(stock.bandarmology.brokerSummary.cr3 * 100))% dominasi pembeli institusi."
                : "Saham dalam fase \(stock.bandarmology.accumulationStatus.rawValue), belum ada konsentrasi akumulasi."
        ))
        
        // 2. Foreign Flow 1D & 5D
        let isForeignPos = stock.bandarmology.foreignFlow.isPositive1D
        items.append((
            title: "Foreign Flow Positif (Net Foreign Buy)",
            passed: isForeignPos,
            detail: isForeignPos
                ? "Asing net buy \(stock.bandarmology.foreignFlow.netForeign1D.formattedIDRValue) hari ini (5H: \(stock.bandarmology.foreignFlow.netForeign5D.formattedIDRValue))."
                : "Investor asing tercatat net sell hari ini (\(stock.bandarmology.foreignFlow.netForeign1D.formattedIDRValue))."
        ))
        
        // 3. MACD Golden Cross
        let isGC = stock.technical.crossStatus.isGoldenCross
        items.append((
            title: "Indikator MACD Golden Cross",
            passed: isGC,
            detail: stock.technical.isGoldenCrossToday
                ? "⚡ Fresh Golden Cross hari ini! Garis MACD baru menembus Signal Line."
                : (isGC ? "Golden Cross aktif (\(stock.technical.crossStatus.title)), momentum bullish berlanjut." : "MACD belum Golden Cross (Histogram: \(String(format: "%.2f", stock.technical.latestHistogram))).")
        ))
        
        // 4. Area Cross (Bawah Nol)
        let isOversold = stock.technical.isBelowZeroLine
        items.append((
            title: "Golden Cross di Area Bawah Nol (Reversal)",
            passed: isOversold,
            detail: isOversold
                ? "Setup reversal ideal! Cross terjadi di zona oversold dengan potensi ruang kenaikan luas."
                : "Cross terjadi di atas garis nol (trend continuation momentum)."
        ))
        
        return items
    }
}
