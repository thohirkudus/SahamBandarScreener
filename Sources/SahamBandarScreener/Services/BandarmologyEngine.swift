import Foundation

/// Bandarmology Analysis Engine for Indonesian Market (IDX / IHSG)
public struct BandarmologyEngine {
    
    /// Evaluates accumulation status based on Broker Summary and Foreign Flow
    public static func evaluateAccumulation(
        topBuyers: [BrokerDetail],
        topSellers: [BrokerDetail],
        foreignFlow: ForeignFlowSummary,
        turnoverIDR: Double
    ) -> (status: AccumulationStatus, score: Int, phase: String, bandarAvgPrice: Double) {
        
        let buyTotal = topBuyers.prefix(3).reduce(0.0) { $0 + abs($1.netValue) }
        let sellTotal = topSellers.prefix(3).reduce(0.0) { $0 + abs($1.netValue) }
        let totalTopVolume = buyTotal + sellTotal
        
        // CR3 (Concentration of top 3 brokers relative to turnover)
        let cr3 = turnoverIDR > 0 ? (buyTotal / turnoverIDR) : 0.5
        let netBuyerSellerDiff = buyTotal - sellTotal
        
        // Calculate weighted average price of top buyers (Bandar Average Cost)
        var totalWeightedVal: Double = 0
        var totalLots: Double = 0
        for buyer in topBuyers {
            totalWeightedVal += abs(buyer.netValue)
            if buyer.avgPrice > 0 {
                totalLots += abs(buyer.netValue) / buyer.avgPrice
            }
        }
        let bandarAvgCost = totalLots > 0 ? (totalWeightedVal / totalLots) : 0.0
        
        // Determine foreign broker participation
        let foreignBuyerCount = topBuyers.prefix(3).filter { $0.isForeign }.count
        let foreignSellerCount = topSellers.prefix(3).filter { $0.isForeign }.count
        
        // Scoring formula (0 - 100)
        var score = 50.0
        
        // CR3 contribution
        if cr3 >= 0.55 {
            score += 20.0
        } else if cr3 >= 0.40 {
            score += 10.0
        }
        
        // Top Buyer vs Seller spread
        if totalTopVolume > 0 {
            let ratio = netBuyerSellerDiff / totalTopVolume
            score += ratio * 20.0
        }
        
        // Foreign Flow contribution
        if foreignFlow.netForeign1D > 20_000_000_000 { // > Rp 20 M
            score += 15.0
        } else if foreignFlow.netForeign1D > 0 {
            score += 8.0
        } else if foreignFlow.netForeign1D < -20_000_000_000 {
            score -= 15.0
        }
        
        if foreignFlow.netForeign5D > 50_000_000_000 { // > Rp 50 M cumulative 5-day
            score += 15.0
        } else if foreignFlow.netForeign5D > 0 {
            score += 5.0
        }
        
        // Institutional Foreign Broker bonus (e.g. ZP, AK, BK, RX buying while retail selling)
        if foreignBuyerCount >= 2 && foreignSellerCount == 0 {
            score += 10.0
        }
        
        let finalScore = min(100, max(0, Int(score)))
        
        // Determine Status
        let status: AccumulationStatus
        let phase: String
        
        if finalScore >= 78 {
            status = .bigAccumulation
            phase = foreignFlow.netForeign5D > foreignFlow.netForeign1D ? "Akumulasi Masif (Smart Money Masuk)" : "Mark-Up / Breakout Inflow"
        } else if finalScore >= 62 {
            status = .normalAccumulation
            phase = "Akumulasi Bertahap"
        } else if finalScore >= 45 {
            status = .neutral
            phase = "Konsolidasi / Netral"
        } else if finalScore >= 30 {
            status = .normalDistribution
            phase = "Distribusi Ringan"
        } else {
            status = .bigDistribution
            phase = "Distribusi Masif (Smart Money Keluar)"
        }
        
        return (status, finalScore, phase, bandarAvgCost)
    }
}
