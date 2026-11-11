import SwiftUI

public struct WatchlistView: View {
    @Environment(WatchlistViewModel.self) private var watchlistVM
    @State private var screenerVM = ScreenerViewModel()
    
    public init() {}
    
    public var watchlistedStocks: [Stock] {
        screenerVM.allStocks.filter { watchlistVM.isWatchlisted($0.ticker) }
    }
    
    public var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                if watchlistedStocks.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "bookmark.slash")
                            .font(.system(size: 40))
                            .foregroundColor(.textMuted)
                        Text("Belum Ada Saham di Watchlist")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.textPrimary)
                        Text("Tekan ikon bookmark pada kartu saham di tab Screener untuk memantau akumulasi.")
                            .font(.system(size: 13))
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            HStack {
                                Text("\(watchlistedStocks.count) Saham Dipantau")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.textSecondary)
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.top, 8)
                            
                            ForEach(watchlistedStocks) { stock in
                                NavigationLink(destination: StockDetailView(stock: stock)) {
                                    StockRowCardView(
                                        stock: stock,
                                        isWatchlisted: true,
                                        onWatchlistTapped: {
                                            watchlistVM.toggleWatchlist(stock.ticker)
                                        }
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(.horizontal)
                            }
                        }
                        .padding(.bottom, 24)
                    }
                }
            }
            .navigationTitle("Watchlist Pantauan")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                if screenerVM.allStocks.isEmpty {
                    await screenerVM.loadData()
                }
            }
        }
    }
}
