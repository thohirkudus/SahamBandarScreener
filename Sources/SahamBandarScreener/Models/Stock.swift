import Foundation

public enum Sector: String, Codable, CaseIterable {
    case all = "Semua Sektor"
    case financials = "Financials"
    case energy = "Energy & Mining"
    case basicMaterials = "Basic Materials"
    case infrastructure = "Infrastructure & Telco"
    case consumer = "Consumer Goods"
    case technology = "Technology"
}

public struct Stock: Identifiable, Codable {
    public var id: String { ticker }
    public let ticker: String
    public let name: String
    public let sector: Sector
    public let currentPrice: Double
    public let previousClose: Double
    public let change: Double
    public let changePercent: Double
    public let dayHigh: Double
    public let dayLow: Double
    public let volumeLot: Double
    public let turnoverIDR: Double // Total transaction value in IDR
    public let marketCapIDR: Double
    
    // Core Screener Indicators
    public let bandarmology: BandarmologyData
    public let technical: TechnicalIndicatorData
    public let candles: [Candle]
    
    // Calculated Composite Rating
    public var confluenceScore: Int {
        // Base bandarmology weight 60%, Technical MACD momentum weight 40%
        var score = Double(bandarmology.bandarScore) * 0.6
        
        if technical.isGoldenCrossToday {
            score += 35.0
            if technical.isBelowZeroLine {
                score += 5.0 // Reversal bonus from oversold area
            }
        } else if let days = technical.daysSinceGoldenCross, days <= 3 {
            score += 25.0
        } else if technical.latestMACD > technical.latestSignal {
            score += 15.0
        }
        
        return min(100, max(0, Int(score)))
    }
    
    public var setupVerdict: String {
        if bandarmology.accumulationStatus == .bigAccumulation && technical.isGoldenCrossToday {
            return "🔥 ULTRA SETUP: Akumulasi Masif + Golden Cross Baru"
        } else if bandarmology.accumulationStatus.isAccumulation && technical.crossStatus.isGoldenCross {
            return "⭐ PRIME SETUP: Smart Money Inflow + MACD Terkonfirmasi"
        } else if bandarmology.accumulationStatus.isAccumulation {
            return "👀 ACCUMULATION: Bandar Masuk, Tunggu Cross Lanjut"
        } else if technical.crossStatus.isGoldenCross {
            return "📈 MOMENTUM: Golden Cross Tanpa Flow Bandar Masif"
        } else {
            return "⚖️ NETRAL / OBSERVASI"
        }
    }
    
    public init(
        ticker: String,
        name: String,
        sector: Sector,
        currentPrice: Double,
        previousClose: Double,
        change: Double,
        changePercent: Double,
        dayHigh: Double,
        dayLow: Double,
        volumeLot: Double,
        turnoverIDR: Double,
        marketCapIDR: Double,
        bandarmology: BandarmologyData,
        technical: TechnicalIndicatorData,
        candles: [Candle]
    ) {
        self.ticker = ticker
        self.name = name
        self.sector = sector
        self.currentPrice = currentPrice
        self.previousClose = previousClose
        self.change = change
        self.changePercent = changePercent
        self.dayHigh = dayHigh
        self.dayLow = dayLow
        self.volumeLot = volumeLot
        self.turnoverIDR = turnoverIDR
        self.marketCapIDR = marketCapIDR
        self.bandarmology = bandarmology
        self.technical = technical
        self.candles = candles
    }
}
