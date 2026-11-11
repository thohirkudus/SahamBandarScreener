import Foundation

/// Technical Analysis Engine responsible for calculating EMA, MACD, and identifying Golden Cross events
public struct TechnicalAnalysisEngine {
    
    /// Calculates Exponential Moving Average (EMA)
    public static func calculateEMA(prices: [Double], period: Int) -> [Double] {
        guard prices.count >= period, period > 0 else { return [] }
        
        var emaValues = [Double]()
        let multiplier = 2.0 / Double(period + 1)
        
        // Initial SMA as the first EMA seed
        let initialSMA = prices.prefix(period).reduce(0, +) / Double(period)
        emaValues.append(initialSMA)
        
        for price in prices.dropFirst(period) {
            let previousEMA = emaValues.last!
            let currentEMA = (price - previousEMA) * multiplier + previousEMA
            emaValues.append(currentEMA)
        }
        
        return emaValues
    }
    
    /// Computes full MACD (12, 26, 9) sequence from historical candles
    public static func computeMACD(candles: [Candle], fastPeriod: Int = 12, slowPeriod: Int = 26, signalPeriod: Int = 9) -> [MACDPoint] {
        let closes = candles.map { $0.close }
        guard closes.count >= slowPeriod + signalPeriod else { return [] }
        
        let emaFast = calculateEMA(prices: closes, period: fastPeriod)
        let emaSlow = calculateEMA(prices: closes, period: slowPeriod)
        
        // Align Fast EMA to Slow EMA index
        let offset = slowPeriod - fastPeriod
        guard emaFast.count > offset else { return [] }
        let trimmedFast = Array(emaFast.suffix(emaSlow.count))
        
        var macdLine = [Double]()
        for i in 0..<emaSlow.count {
            macdLine.append(trimmedFast[i] - emaSlow[i])
        }
        
        // Signal line is 9-day EMA of MACD Line
        let signalLine = calculateEMA(prices: macdLine, period: signalPeriod)
        let trimmedMACD = Array(macdLine.suffix(signalLine.count))
        let dates = Array(candles.map { $0.date }.suffix(signalLine.count))
        
        var points = [MACDPoint]()
        for i in 0..<signalLine.count {
            let m = trimmedMACD[i]
            let s = signalLine[i]
            let h = m - s
            points.append(MACDPoint(date: dates[i], macd: m, signal: s, histogram: h))
        }
        
        return points
    }
    
    /// Analyzes MACD points to detect Golden Cross timing and strength
    public static func analyzeMACD(points: [MACDPoint], currentPrice: Double, candles: [Candle]) -> TechnicalIndicatorData {
        guard points.count >= 2 else {
            return TechnicalIndicatorData(
                macdPoints: points,
                latestMACD: 0,
                latestSignal: 0,
                latestHistogram: 0,
                isGoldenCrossToday: false,
                daysSinceGoldenCross: nil,
                isBelowZeroLine: false,
                rsi14: 50.0,
                ma20: currentPrice,
                ma50: currentPrice
            )
        }
        
        let latest = points.last!
        let previous = points[points.count - 2]
        
        // Golden Cross occurs when MACD line crosses from below or equal to Signal line, to strictly above
        let isGoldenCrossToday = (previous.macd <= previous.signal) && (latest.macd > latest.signal)
        
        // Search back up to 10 days for historical cross
        var daysSinceCross: Int? = nil
        if isGoldenCrossToday {
            daysSinceCross = 0
        } else {
            let lookback = min(10, points.count - 1)
            for i in 1...lookback {
                let idx = points.count - 1 - i
                if idx > 0 {
                    let curr = points[idx]
                    let prev = points[idx - 1]
                    if (prev.macd <= prev.signal) && (curr.macd > curr.signal) {
                        daysSinceCross = i
                        break
                    }
                }
            }
        }
        
        let isBelowZero = latest.macd < 0
        let rsi = calculateRSI(candles: candles, period: 14)
        let closes = candles.map { $0.close }
        let ma20 = closes.count >= 20 ? (closes.suffix(20).reduce(0, +) / 20.0) : currentPrice
        let ma50 = closes.count >= 50 ? (closes.suffix(50).reduce(0, +) / 50.0) : currentPrice
        
        return TechnicalIndicatorData(
            macdPoints: points,
            latestMACD: latest.macd,
            latestSignal: latest.signal,
            latestHistogram: latest.histogram,
            isGoldenCrossToday: isGoldenCrossToday,
            daysSinceGoldenCross: daysSinceCross,
            isBelowZeroLine: isBelowZero,
            rsi14: rsi,
            ma20: ma20,
            ma50: ma50
        )
    }
    
    /// Standard 14-period Relative Strength Index (RSI)
    public static func calculateRSI(candles: [Candle], period: Int = 14) -> Double {
        guard candles.count > period else { return 50.0 }
        let closes = candles.map { $0.close }
        var gains = [Double]()
        var losses = [Double]()
        
        for i in 1..<closes.count {
            let diff = closes[i] - closes[i - 1]
            if diff >= 0 {
                gains.append(diff)
                losses.append(0.0)
            } else {
                gains.append(0.0)
                losses.append(abs(diff))
            }
        }
        
        guard gains.count >= period else { return 50.0 }
        let recentGains = Array(gains.suffix(period))
        let recentLosses = Array(losses.suffix(period))
        let avgGain = recentGains.reduce(0, +) / Double(period)
        let avgLoss = recentLosses.reduce(0, +) / Double(period)
        
        if avgLoss == 0 { return 100.0 }
        let rs = avgGain / avgLoss
        return 100.0 - (100.0 / (1.0 + rs))
    }
}
