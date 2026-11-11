import XCTest
@testable import SahamBandarScreener

final class BandarmologyEngineTests: XCTestCase {
    
    func testBigAccumulationDetection() {
        let topBuyers = [
            BrokerDetail(code: "ZP", name: "Maybank", netValue: 60_000_000_000, avgPrice: 1000, isForeign: true),
            BrokerDetail(code: "AK", name: "UBS", netValue: 50_000_000_000, avgPrice: 1010, isForeign: true),
            BrokerDetail(code: "BK", name: "J.P. Morgan", netValue: 40_000_000_000, avgPrice: 1005, isForeign: true)
        ]
        
        let topSellers = [
            BrokerDetail(code: "YP", name: "Mirae Asset", netValue: -20_000_000_000, avgPrice: 990, isForeign: false),
            BrokerDetail(code: "PD", name: "Indo Premier", netValue: -15_000_000_000, avgPrice: 995, isForeign: false),
            BrokerDetail(code: "XC", name: "Ajaib", netValue: -10_000_000_000, avgPrice: 990, isForeign: false)
        ]
        
        let foreignFlow = ForeignFlowSummary(
            netForeign1D: 80_000_000_000,
            netForeign5D: 250_000_000_000,
            netForeign20D: 500_000_000_000,
            foreignParticipationRate: 0.55
        )
        
        let turnover = 250_000_000_000.0
        
        let eval = BandarmologyEngine.evaluateAccumulation(
            topBuyers: topBuyers,
            topSellers: topSellers,
            foreignFlow: foreignFlow,
            turnoverIDR: turnover
        )
        
        XCTAssertTrue(eval.status.isAccumulation, "Expected accumulation status")
        XCTAssertEqual(eval.status, .bigAccumulation)
        XCTAssertGreaterThanOrEqual(eval.score, 75)
        XCTAssertGreaterThan(eval.bandarAvgPrice, 0)
    }
}
