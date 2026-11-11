import Foundation

public struct Candle: Identifiable, Codable {
    public var id: UUID = UUID()
    public let date: Date
    public let open: Double
    public let high: Double
    public let low: Double
    public let close: Double
    public let volume: Double
    public let foreignNetValue: Double // IDR Net Foreign buy (+), sell (-)
    
    public init(id: UUID = UUID(), date: Date, open: Double, high: Double, low: Double, close: Double, volume: Double, foreignNetValue: Double) {
        self.id = id
        self.date = date
        self.open = open
        self.high = high
        self.low = low
        self.close = close
        self.volume = volume
        self.foreignNetValue = foreignNetValue
    }
}

public struct MACDPoint: Identifiable, Codable {
    public var id: UUID = UUID()
    public let date: Date
    public let macd: Double
    public let signal: Double
    public let histogram: Double
    
    public init(id: UUID = UUID(), date: Date, macd: Double, signal: Double, histogram: Double) {
        self.id = id
        self.date = date
        self.macd = macd
        self.signal = signal
        self.histogram = histogram
    }
}

public enum MACDCrossStatus: Equatable, Hashable {
    case goldenCrossToday
    case goldenCrossRecent(daysAgo: Int)
    case bullishMomentum
    case deathCrossToday
    case deathCrossRecent(daysAgo: Int)
    case bearishMomentum
    
    public var title: String {
        switch self {
        case .goldenCrossToday:
            return "GOLDEN CROSS (Hari Ini)"
        case .goldenCrossRecent(let days):
            return "GOLDEN CROSS (\(days)H Lalu)"
        case .bullishMomentum:
            return "MACD Bullish"
        case .deathCrossToday:
            return "DEATH CROSS (Hari Ini)"
        case .deathCrossRecent(let days):
            return "DEATH CROSS (\(days)H Lalu)"
        case .bearishMomentum:
            return "MACD Bearish"
        }
    }
    
    public var isGoldenCross: Bool {
        switch self {
        case .goldenCrossToday, .goldenCrossRecent:
            return true
        default:
            return false
        }
    }
    
    public var badgeColorName: String {
        switch self {
        case .goldenCrossToday:
            return "gold"
        case .goldenCrossRecent, .bullishMomentum:
            return "green"
        case .deathCrossToday, .deathCrossRecent, .bearishMomentum:
            return "red"
        }
    }
}

public struct TechnicalIndicatorData: Identifiable, Codable {
    public var id: UUID = UUID()
    public let macdPoints: [MACDPoint]
    public let latestMACD: Double
    public let latestSignal: Double
    public let latestHistogram: Double
    public let isGoldenCrossToday: Bool
    public let daysSinceGoldenCross: Int? // 0 = today, 1 = 1 day ago, nil if none in lookback
    public let isBelowZeroLine: Bool // Golden cross below zero line (strong reversal setup)
    public let rsi14: Double
    public let ma20: Double
    public let ma50: Double
    
    public var crossStatus: MACDCrossStatus {
        if isGoldenCrossToday {
            return .goldenCrossToday
        } else if let days = daysSinceGoldenCross, days <= 5 {
            return .goldenCrossRecent(daysAgo: days)
        } else if latestMACD > latestSignal {
            return .bullishMomentum
        } else if latestMACD < latestSignal && latestHistogram < 0 {
            return .bearishMomentum
        } else {
            return .bearishMomentum
        }
    }
}
