import SwiftUI

public struct ConfluenceScoreCardView: View {
    public let stock: Stock
    public let checklist: [(title: String, passed: Bool, detail: String)]
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header Score & Verdict
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Analisis Confluence Strategi")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.textSecondary)
                    
                    Text(stock.setupVerdict)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.goldenCrossGold)
                }
                
                Spacer()
                
                MetricGaugeView(score: stock.confluenceScore, label: "Skor Sinyal")
            }
            
            Divider()
                .background(Color.appBorder)
            
            // Checkpoints
            VStack(alignment: .leading, spacing: 10) {
                ForEach(checklist, id: \.title) { item in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: item.passed ? "checkmark.circle.fill" : "xmark.circle")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(item.passed ? .bandarGreen : .textMuted)
                            .padding(.top, 1)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.title)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(item.passed ? .textPrimary : .textSecondary)
                            
                            Text(item.detail)
                                .font(.system(size: 11))
                                .foregroundColor(.textSecondary)
                        }
                    }
                }
            }
        }
        .padding(14)
        .background(Color.appCardBackground)
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.appBorder, lineWidth: 1))
    }
}
