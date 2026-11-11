import Foundation

public final class MockStockDataService: StockDataServiceProtocol {
    
    public init() {}
    
    public func fetchScreenedStocks() async throws -> [Stock] {
        // Simulate real-world network latency (300ms)
        try? await Task.sleep(nanoseconds: 300_000_000)
        return generateMockStocks()
    }
    
    public func fetchStockDetail(ticker: String) async throws -> Stock? {
        try? await Task.sleep(nanoseconds: 150_000_000)
        let stocks = generateMockStocks()
        return stocks.first { $0.ticker.uppercased() == ticker.uppercased() }
    }
    
    public func refreshData() async throws -> [Stock] {
        return try await fetchScreenedStocks()
    }
    
    // MARK: - Mock Generator with Real Mathematical Indicator Calibration
    
    private func generateMockStocks() -> [Stock] {
        var list = [Stock]()
        let calendar = Calendar.current
        let today = Date()
        
        // 1. BBCA (Bank Central Asia) - Mega Cap, Big Accumulation, Golden Cross Today
        let bbcaCandles = generateCandles(
            basePrice: 9850,
            trend: .sharpReversalToday,
            avgVolume: 85_000_000,
            foreignNetAvg: 180_000_000_000,
            days: 45
        )
        let bbcaMACDPoints = TechnicalAnalysisEngine.computeMACD(candles: bbcaCandles)
        let bbcaTech = TechnicalAnalysisEngine.analyzeMACD(points: bbcaMACDPoints, currentPrice: 9850, candles: bbcaCandles)
        
        let bbcaForeign = ForeignFlowSummary(
            netForeign1D: 215_400_000_000,   // +Rp 215.4 M
            netForeign5D: 842_000_000_000,   // +Rp 842.0 M
            netForeign20D: 2_150_000_000_000,// +Rp 2.15 T
            foreignParticipationRate: 0.58
        )
        let bbcaBuyers = [
            BrokerDetail(code: "ZP", name: "Maybank Sekuritas", netValue: 88_500_000_000, avgPrice: 9825, isForeign: true),
            BrokerDetail(code: "AK", name: "UBS Sekuritas", netValue: 72_100_000_000, avgPrice: 9840, isForeign: true),
            BrokerDetail(code: "BK", name: "J.P. Morgan", netValue: 64_800_000_000, avgPrice: 9810, isForeign: true),
            BrokerDetail(code: "RX", name: "Macquarie", netValue: 31_200_000_000, avgPrice: 9830, isForeign: true),
            BrokerDetail(code: "KZ", name: "CLSA Sekuritas", netValue: 24_000_000_000, avgPrice: 9850, isForeign: true)
        ]
        let bbcaSellers = [
            BrokerDetail(code: "YP", name: "Mirae Asset", netValue: -45_000_000_000, avgPrice: 9800, isForeign: false),
            BrokerDetail(code: "PD", name: "Indo Premier", netValue: -38_200_000_000, avgPrice: 9815, isForeign: false),
            BrokerDetail(code: "XC", name: "Ajaib Sekuritas", netValue: -29_500_000_000, avgPrice: 9790, isForeign: false),
            BrokerDetail(code: "CC", name: "Mandiri Sekuritas", netValue: -22_100_000_000, avgPrice: 9820, isForeign: false),
            BrokerDetail(code: "NI", name: "BNI Sekuritas", netValue: -15_400_000_000, avgPrice: 9835, isForeign: false)
        ]
        let bbcaBrokerSummary = BrokerSummaryData(
            topBuyers: bbcaBuyers,
            topSellers: bbcaSellers,
            cr3: 0.64,
            cr5: 0.79,
            buyerSellerDiff: 110_600_000_000,
            dominantBuyerSide: "Foreign Tier-1 Institutions"
        )
        let bbcaBandar = BandarmologyData(
            accumulationStatus: .bigAccumulation,
            foreignFlow: bbcaForeign,
            brokerSummary: bbcaBrokerSummary,
            bandarScore: 94,
            bandarPhase: "Akumulasi Masif (Big Accum)",
            bandarAvgPrice: 9828
        )
        list.append(Stock(
            ticker: "BBCA",
            name: "Bank Central Asia Tbk",
            sector: .financials,
            currentPrice: 9850,
            previousClose: 9700,
            change: 150,
            changePercent: 1.55,
            dayHigh: 9900,
            dayLow: 9725,
            volumeLot: 885_000,
            turnoverIDR: 871_725_000_000,
            marketCapIDR: 1_214_250_000_000_000,
            bandarmology: bbcaBandar,
            technical: bbcaTech,
            candles: bbcaCandles
        ))
        
        // 2. BBRI (Bank Rakyat Indonesia) - Golden Cross 1 Day Ago Below Zero
        let bbriCandles = generateCandles(
            basePrice: 4720,
            trend: .crossedOneDayAgo,
            avgVolume: 145_000_000,
            foreignNetAvg: 110_000_000_000,
            days: 45
        )
        let bbriMACDPoints = TechnicalAnalysisEngine.computeMACD(candles: bbriCandles)
        let bbriTech = TechnicalAnalysisEngine.analyzeMACD(points: bbriMACDPoints, currentPrice: 4720, candles: bbriCandles)
        let bbriForeign = ForeignFlowSummary(
            netForeign1D: 148_900_000_000,
            netForeign5D: 425_000_000_000,
            netForeign20D: 910_000_000_000,
            foreignParticipationRate: 0.49
        )
        let bbriBuyers = [
            BrokerDetail(code: "BK", name: "J.P. Morgan", netValue: 68_000_000_000, avgPrice: 4680, isForeign: true),
            BrokerDetail(code: "ZP", name: "Maybank", netValue: 55_200_000_000, avgPrice: 4700, isForeign: true),
            BrokerDetail(code: "AK", name: "UBS Sekuritas", netValue: 42_100_000_000, avgPrice: 4710, isForeign: true),
            BrokerDetail(code: "CS", name: "Credit Suisse", netValue: 26_300_000_000, avgPrice: 4690, isForeign: true),
            BrokerDetail(code: "RX", name: "Macquarie", netValue: 18_900_000_000, avgPrice: 4705, isForeign: true)
        ]
        let bbriSellers = [
            BrokerDetail(code: "YP", name: "Mirae Asset", netValue: -39_000_000_000, avgPrice: 4670, isForeign: false),
            BrokerDetail(code: "PD", name: "Indo Premier", netValue: -31_500_000_000, avgPrice: 4680, isForeign: false),
            BrokerDetail(code: "XC", name: "Ajaib Sekuritas", netValue: -24_000_000_000, avgPrice: 4660, isForeign: false),
            BrokerDetail(code: "XL", name: "Stockbit", netValue: -17_800_000_000, avgPrice: 4675, isForeign: false),
            BrokerDetail(code: "CC", name: "Mandiri Sekuritas", netValue: -12_200_000_000, avgPrice: 4690, isForeign: false)
        ]
        let bbriBrokerSummary = BrokerSummaryData(
            topBuyers: bbriBuyers,
            topSellers: bbriSellers,
            cr3: 0.58,
            cr5: 0.74,
            buyerSellerDiff: 80_900_000_000,
            dominantBuyerSide: "Foreign Smart Money"
        )
        let bbriBandar = BandarmologyData(
            accumulationStatus: .bigAccumulation,
            foreignFlow: bbriForeign,
            brokerSummary: bbriBrokerSummary,
            bandarScore: 91,
            bandarPhase: "Reversal & Akumulasi Bawah",
            bandarAvgPrice: 4694
        )
        list.append(Stock(
            ticker: "BBRI",
            name: "Bank Rakyat Indonesia Tbk",
            sector: .financials,
            currentPrice: 4720,
            previousClose: 4620,
            change: 100,
            changePercent: 2.16,
            dayHigh: 4750,
            dayLow: 4610,
            volumeLot: 1_420_000,
            turnoverIDR: 670_240_000_000,
            marketCapIDR: 715_348_000_000_000,
            bandarmology: bbriBandar,
            technical: bbriTech,
            candles: bbriCandles
        ))
        
        // 3. TLKM (Telkom Indonesia) - Turnaround with Fresh Golden Cross Today
        let tlkmCandles = generateCandles(
            basePrice: 2880,
            trend: .sharpReversalToday,
            avgVolume: 120_000_000,
            foreignNetAvg: 60_000_000_000,
            days: 45
        )
        let tlkmMACDPoints = TechnicalAnalysisEngine.computeMACD(candles: tlkmCandles)
        let tlkmTech = TechnicalAnalysisEngine.analyzeMACD(points: tlkmMACDPoints, currentPrice: 2880, candles: tlkmCandles)
        let tlkmForeign = ForeignFlowSummary(
            netForeign1D: 64_500_000_000,
            netForeign5D: 185_000_000_000,
            netForeign20D: 240_000_000_000,
            foreignParticipationRate: 0.44
        )
        let tlkmBuyers = [
            BrokerDetail(code: "AK", name: "UBS Sekuritas", netValue: 34_000_000_000, avgPrice: 2850, isForeign: true),
            BrokerDetail(code: "ZP", name: "Maybank", netValue: 28_500_000_000, avgPrice: 2860, isForeign: true),
            BrokerDetail(code: "BK", name: "J.P. Morgan", netValue: 19_200_000_000, avgPrice: 2870, isForeign: true),
            BrokerDetail(code: "CG", name: "CGS International", netValue: 12_000_000_000, avgPrice: 2865, isForeign: true),
            BrokerDetail(code: "CC", name: "Mandiri Sekuritas", netValue: 8_500_000_000, avgPrice: 2875, isForeign: false)
        ]
        let tlkmSellers = [
            BrokerDetail(code: "YP", name: "Mirae Asset", netValue: -21_000_000_000, avgPrice: 2840, isForeign: false),
            BrokerDetail(code: "PD", name: "Indo Premier", netValue: -18_400_000_000, avgPrice: 2845, isForeign: false),
            BrokerDetail(code: "XC", name: "Ajaib Sekuritas", netValue: -14_200_000_000, avgPrice: 2850, isForeign: false),
            BrokerDetail(code: "NI", name: "BNI Sekuritas", netValue: -9_800_000_000, avgPrice: 2860, isForeign: false),
            BrokerDetail(code: "AZ", name: "Sucor Sekuritas", netValue: -6_200_000_000, avgPrice: 2855, isForeign: false)
        ]
        let tlkmBrokerSummary = BrokerSummaryData(
            topBuyers: tlkmBuyers,
            topSellers: tlkmSellers,
            cr3: 0.52,
            cr5: 0.68,
            buyerSellerDiff: 38_100_000_000,
            dominantBuyerSide: "Foreign Inflow Reversal"
        )
        let tlkmBandar = BandarmologyData(
            accumulationStatus: .normalAccumulation,
            foreignFlow: tlkmForeign,
            brokerSummary: tlkmBrokerSummary,
            bandarScore: 86,
            bandarPhase: "Reversal Golden Cross",
            bandarAvgPrice: 2858
        )
        list.append(Stock(
            ticker: "TLKM",
            name: "Telkom Indonesia Tbk",
            sector: .infrastructure,
            currentPrice: 2880,
            previousClose: 2800,
            change: 80,
            changePercent: 2.86,
            dayHigh: 2900,
            dayLow: 2810,
            volumeLot: 940_000,
            turnoverIDR: 270_720_000_000,
            marketCapIDR: 285_300_000_000_000,
            bandarmology: tlkmBandar,
            technical: tlkmTech,
            candles: tlkmCandles
        ))
        
        // 4. ASII (Astra International) - Big Accumulation + Golden Cross Today
        let asiiCandles = generateCandles(
            basePrice: 5050,
            trend: .sharpReversalToday,
            avgVolume: 55_000_000,
            foreignNetAvg: 70_000_000_000,
            days: 45
        )
        let asiiMACDPoints = TechnicalAnalysisEngine.computeMACD(candles: asiiCandles)
        let asiiTech = TechnicalAnalysisEngine.analyzeMACD(points: asiiMACDPoints, currentPrice: 5050, candles: asiiCandles)
        let asiiForeign = ForeignFlowSummary(
            netForeign1D: 78_200_000_000,
            netForeign5D: 290_000_000_000,
            netForeign20D: 510_000_000_000,
            foreignParticipationRate: 0.52
        )
        let asiiBuyers = [
            BrokerDetail(code: "ZP", name: "Maybank", netValue: 35_100_000_000, avgPrice: 5025, isForeign: true),
            BrokerDetail(code: "BK", name: "J.P. Morgan", netValue: 28_400_000_000, avgPrice: 5010, isForeign: true),
            BrokerDetail(code: "AK", name: "UBS Sekuritas", netValue: 22_700_000_000, avgPrice: 5040, isForeign: true),
            BrokerDetail(code: "KZ", name: "CLSA", netValue: 14_200_000_000, avgPrice: 5030, isForeign: true),
            BrokerDetail(code: "RX", name: "Macquarie", netValue: 9_800_000_000, avgPrice: 5050, isForeign: true)
        ]
        let asiiSellers = [
            BrokerDetail(code: "YP", name: "Mirae Asset", netValue: -19_500_000_000, avgPrice: 4990, isForeign: false),
            BrokerDetail(code: "PD", name: "Indo Premier", netValue: -15_200_000_000, avgPrice: 5000, isForeign: false),
            BrokerDetail(code: "XC", name: "Ajaib Sekuritas", netValue: -11_800_000_000, avgPrice: 4980, isForeign: false),
            BrokerDetail(code: "CC", name: "Mandiri Sekuritas", netValue: -8_400_000_000, avgPrice: 5010, isForeign: false),
            BrokerDetail(code: "SQ", name: "BCA Sekuritas", netValue: -6_100_000_000, avgPrice: 5020, isForeign: false)
        ]
        let asiiBrokerSummary = BrokerSummaryData(
            topBuyers: asiiBuyers,
            topSellers: asiiSellers,
            cr3: 0.61,
            cr5: 0.76,
            buyerSellerDiff: 49_200_000_000,
            dominantBuyerSide: "Foreign Tier-1 Accumulation"
        )
        let asiiBandar = BandarmologyData(
            accumulationStatus: .bigAccumulation,
            foreignFlow: asiiForeign,
            brokerSummary: asiiBrokerSummary,
            bandarScore: 92,
            bandarPhase: "Akumulasi Masif + Breakout",
            bandarAvgPrice: 5026
        )
        list.append(Stock(
            ticker: "ASII",
            name: "Astra International Tbk",
            sector: .consumer,
            currentPrice: 5050,
            previousClose: 4940,
            change: 110,
            changePercent: 2.23,
            dayHigh: 5075,
            dayLow: 4960,
            volumeLot: 480_000,
            turnoverIDR: 242_400_000_000,
            marketCapIDR: 204_442_000_000_000,
            bandarmology: asiiBandar,
            technical: asiiTech,
            candles: asiiCandles
        ))
        
        // 5. AMMN (Amman Mineral) - Mining, High Broker Concentration
        let ammnCandles = generateCandles(
            basePrice: 9200,
            trend: .bullishStreak,
            avgVolume: 35_000_000,
            foreignNetAvg: 95_000_000_000,
            days: 45
        )
        let ammnMACDPoints = TechnicalAnalysisEngine.computeMACD(candles: ammnCandles)
        let ammnTech = TechnicalAnalysisEngine.analyzeMACD(points: ammnMACDPoints, currentPrice: 9200, candles: ammnCandles)
        let ammnForeign = ForeignFlowSummary(
            netForeign1D: 105_000_000_000,
            netForeign5D: 340_000_000_000,
            netForeign20D: 890_000_000_000,
            foreignParticipationRate: 0.62
        )
        let ammnBuyers = [
            BrokerDetail(code: "BK", name: "J.P. Morgan", netValue: 52_000_000_000, avgPrice: 9150, isForeign: true),
            BrokerDetail(code: "AK", name: "UBS Sekuritas", netValue: 41_500_000_000, avgPrice: 9175, isForeign: true),
            BrokerDetail(code: "ZP", name: "Maybank", netValue: 33_200_000_000, avgPrice: 9180, isForeign: true),
            BrokerDetail(code: "LG", name: "Trimegah", netValue: 18_000_000_000, avgPrice: 9160, isForeign: false),
            BrokerDetail(code: "CC", name: "Mandiri Sekuritas", netValue: 12_500_000_000, avgPrice: 9190, isForeign: false)
        ]
        let ammnSellers = [
            BrokerDetail(code: "YP", name: "Mirae Asset", netValue: -28_000_000_000, avgPrice: 9100, isForeign: false),
            BrokerDetail(code: "PD", name: "Indo Premier", netValue: -22_500_000_000, avgPrice: 9120, isForeign: false),
            BrokerDetail(code: "XC", name: "Ajaib Sekuritas", netValue: -17_000_000_000, avgPrice: 9110, isForeign: false),
            BrokerDetail(code: "XL", name: "Stockbit", netValue: -11_000_000_000, avgPrice: 9130, isForeign: false),
            BrokerDetail(code: "NI", name: "BNI Sekuritas", netValue: -8_200_000_000, avgPrice: 9140, isForeign: false)
        ]
        let ammnBrokerSummary = BrokerSummaryData(
            topBuyers: ammnBuyers,
            topSellers: ammnSellers,
            cr3: 0.72,
            cr5: 0.84,
            buyerSellerDiff: 70_500_000_000,
            dominantBuyerSide: "Global Custody & Institutional"
        )
        let ammnBandar = BandarmologyData(
            accumulationStatus: .bigAccumulation,
            foreignFlow: ammnForeign,
            brokerSummary: ammnBrokerSummary,
            bandarScore: 95,
            bandarPhase: "Mark-Up Expansion",
            bandarAvgPrice: 9168
        )
        list.append(Stock(
            ticker: "AMMN",
            name: "Amman Mineral Internasional Tbk",
            sector: .basicMaterials,
            currentPrice: 9200,
            previousClose: 9000,
            change: 200,
            changePercent: 2.22,
            dayHigh: 9275,
            dayLow: 9025,
            volumeLot: 320_000,
            turnoverIDR: 294_400_000_000,
            marketCapIDR: 667_000_000_000_000,
            bandarmology: ammnBandar,
            technical: ammnTech,
            candles: ammnCandles
        ))
        
        // 6. MEDC (Medco Energi) - Energy Breakout, Golden Cross 2 Days Ago
        let medcCandles = generateCandles(
            basePrice: 1310,
            trend: .crossedTwoDaysAgo,
            avgVolume: 65_000_000,
            foreignNetAvg: 20_000_000_000,
            days: 45
        )
        let medcMACDPoints = TechnicalAnalysisEngine.computeMACD(candles: medcCandles)
        let medcTech = TechnicalAnalysisEngine.analyzeMACD(points: medcMACDPoints, currentPrice: 1310, candles: medcCandles)
        let medcForeign = ForeignFlowSummary(
            netForeign1D: 24_500_000_000,
            netForeign5D: 68_000_000_000,
            netForeign20D: 110_000_000_000,
            foreignParticipationRate: 0.38
        )
        let medcBuyers = [
            BrokerDetail(code: "AK", name: "UBS Sekuritas", netValue: 12_000_000_000, avgPrice: 1290, isForeign: true),
            BrokerDetail(code: "ZP", name: "Maybank", netValue: 9_500_000_000, avgPrice: 1300, isForeign: true),
            BrokerDetail(code: "LG", name: "Trimegah", netValue: 7_800_000_000, avgPrice: 1295, isForeign: false),
            BrokerDetail(code: "BK", name: "J.P. Morgan", netValue: 5_200_000_000, avgPrice: 1305, isForeign: true),
            BrokerDetail(code: "CC", name: "Mandiri", netValue: 4_100_000_000, avgPrice: 1300, isForeign: false)
        ]
        let medcSellers = [
            BrokerDetail(code: "YP", name: "Mirae Asset", netValue: -8_200_000_000, avgPrice: 1285, isForeign: false),
            BrokerDetail(code: "PD", name: "Indo Premier", netValue: -6_500_000_000, avgPrice: 1290, isForeign: false),
            BrokerDetail(code: "XC", name: "Ajaib", netValue: -4_900_000_000, avgPrice: 1280, isForeign: false),
            BrokerDetail(code: "NI", name: "BNI Sekuritas", netValue: -3_100_000_000, avgPrice: 1295, isForeign: false),
            BrokerDetail(code: "XL", name: "Stockbit", netValue: -2_400_000_000, avgPrice: 1290, isForeign: false)
        ]
        let medcBrokerSummary = BrokerSummaryData(
            topBuyers: medcBuyers,
            topSellers: medcSellers,
            cr3: 0.55,
            cr5: 0.69,
            buyerSellerDiff: 13_500_000_000,
            dominantBuyerSide: "Energy Smart Flow"
        )
        let medcBandar = BandarmologyData(
            accumulationStatus: .normalAccumulation,
            foreignFlow: medcForeign,
            brokerSummary: medcBrokerSummary,
            bandarScore: 84,
            bandarPhase: "Akumulasi Bertahap",
            bandarAvgPrice: 1296
        )
        list.append(Stock(
            ticker: "MEDC",
            name: "Medco Energi Internasional Tbk",
            sector: .energy,
            currentPrice: 1310,
            previousClose: 1265,
            change: 45,
            changePercent: 3.56,
            dayHigh: 1325,
            dayLow: 1270,
            volumeLot: 580_000,
            turnoverIDR: 75_980_000_000,
            marketCapIDR: 32_930_000_000_000,
            bandarmology: medcBandar,
            technical: medcTech,
            candles: medcCandles
        ))
        
        // 7. BRIS (Bank Syariah Indonesia) - Sharia Banking, Golden Cross Today
        let brisCandles = generateCandles(
            basePrice: 2940,
            trend: .sharpReversalToday,
            avgVolume: 42_000_000,
            foreignNetAvg: 30_000_000_000,
            days: 45
        )
        let brisMACDPoints = TechnicalAnalysisEngine.computeMACD(candles: brisCandles)
        let brisTech = TechnicalAnalysisEngine.analyzeMACD(points: brisMACDPoints, currentPrice: 2940, candles: brisCandles)
        let brisForeign = ForeignFlowSummary(
            netForeign1D: 38_700_000_000,
            netForeign5D: 112_000_000_000,
            netForeign20D: 285_000_000_000,
            foreignParticipationRate: 0.46
        )
        let brisBuyers = [
            BrokerDetail(code: "ZP", name: "Maybank", netValue: 18_500_000_000, avgPrice: 2910, isForeign: true),
            BrokerDetail(code: "AK", name: "UBS Sekuritas", netValue: 14_200_000_000, avgPrice: 2920, isForeign: true),
            BrokerDetail(code: "CC", name: "Mandiri", netValue: 9_800_000_000, avgPrice: 2930, isForeign: false),
            BrokerDetail(code: "BK", name: "J.P. Morgan", netValue: 7_100_000_000, avgPrice: 2925, isForeign: true),
            BrokerDetail(code: "LG", name: "Trimegah", netValue: 5_400_000_000, avgPrice: 2915, isForeign: false)
        ]
        let brisSellers = [
            BrokerDetail(code: "YP", name: "Mirae Asset", netValue: -11_200_000_000, avgPrice: 2890, isForeign: false),
            BrokerDetail(code: "PD", name: "Indo Premier", netValue: -8_700_000_000, avgPrice: 2900, isForeign: false),
            BrokerDetail(code: "XC", name: "Ajaib", netValue: -6_500_000_000, avgPrice: 2895, isForeign: false),
            BrokerDetail(code: "NI", name: "BNI Sekuritas", netValue: -4_800_000_000, avgPrice: 2910, isForeign: false),
            BrokerDetail(code: "XL", name: "Stockbit", netValue: -3_200_000_000, avgPrice: 2905, isForeign: false)
        ]
        let brisBrokerSummary = BrokerSummaryData(
            topBuyers: brisBuyers,
            topSellers: brisSellers,
            cr3: 0.59,
            cr5: 0.73,
            buyerSellerDiff: 20_600_000_000,
            dominantBuyerSide: "Institutional Growth Fund"
        )
        let brisBandar = BandarmologyData(
            accumulationStatus: .bigAccumulation,
            foreignFlow: brisForeign,
            brokerSummary: brisBrokerSummary,
            bandarScore: 89,
            bandarPhase: "Akumulasi Breakout",
            bandarAvgPrice: 2919
        )
        list.append(Stock(
            ticker: "BRIS",
            name: "Bank Syariah Indonesia Tbk",
            sector: .financials,
            currentPrice: 2940,
            previousClose: 2860,
            change: 80,
            changePercent: 2.80,
            dayHigh: 2960,
            dayLow: 2870,
            volumeLot: 380_000,
            turnoverIDR: 111_720_000_000,
            marketCapIDR: 135_600_000_000_000,
            bandarmology: brisBandar,
            technical: brisTech,
            candles: brisCandles
        ))
        
        // 8. BMRI (Bank Mandiri) - Steady Accumulation, MACD Bullish
        let bmriCandles = generateCandles(
            basePrice: 6450,
            trend: .crossedThreeDaysAgo,
            avgVolume: 90_000_000,
            foreignNetAvg: 80_000_000_000,
            days: 45
        )
        let bmriMACDPoints = TechnicalAnalysisEngine.computeMACD(candles: bmriCandles)
        let bmriTech = TechnicalAnalysisEngine.analyzeMACD(points: bmriMACDPoints, currentPrice: 6450, candles: bmriCandles)
        let bmriForeign = ForeignFlowSummary(
            netForeign1D: 85_400_000_000,
            netForeign5D: 310_000_000_000,
            netForeign20D: 780_000_000_000,
            foreignParticipationRate: 0.51
        )
        let bmriBuyers = [
            BrokerDetail(code: "BK", name: "J.P. Morgan", netValue: 42_000_000_000, avgPrice: 6400, isForeign: true),
            BrokerDetail(code: "ZP", name: "Maybank", netValue: 35_000_000_000, avgPrice: 6425, isForeign: true),
            BrokerDetail(code: "AK", name: "UBS Sekuritas", netValue: 28_000_000_000, avgPrice: 6410, isForeign: true),
            BrokerDetail(code: "RX", name: "Macquarie", netValue: 15_000_000_000, avgPrice: 6430, isForeign: true),
            BrokerDetail(code: "KZ", name: "CLSA", netValue: 11_000_000_000, avgPrice: 6440, isForeign: true)
        ]
        let bmriSellers = [
            BrokerDetail(code: "YP", name: "Mirae Asset", netValue: -24_000_000_000, avgPrice: 6380, isForeign: false),
            BrokerDetail(code: "PD", name: "Indo Premier", netValue: -19_000_000_000, avgPrice: 6390, isForeign: false),
            BrokerDetail(code: "XC", name: "Ajaib", netValue: -14_000_000_000, avgPrice: 6375, isForeign: false),
            BrokerDetail(code: "NI", name: "BNI Sekuritas", netValue: -9_000_000_000, avgPrice: 6410, isForeign: false),
            BrokerDetail(code: "XL", name: "Stockbit", netValue: -7_000_000_000, avgPrice: 6400, isForeign: false)
        ]
        let bmriBrokerSummary = BrokerSummaryData(
            topBuyers: bmriBuyers,
            topSellers: bmriSellers,
            cr3: 0.57,
            cr5: 0.72,
            buyerSellerDiff: 58_000_000_000,
            dominantBuyerSide: "Foreign Long-Only Funds"
        )
        let bmriBandar = BandarmologyData(
            accumulationStatus: .normalAccumulation,
            foreignFlow: bmriForeign,
            brokerSummary: bmriBrokerSummary,
            bandarScore: 87,
            bandarPhase: "Akumulasi Mantap",
            bandarAvgPrice: 6415
        )
        list.append(Stock(
            ticker: "BMRI",
            name: "Bank Mandiri (Persero) Tbk",
            sector: .financials,
            currentPrice: 6450,
            previousClose: 6375,
            change: 75,
            changePercent: 1.18,
            dayHigh: 6500,
            dayLow: 6375,
            volumeLot: 790_000,
            turnoverIDR: 509_550_000_000,
            marketCapIDR: 602_000_000_000_000,
            bandarmology: bmriBandar,
            technical: bmriTech,
            candles: bmriCandles
        ))
        
        // 9. GOTO (GoTo) - Distribution & Retail Heavy (for contrast)
        let gotoCandles = generateCandles(
            basePrice: 68,
            trend: .downwardDeathCross,
            avgVolume: 450_000_000,
            foreignNetAvg: -30_000_000_000,
            days: 45
        )
        let gotoMACDPoints = TechnicalAnalysisEngine.computeMACD(candles: gotoCandles)
        let gotoTech = TechnicalAnalysisEngine.analyzeMACD(points: gotoMACDPoints, currentPrice: 68, candles: gotoCandles)
        let gotoForeign = ForeignFlowSummary(
            netForeign1D: -28_400_000_000,
            netForeign5D: -95_000_000_000,
            netForeign20D: -240_000_000_000,
            foreignParticipationRate: 0.28
        )
        let gotoBuyers = [
            BrokerDetail(code: "YP", name: "Mirae Asset", netValue: 18_000_000_000, avgPrice: 69, isForeign: false),
            BrokerDetail(code: "PD", name: "Indo Premier", netValue: 14_000_000_000, avgPrice: 69, isForeign: false),
            BrokerDetail(code: "XC", name: "Ajaib", netValue: 11_000_000_000, avgPrice: 68, isForeign: false),
            BrokerDetail(code: "XL", name: "Stockbit", netValue: 8_000_000_000, avgPrice: 68, isForeign: false),
            BrokerDetail(code: "CC", name: "Mandiri", netValue: 5_000_000_000, avgPrice: 69, isForeign: false)
        ]
        let gotoSellers = [
            BrokerDetail(code: "AK", name: "UBS Sekuritas", netValue: -26_000_000_000, avgPrice: 68, isForeign: true),
            BrokerDetail(code: "ZP", name: "Maybank", netValue: -21_000_000_000, avgPrice: 68, isForeign: true),
            BrokerDetail(code: "BK", name: "J.P. Morgan", netValue: -15_000_000_000, avgPrice: 69, isForeign: true),
            BrokerDetail(code: "RX", name: "Macquarie", netValue: -9_000_000_000, avgPrice: 68, isForeign: true),
            BrokerDetail(code: "KZ", name: "CLSA", netValue: -7_000_000_000, avgPrice: 69, isForeign: true)
        ]
        let gotoBrokerSummary = BrokerSummaryData(
            topBuyers: gotoBuyers,
            topSellers: gotoSellers,
            cr3: 0.38,
            cr5: 0.51,
            buyerSellerDiff: -35_000_000_000,
            dominantBuyerSide: "Retail Panic Absorption"
        )
        let gotoBandar = BandarmologyData(
            accumulationStatus: .bigDistribution,
            foreignFlow: gotoForeign,
            brokerSummary: gotoBrokerSummary,
            bandarScore: 24,
            bandarPhase: "Distribusi Masif (Smart Money Keluar)",
            bandarAvgPrice: 68
        )
        list.append(Stock(
            ticker: "GOTO",
            name: "GoTo Gojek Tokopedia Tbk",
            sector: .technology,
            currentPrice: 68,
            previousClose: 71,
            change: -3,
            changePercent: -4.23,
            dayHigh: 71,
            dayLow: 67,
            volumeLot: 15_200_000,
            turnoverIDR: 104_880_000_000,
            marketCapIDR: 81_600_000_000_000,
            bandarmology: gotoBandar,
            technical: gotoTech,
            candles: gotoCandles
        ))
        
        return list
    }
    
