import Foundation

public enum AccumulationStatus: String, Codable, CaseIterable {
    case bigAccumulation = "Big Accumulation"
    case normalAccumulation = "Accumulation"
    case neutral = "Neutral"
    case normalDistribution = "Distribution"
    case bigDistribution = "Big Distribution"
    
    public var shortLabel: String {
        switch self {
        case .bigAccumulation: return "BIG ACCUM"
        case .normalAccumulation: return "ACCUM"
        case .neutral: return "NETRAL"
        case .normalDistribution: return "DISTRIBUSI"
        case .bigDistribution: return "BIG DIST"
        }
    }
    
    public var priorityScore: Int {
        switch self {
        case .bigAccumulation: return 5
        case .normalAccumulation: return 4
        case .neutral: return 3
        case .normalDistribution: return 2
        case .bigDistribution: return 1
        }
    }
    
    public var isAccumulation: Bool {
        return self == .bigAccumulation || self == .normalAccumulation
    }
}

public struct BrokerDetail: Identifiable, Codable {
    public var id: UUID = UUID()
    public let code: String          // e.g. "ZP", "BK", "AK", "YP", "PD"
    public let name: String          // e.g. "Maybank", "JPMorgan", "Mirae"
    public let netValue: Double      // Value in IDR (+ for buy, - for sell)
    public let avgPrice: Double      // Average price of accumulation / distribution
    public let isForeign: Bool       // True if foreign institutional broker
    
    public init(id: UUID = UUID(), code: String, name: String, netValue: Double, avgPrice: Double, isForeign: Bool) {
        self.id = id
        self.code = code
        self.name = name
        self.netValue = netValue
        self.avgPrice = avgPrice
        self.isForeign = isForeign
    }
}

public struct BrokerSummaryData: Codable {
    public let topBuyers: [BrokerDetail]
    public let topSellers: [BrokerDetail]
    public let cr3: Double           // Concentration Ratio of Top 3 (0.0 to 1.0)
    public let cr5: Double           // Concentration Ratio of Top 5 (0.0 to 1.0)
    public let buyerSellerDiff: Double // Net value spread between top buyers and sellers
    public let dominantBuyerSide: String // e.g. "Foreign Institutions" or "Domestic Smart Money"
    
    public init(topBuyers: [BrokerDetail], topSellers: [BrokerDetail], cr3: Double, cr5: Double, buyerSellerDiff: Double, dominantBuyerSide: String) {
        self.topBuyers = topBuyers
        self.topSellers = topSellers
        self.cr3 = cr3
        self.cr5 = cr5
        self.buyerSellerDiff = buyerSellerDiff
        self.dominantBuyerSide = dominantBuyerSide
    }
}

public struct ForeignFlowSummary: Codable {
    public let netForeign1D: Double  // Today's Net Foreign Flow in IDR
    public let netForeign5D: Double  // 5-Day Cumulative Net Foreign Flow
    public let netForeign20D: Double // 20-Day Cumulative Net Foreign Flow
    public let foreignParticipationRate: Double // e.g. 0.42 = 42% of volume is foreign
    
    public var isPositive1D: Bool { netForeign1D > 0 }
    public var isPositive5D: Bool { netForeign5D > 0 }
    public var isConsistentInflow: Bool { netForeign1D > 0 && netForeign5D > 0 }
    
    public init(netForeign1D: Double, netForeign5D: Double, netForeign20D: Double, foreignParticipationRate: Double) {
        self.netForeign1D = netForeign1D
        self.netForeign5D = netForeign5D
        self.netForeign20D = netForeign20D
        self.foreignParticipationRate = foreignParticipationRate
    }
}

public struct BandarmologyData: Codable {
    public let accumulationStatus: AccumulationStatus
    public let foreignFlow: ForeignFlowSummary
    public let brokerSummary: BrokerSummaryData
    public let bandarScore: Int // 0 to 100 based on CR3, Foreign Flow, and buyer/seller spread
    public let bandarPhase: String // "Akumulasi Senyap", "Mark-Up / Breakout", "Distribusi", "Mark-Down"
    public let bandarAvgPrice: Double // Estimated average cost of Bandar / Smart Money
    
    public init(accumulationStatus: AccumulationStatus, foreignFlow: ForeignFlowSummary, brokerSummary: BrokerSummaryData, bandarScore: Int, bandarPhase: String, bandarAvgPrice: Double) {
        self.accumulationStatus = accumulationStatus
        self.foreignFlow = foreignFlow
        self.brokerSummary = brokerSummary
        self.bandarScore = bandarScore
        self.bandarPhase = bandarPhase
        self.bandarAvgPrice = bandarAvgPrice
    }
}
