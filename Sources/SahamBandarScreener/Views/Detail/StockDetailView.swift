import SwiftUI

public struct StockDetailView: View {
    @State private var viewModel: StockDetailViewModel
    @Environment(WatchlistViewModel.self) private var watchlistVM
    
    public init(stock: Stock) {
        _viewModel = State(initialValue: StockDetailViewModel(stock: stock))
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Stock Header Price & Key Stats
                stockHeaderCard
                
                // Confluence Setup Verdict & Checkpoints
                ConfluenceScoreCardView(
                    stock: viewModel.stock,
                    checklist: viewModel.analysisChecklist
                )
                
                // Segmented Picker for Analysis Sections
                Picker("Pilih Tab Analisis", selection: $viewModel.selectedChartTab) {
                    ForEach(StockDetailViewModel.ChartTab.allCases) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 4)
                
                // Tab Content
                switch viewModel.selectedChartTab {
                case .macdCombo:
                    MACDChartView(stock: viewModel.stock)
                case .bandarFlow:
                    BandarFlowAnalysisView(stock: viewModel.stock)
                case .brokerSummary:
                    BrokerSummaryView(stock: viewModel.stock)
                }
            }
            .padding()
        }
        .background(Color.appBackground.ignoresSafeArea())
        .navigationTitle(viewModel.stock.ticker)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    watchlistVM.toggleWatchlist(viewModel.stock.ticker)
                }) {
                    Image(systemName: watchlistVM.isWatchlisted(viewModel.stock.ticker) ? "bookmark.fill" : "bookmark")
                        .foregroundColor(.goldenCrossGold)
                }
            }
        }
    }
    
    // MARK: - Header Price & Stats
    
    private var stockHeaderCard: some View {
        VStack(spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(viewModel.stock.ticker)
                            .font(.system(size: 24, weight: .black, design: .rounded))
                            .foregroundColor(.textPrimary)
                        
                        Text(viewModel.stock.sector.rawValue)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.textSecondary)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.appCardSecondary)
                            .cornerRadius(4)
                    }
                    
                    Text(viewModel.stock.name)
                        .font(.system(size: 13))
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(viewModel.stock.currentPrice.formattedStockPrice)
                        .font(.system(size: 22, weight: .black, design: .rounded))
                        .foregroundColor(.textPrimary)
                    
                    HStack(spacing: 3) {
                        Image(systemName: viewModel.stock.change >= 0 ? "arrow.up.right" : "arrow.down.right")
                        Text(viewModel.stock.changePercent.formattedPercentChange)
                            .font(.system(size: 13, weight: .bold))
                        Text("(\(Int(viewModel.stock.change)))")
                            .font(.system(size: 12, weight: .medium))
                    }
                    .foregroundColor(viewModel.stock.change >= 0 ? .bandarGreen : .bandarRed)
                }
            }
            
            Divider()
                .background(Color.appBorder)
            
            // 4 Mini Key Stats
            HStack(spacing: 8) {
                miniStat(label: "Turnover", value: viewModel.stock.turnoverIDR.formattedIDRValue)
                miniStat(label: "Bandar Avg", value: viewModel.stock.bandarmology.bandarAvgPrice.formattedStockPrice)
                miniStat(label: "RSI (14)", value: String(format: "%.1f", viewModel.stock.technical.rsi14))
                miniStat(label: "Volume", value: viewModel.stock.volumeLot.formattedVolumeLot)
            }
        }
        .padding(14)
        .background(Color.appCardBackground)
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.appBorder, lineWidth: 1))
    }
    
    private func miniStat(label: String, value: String) -> some View {
        VStack(spacing: 2) {
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.textMuted)
            Text(value)
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundColor(.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
    }
}