    // MARK: - Candle Generation Helper with Trend Shapes
    
    private enum TrendShape {
        case sharpReversalToday    // Generates Golden Cross TODAY below/at zero
        case crossedOneDayAgo      // Golden cross 1 day ago
        case crossedTwoDaysAgo     // Golden cross 2 days ago
        case crossedThreeDaysAgo   // Golden cross 3 days ago
        case bullishStreak         // Strong bullish trending
        case downwardDeathCross    // Bearish / Death Cross
    }
    
    private func generateCandles(basePrice: Double, trend: TrendShape, avgVolume: Double, foreignNetAvg: Double, days: Int) -> [Candle] {
        var candles = [Candle]()
        let calendar = Calendar.current
        let now = Date()
        
        var currentPrice = basePrice * 0.90
        
        for i in 0..<days {
            let dayIndex = days - 1 - i // 0 is today, days-1 is oldest
            guard let candleDate = calendar.date(byAdding: .day, value: -dayIndex, to: now) else { continue }
            
            // Adjust price based on desired pattern to produce mathematically exact MACD Golden Cross
            switch trend {
            case .sharpReversalToday:
                if i < 28 {
                    // Gradual decline to depress MACD line below Signal line
                    currentPrice *= 0.994
                } else if i < days - 2 {
                    // Consolidation at bottom
                    currentPrice *= 1.002
                } else if i == days - 2 {
                    // Turning up
                    currentPrice *= 1.018
                } else {
                    // Big pop today causing crossover!
                    currentPrice = basePrice
                }
                
            case .crossedOneDayAgo:
                if i < 26 {
                    currentPrice *= 0.994
                } else if i < days - 3 {
                    currentPrice *= 1.001
                } else if i == days - 2 {
                    currentPrice *= 1.025 // Cross happened here
                } else {
                    currentPrice = basePrice
                }
                
            case .crossedTwoDaysAgo:
                if i < 25 {
                    currentPrice *= 0.995
                } else if i < days - 4 {
                    currentPrice *= 1.002
                } else if i == days - 3 {
                    currentPrice *= 1.025 // Cross 2 days ago
                } else {
                    currentPrice = basePrice * (1.0 + Double(i - (days - 3)) * 0.008)
                }
                
            case .crossedThreeDaysAgo:
                if i < 24 {
                    currentPrice *= 0.995
                } else if i == days - 4 {
                    currentPrice *= 1.022 // Cross 3 days ago
                } else {
                    currentPrice = basePrice * (1.0 + Double(i - (days - 4)) * 0.006)
                }
                
            case .bullishStreak:
                currentPrice *= 1.004
                
            case .downwardDeathCross:
                if i < 30 {
                    currentPrice *= 1.006
                } else {
                    currentPrice *= 0.985 // Sudden drop causing death cross
                }
            }
            
            let high = currentPrice * 1.012
            let low = currentPrice * 0.988
            let open = (currentPrice + low) / 2.0
            let close = currentPrice
            let volume = avgVolume * Double.random(in: 0.8...1.25)
            let foreignVal = foreignNetAvg * Double.random(in: 0.7...1.3)
            
            candles.append(Candle(
                date: candleDate,
                open: open,
                high: high,
                low: low,
                close: close,
                volume: volume,
                foreignNetValue: foreignVal
            ))
        }
        
        return candles
    }
}
