import Foundation

public enum FilterPreset: String, CaseIterable, Identifiable {
    case superConfluence = "🔥 Bandar + MACD Cross"
    case freshGoldenCross = "⚡ Golden Cross Hari Ini"
    case bigForeignFlow = "💰 Big Foreign Inflow"
    case oversoldReversal = "🎯 Cross Bawah Nol"
    case allAccumulation = "📊 Semua Akumulasi"
    
    public var id: String { rawValue }
    
    public var description: String {
        switch self {
        case .superConfluence:
            return "Saham dengan akumulasi bandar/asing positif & konfirmasi MACD Golden Cross."
        case .freshGoldenCross:
            return "Garis MACD baru saja menembus Signal line hari ini dengan volume flow positif."
        case .bigForeignFlow:
            return "Arus modal investor asing (Foreign Net Buy) masif > Rp 25 Miliar."
        case .oversoldReversal:
            return "Golden Cross terbentuk di bawah garis nol (area oversold) untuk peluang swing reversal."
        case .allAccumulation:
            return "Semua saham yang terdeteksi dalam status Big Accumulation atau Normal Accumulation."
        }
    }
}

public enum MarketCapTier: String, CaseIterable, Identifiable {
    case all = "Semua Market Cap"
    case bigCap = "Big Cap (> Rp 50 T)"
    case midCap = "Mid Cap (Rp 10 T - 50 T)"
    case smallCap = "Small Cap (< Rp 10 T)"
    
    public var id: String { rawValue }
}

public enum SortOption: String, CaseIterable, Identifiable {
    case confluenceScore = "Skor Confluence Tertinggi"
    case foreignFlow1D = "Foreign Inflow Hari Ini (Tertinggi)"
    case foreignFlow5D = "Foreign Inflow 5 Hari (Tertinggi)"
    case bandarScore = "Skor Akumulasi Bandar"
    case percentChange = "Kenaikan Harga (%)"
    
    public var id: String { rawValue }
}

public struct ScreeningFilter {
    public var selectedPreset: FilterPreset = .superConfluence
    public var selectedSector: Sector = .all
    public var selectedMarketCap: MarketCapTier = .all
    public var requireForeignPositive1D: Bool = true
    public var requireForeignPositive5D: Bool = false
    public var requireGoldenCross: Bool = true
    public var maxDaysSinceCross: Int = 3
    public var onlyBelowZeroCross: Bool = false
    public var minBandarScore: Int = 60
    public var sortBy: SortOption = .confluenceScore
    public var searchQuery: String = ""
    
    public init() {}
    
    /// Applies the filtering logic to a list of stocks
    public func apply(to stocks: [Stock]) -> [Stock] {
        return stocks.filter { stock in
            // Search text filter
            if !searchQuery.isEmpty {
                let query = searchQuery.lowercased()
                let matchesTicker = stock.ticker.lowercased().contains(query)
                let matchesName = stock.name.lowercased().contains(query)
                if !matchesTicker && !matchesName { return false }
            }
            
            // Sector filter
            if selectedSector != .all && stock.sector != selectedSector {
                return false
            }
            
            // Market cap filter
            switch selectedMarketCap {
            case .bigCap:
                if stock.marketCapIDR < 50_000_000_000_000 { return false }
            case .midCap:
                if stock.marketCapIDR < 10_000_000_000_000 || stock.marketCapIDR >= 50_000_000_000_000 { return false }
            case .smallCap:
                if stock.marketCapIDR >= 10_000_000_000_000 { return false }
            case .all:
                break
            }
            
            // Preset rules
            switch selectedPreset {
            case .superConfluence:
                let isAccum = stock.bandarmology.accumulationStatus.isAccumulation
                let isForeignFlowGood = stock.bandarmology.foreignFlow.isPositive1D || stock.bandarmology.foreignFlow.isPositive5D
                let hasCross = stock.technical.crossStatus.isGoldenCross
                return isAccum && isForeignFlowGood && hasCross
                
            case .freshGoldenCross:
                let isFresh = stock.technical.isGoldenCrossToday
                let flowPositive = stock.bandarmology.foreignFlow.isPositive1D
                return isFresh && flowPositive
                
            case .bigForeignFlow:
                return stock.bandarmology.foreignFlow.netForeign1D >= 25_000_000_000
                
            case .oversoldReversal:
                return stock.technical.crossStatus.isGoldenCross && stock.technical.isBelowZeroLine
                
            case .allAccumulation:
                return stock.bandarmology.accumulationStatus.isAccumulation
            }
        }.sorted { (s1: Stock, s2: Stock) -> Bool in
            switch sortBy {
            case .confluenceScore:
                return s1.confluenceScore > s2.confluenceScore
            case .foreignFlow1D:
                return s1.bandarmology.foreignFlow.netForeign1D > s2.bandarmology.foreignFlow.netForeign1D
            case .foreignFlow5D:
                return s1.bandarmology.foreignFlow.netForeign5D > s2.bandarmology.foreignFlow.netForeign5D
            case .bandarScore:
                return s1.bandarmology.bandarScore > s2.bandarmology.bandarScore
            case .percentChange:
                return s1.changePercent > s2.changePercent
            }
        }
    }
}
