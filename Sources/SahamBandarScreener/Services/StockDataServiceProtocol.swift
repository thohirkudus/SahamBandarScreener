import Foundation

public protocol StockDataServiceProtocol {
    /// Fetch all screened stocks with Bandarmology and Technical indicators computed
    func fetchScreenedStocks() async throws -> [Stock]
    
    /// Fetch detailed stock data for a specific ticker
    func fetchStockDetail(ticker: String) async throws -> Stock?
    
    /// Refresh screening data
    func refreshData() async throws -> [Stock]
}
