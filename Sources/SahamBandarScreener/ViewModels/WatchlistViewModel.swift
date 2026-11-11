import SwiftUI
import Observation

@Observable
@MainActor
public final class WatchlistViewModel {
    public var savedTickers: Set<String> = []
    
    private let userDefaultsKey = "SahamBandar_Watchlist"
    
    public init() {
        loadWatchlist()
    }
    
    public func isWatchlisted(_ ticker: String) -> Bool {
        savedTickers.contains(ticker.uppercased())
    }
    
    public func toggleWatchlist(_ ticker: String) {
        let code = ticker.uppercased()
        if savedTickers.contains(code) {
            savedTickers.remove(code)
        } else {
            savedTickers.insert(code)
        }
        saveWatchlist()
    }
    
    private func loadWatchlist() {
        if let saved = UserDefaults.standard.stringArray(forKey: userDefaultsKey) {
            self.savedTickers = Set(saved)
        } else {
            // Default watchlist for new users
            self.savedTickers = ["BBCA", "BBRI", "TLKM"]
            saveWatchlist()
        }
    }
    
    private func saveWatchlist() {
        UserDefaults.standard.set(Array(savedTickers), forKey: userDefaultsKey)
    }
}
