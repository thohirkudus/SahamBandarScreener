import SwiftUI

public struct ScreenerView: View {
    @State private var viewModel = ScreenerViewModel()
    @Environment(WatchlistViewModel.self) private var watchlistVM
    @State private var showFilterSheet: Bool = false
    @State private var searchText: String = ""
    
    public init() {}
    
    public var body: some View {
        @Bindable var vm = viewModel
        
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Search Bar & Filter Button
                    searchAndFilterBar
                    
                    // Quick Preset Pills Carousel
                    presetChipsCarousel
                        .padding(.vertical, 8)
                    
                    // Main Scrollable Content
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            // Top KPI summary banner
                            ScreeningHeaderStatsView(
                                primeSetupCount: viewModel.primeSetupCount,
                                totalInflowToday: viewModel.totalInflowToday,
                                goldenCrossCount: viewModel.goldenCrossCount
                            )
                            .padding(.top, 4)
                            .padding(.bottom, 6)
                            
                            // Section header: Results count and active preset
                            HStack {
                                Text("\(viewModel.filteredStocks.count) Saham Terdeteksi")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.textSecondary)
                                
                                Spacer()
                                
                                Text(viewModel.filter.selectedPreset.rawValue)
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(.goldenCrossGold)
                            }
                            .padding(.horizontal)
                            
                            // Stock Cards
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(.goldenCrossGold)
                                    .padding(.top, 40)
                            } else if viewModel.filteredStocks.isEmpty {
                                emptyStateView
                            } else {
                                ForEach(viewModel.filteredStocks) { stock in
                                    NavigationLink(destination: StockDetailView(stock: stock)) {
                                        StockRowCardView(
                                            stock: stock,
                                            isWatchlisted: watchlistVM.isWatchlisted(stock.ticker),
                                            onWatchlistTapped: {
                                                watchlistVM.toggleWatchlist(stock.ticker)
                                            }
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.bottom, 30)
                    }
                    .refreshable {
                        await viewModel.loadData()
                    }
                }
            }
            .navigationTitle("Screener Akumulasi")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 6) {
                        Image(systemName: "chart.line.uptrend.xyaxis.circle.fill")
                            .foregroundColor(.goldenCrossGold)
                        Text("Bandar & MACD Cross")
                            .font(.system(size: 17, weight: .black, design: .rounded))
                            .foregroundColor(.textPrimary)
                    }
                }
            }
            .sheet(isPresented: $showFilterSheet) {
                FilterSheetView(filter: $vm.filter) {
                    viewModel.applyFilter()
                }
            }
            .task {
                if viewModel.allStocks.isEmpty {
                    await viewModel.loadData()
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    private var searchAndFilterBar: some View {
        HStack(spacing: 8) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.textMuted)
                TextField("Cari Ticker (e.g. BBCA, BBRI)", text: $searchText)
                    .foregroundColor(.textPrimary)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.characters)
                    .onChange(of: searchText) { _, newValue in
                        viewModel.updateSearchQuery(newValue)
                    }
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                        viewModel.updateSearchQuery("")
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.textMuted)
                    }
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(Color.appCardBackground)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.appBorder, lineWidth: 1)
            )
            
            Button(action: { showFilterSheet = true }) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.textPrimary)
                    .padding(9)
                    .background(Color.appCardBackground)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.appBorder, lineWidth: 1)
                    )
            }
        }
        .padding(.horizontal)
        .padding(.top, 6)
    }
    
    private var presetChipsCarousel: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(FilterPreset.allCases) { preset in
                    let isSelected = viewModel.filter.selectedPreset == preset
                    Button(action: {
                        viewModel.selectPreset(preset)
                    }) {
                        Text(preset.rawValue)
                            .font(.system(size: 12, weight: isSelected ? .bold : .medium))
                            .foregroundColor(isSelected ? .appBackground : .textSecondary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(isSelected ? Color.goldenCrossGold : Color.appCardBackground)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(isSelected ? Color.clear : Color.appBorder, lineWidth: 1)
                            )
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "chart.bar.xaxis")
                .font(.system(size: 40))
                .foregroundColor(.textMuted)
                .padding(.top, 50)
            
            Text("Tidak Ada Saham yang Cocok")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.textPrimary)
            
            Text("Coba ganti preset atau sesuaikan kriteria filter di menu filter.")
                .font(.system(size: 13))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Button("Reset Filter") {
                viewModel.resetFilter()
                searchText = ""
            }
            .font(.system(size: 13, weight: .bold))
            .foregroundColor(.goldenCrossGold)
            .padding(.top, 4)
        }
    }
}
