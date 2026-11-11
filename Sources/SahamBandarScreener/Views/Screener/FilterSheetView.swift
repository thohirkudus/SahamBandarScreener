import SwiftUI

public struct FilterSheetView: View {
    @Binding public var filter: ScreeningFilter
    public let onApply: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    public var body: some View {
        NavigationStack {
            Form {
                // Section 1: Presets
                Section(header: Text("Preset Strategi Screening").foregroundColor(.textSecondary)) {
                    ForEach(FilterPreset.allCases) { preset in
                        HStack {
                            VStack(alignment: .leading, spacing: 3) {
                                Text(preset.rawValue)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.textPrimary)
                                Text(preset.description)
                                    .font(.system(size: 11))
                                    .foregroundColor(.textSecondary)
                            }
                            Spacer()
                            if filter.selectedPreset == preset {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.goldenCrossGold)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            filter.selectedPreset = preset
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                // Section 2: Sector
                Section(header: Text("Sektor Saham").foregroundColor(.textSecondary)) {
                    Picker("Pilih Sektor", selection: $filter.selectedSector) {
                        ForEach(Sector.allCases, id: \.self) { sector in
                            Text(sector.rawValue).tag(sector)
                        }
                    }
                }
                
                // Section 3: Market Cap
                Section(header: Text("Market Cap").foregroundColor(.textSecondary)) {
                    Picker("Kategori Kapitalisasi", selection: $filter.selectedMarketCap) {
                        ForEach(MarketCapTier.allCases) { tier in
                            Text(tier.rawValue).tag(tier)
                        }
                    }
                }
                
                // Section 4: Urutan (Sorting)
                Section(header: Text("Urutkan Berdasarkan").foregroundColor(.textSecondary)) {
                    Picker("Sort", selection: $filter.sortBy) {
                        ForEach(SortOption.allCases) { sort in
                            Text(sort.rawValue).tag(sort)
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.appBackground)
            .navigationTitle("Filter Screener")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Reset") {
                        filter = ScreeningFilter()
                    }
                    .foregroundColor(.bandarRed)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Terapkan") {
                        onApply()
                        dismiss()
                    }
                    .foregroundColor(.goldenCrossGold)
                    .fontWeight(.bold)
                }
            }
        }
    }
}
