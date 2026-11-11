import SwiftUI
import Observation

@Observable
@MainActor
public final class ScreenerViewModel {
    public var allStocks: [Stock] = []
    public var filteredStocks: [Stock] = []
    public var filter: ScreeningFilter = ScreeningFilter()
    public var isLoading: Bool = false
    public var errorMessage: String? = nil
    
    // Quick summary statistics for header banner
    public var totalInflowToday: Double = 0
    public var goldenCrossCount: Int = 0
    public var bigAccumCount: Int = 0
    public var primeSetupCount: Int = 0
    
    private let repository: StockDataServiceProtocol
    
    public init(repository: StockDataServiceProtocol = APIRepository()) {
        self.repository = repository
    }
    
    public func loadData() async {
        isLoading = true
        errorMessage = nil
        do {
            let fetched = try await repository.fetchScreenedStocks()
            self.allStocks = fetched
            updateStatistics(from: fetched)
            applyFilter()
        } catch {
            self.errorMessage = "Gagal memuat data screening: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    public func selectPreset(_ preset: FilterPreset) {
        filter.selectedPreset = preset
        applyFilter()
    }
    
    public func applyFilter() {
        self.filteredStocks = filter.apply(to: allStocks)
    }
    
    public func updateSearchQuery(_ text: String) {
        filter.searchQuery = text
        applyFilter()
    }
    
    public func resetFilter() {
        filter = ScreeningFilter()
        applyFilter()
    }
    
    private func updateStatistics(from stocks: [Stock]) {
        // Calculate cumulative positive net foreign flow today
        self.totalInflowToday = stocks.reduce(0.0) { sum, stock in
            let inflow = stock.bandarmology.foreignFlow.netForeign1D
            return inflow > 0 ? sum + inflow : sum
        }
        
        self.goldenCrossCount = stocks.filter { $0.technical.crossStatus.isGoldenCross }.count
        self.bigAccumCount = stocks.filter { $0.bandarmology.accumulationStatus == .bigAccumulation }.count
        self.primeSetupCount = stocks.filter {
            $0.bandarmology.accumulationStatus.isAccumulation && $0.technical.crossStatus.isGoldenCross
        }.count
    }
}
