import XCTest
@testable import SahamBandarScreener

final class TechnicalAnalysisTests: XCTestCase {
    
    func testEMACalculation() {
        let prices: [Double] = [10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
        let ema5 = TechnicalAnalysisEngine.calculateEMA(prices: prices, period: 5)
        
        XCTAssertFalse(ema5.isEmpty)
        // First value should equal SMA of first 5 prices: (10+11+12+13+14)/5 = 12.0
        XCTAssertEqual(ema5.first!, 12.0, accuracy: 0.001)
        // In an uptrend, latest EMA should be higher than initial SMA
        XCTAssertGreaterThan(ema5.last!, ema5.first!)
    }
    
    func testGoldenCrossDetection() {
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: today)!
        
        // Setup: Yesterday MACD was below Signal, today MACD crossed above Signal
        let points = [
            MACDPoint(date: twoDaysAgo, macd: -5.0, signal: -2.0, histogram: -3.0),
            MACDPoint(date: yesterday, macd: -1.0, signal: -0.5, histogram: -0.5),
            MACDPoint(date: today, macd: 2.0, signal: 0.5, histogram: 1.5)
        ]
        
        let dummyCandles = [
            Candle(date: twoDaysAgo, open: 100, high: 105, low: 95, close: 100, volume: 1000, foreignNetValue: 500),
            Candle(date: yesterday, open: 100, high: 105, low: 98, close: 102, volume: 1000, foreignNetValue: 800),
            Candle(date: today, open: 102, high: 110, low: 101, close: 108, volume: 1500, foreignNetValue: 2000)
        ]
        
        let result = TechnicalAnalysisEngine.analyzeMACD(points: points, currentPrice: 108, candles: dummyCandles)
        
        XCTAssertTrue(result.isGoldenCrossToday, "Expected golden cross detected today")
        XCTAssertEqual(result.daysSinceGoldenCross, 0)
        XCTAssertEqual(result.crossStatus, .goldenCrossToday)
    }
}
