import Foundation

public final class APIRepository: StockDataServiceProtocol {
    private let mockService: MockStockDataService
    private let baseURL: URL?
    public var useLiveBackend: Bool = false
    
    public init(baseURLString: String? = "http://localhost:8000/api", useLiveBackend: Bool = false) {
        self.mockService = MockStockDataService()
        if let str = baseURLString {
            self.baseURL = URL(string: str)
        } else {
            self.baseURL = nil
        }
        self.useLiveBackend = useLiveBackend
    }
    
    public func fetchScreenedStocks() async throws -> [Stock] {
        if useLiveBackend, let baseURL = baseURL {
            let url = baseURL.appendingPathComponent("screener")
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    return try decoder.decode([Stock].self, from: data)
                }
            } catch {
                // Fallback gracefully to mock data if backend server is not running
                print("Failed to reach live backend (\(error.localizedDescription)), falling back to Mock Engine.")
            }
        }
        
        return try await mockService.fetchScreenedStocks()
    }
    
    public func fetchStockDetail(ticker: String) async throws -> Stock? {
        if useLiveBackend, let baseURL = baseURL {
            let url = baseURL.appendingPathComponent("stocks/\(ticker)")
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    return try decoder.decode(Stock.self, from: data)
                }
            } catch {
                print("Failed to reach live stock detail, falling back to mock.")
            }
        }
        
        return try await mockService.fetchStockDetail(ticker: ticker)
    }
    
    public func refreshData() async throws -> [Stock] {
        return try await fetchScreenedStocks()
    }
}
