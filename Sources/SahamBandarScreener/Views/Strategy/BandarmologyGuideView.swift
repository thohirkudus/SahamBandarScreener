import SwiftUI

public struct BandarmologyGuideView: View {
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header Banner
                    headerCard
                    
                    // Strategy Concept 1: The Synergy
                    conceptCard(
                        number: "1",
                        title: "Sinergi Bandarmology + MACD",
                        subtitle: "Smart Money Menggerakkan, MACD Mengonfirmasi",
                        content: "Bandarmology mendeteksi fase AKUMULASI saat smart money (investor institusi & asing) mulai mengumpulkan barang secara diam-diam tanpa menaikkan harga secara mencolok.\n\nNamun, membeli saat baru mulai akumulasi bisa memakan waktu berbulan-bulan (floating sideways). Di sinilah MACD Golden Cross berperan: MACD memberikan sinyal momentum saat akumulasi selesai dan fase MARK-UP siap dimulai!",
                        icon: "bolt.horizontal.circle.fill",
                        accentColor: .goldenCrossGold
                    )
                    
                    // Strategy Concept 2: Golden Cross Bawah Nol
                    conceptCard(
                        number: "2",
                        title: "Golden Cross di Bawah Garis Nol",
                        subtitle: "Setup Reversal dengan Risk-to-Reward Tertinggi",
                        content: "Golden Cross yang terjadi ketika garis MACD berada di bawah nol (< 0) menandakan bahwa saham baru saja keluar dari tekanan jual ekstrem (oversold).\n\nKetika fenomena ini disertai Foreign Net Buy positif dan Broker Concentration (CR3 > 50%), probabilitas terjadinya swing rally reversal sangat tinggi dengan batasan Stop Loss yang terukur di sekitar Bandar Average Cost.",
                        icon: "arrow.up.and.line.horizontal.and.arrow.down",
                        accentColor: .bandarGreen
                    )
                    
                    // Strategy Concept 3: Membaca Broker Flow
                    brokerCodeGuideCard
                    
                    // Strategy Concept 4: 4 Siklus Bandarmology
                    cyclesCard
                    
                    // Actionable Trading Rules Card
                    tradingRulesCard
                }
                .padding()
            }
            .background(Color.appBackground.ignoresSafeArea())
            .navigationTitle("Panduan Strategi")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - Subcomponents
    
    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.goldenCrossGold)
                Text("FORMULA SCREENING SMART MONEY")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.goldenCrossGold)
            }
            
            Text("Rahasia Menggabungkan Foreign Flow & MACD Golden Cross")
                .font(.system(size: 18, weight: .black, design: .rounded))
                .foregroundColor(.textPrimary)
            
            Text("Hindari jebakan false breakout dengan memastikan setiap sinyal teknikal didukung oleh aliran dana kongkrit.")
                .font(.system(size: 13))
                .foregroundColor(.textSecondary)
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: [Color.appCardBackground, Color.appCardSecondary],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(14)
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.appBorder, lineWidth: 1))
    }
    
    private func conceptCard(number: String, title: String, subtitle: String, content: String, icon: String, accentColor: Color) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Text(number)
                    .font(.system(size: 12, weight: .black))
                    .foregroundColor(.appBackground)
                    .frame(width: 22, height: 22)
                    .background(accentColor)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 1) {
                    Text(title)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.textPrimary)
                    Text(subtitle)
                        .font(.system(size: 11))
                        .foregroundColor(accentColor)
                }
            }
            
            Text(content)
                .font(.system(size: 13))
                .foregroundColor(.textSecondary)
                .lineSpacing(4)
        }
        .padding(14)
        .background(Color.appCardBackground)
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.appBorder, lineWidth: 1))
    }
    
    private var brokerCodeGuideCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "person.2.badge.gearshape.fill")
                    .foregroundColor(.foreignFlowCyan)
                Text("Klasifikasi Broker di IHSG")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.textPrimary)
            }
            
            Text("Dalam analisis Bandarmology IHSG, profil pembeli dan penjual memberikan indikasi siapa yang mengendalikan suplai:")
                .font(.system(size: 12))
                .foregroundColor(.textSecondary)
            
            VStack(spacing: 8) {
                brokerProfileRow(
                    label: "Broker Institusi Asing",
                    codes: "ZP, AK, BK, RX, KZ, CG, CS",
                    desc: "Sering mengakumulasi saham Big Cap & Bluechip untuk dana pensiun global.",
                    badgeColor: .foreignFlowCyan
                )
                
                brokerProfileRow(
                    label: "Broker Ritel Domestik",
                    codes: "YP, PD, XC, XL, NI, CC",
                    desc: "Umumnya nasabah ritel perorangan. Jika broker ini jualan masif saat asing beli, ini indikasi kuat Smart Money Absorption.",
                    badgeColor: .bandarRed
                )
            }
        }
        .padding(14)
        .background(Color.appCardBackground)
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.appBorder, lineWidth: 1))
    }
    
    private func brokerProfileRow(label: String, codes: String, desc: String, badgeColor: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(label)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.textPrimary)
                Spacer()
                Text(codes)
                    .font(.system(size: 11, weight: .black, design: .monospaced))
                    .foregroundColor(badgeColor)
            }
            Text(desc)
                .font(.system(size: 11))
                .foregroundColor(.textSecondary)
        }
        .padding(10)
        .background(Color.appCardSecondary)
        .cornerRadius(8)
    }
    
    private var cyclesCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("4 Siklus Perjalanan Saham")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.textPrimary)
            
            HStack(spacing: 6) {
                cycleStep(title: "1. Akumulasi", subtitle: "Bandar beli diam-diam", color: .goldenCrossGold)
                cycleStep(title: "2. Mark-Up", subtitle: "MACD Cross & Terbang", color: .bandarGreen)
                cycleStep(title: "3. Distribusi", subtitle: "Bandar jualan ke ritel", color: .macdSignalOrange)
                cycleStep(title: "4. Mark-Down", subtitle: "Harga dijatuhkan", color: .bandarRed)
            }
        }
        .padding(14)
        .background(Color.appCardBackground)
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.appBorder, lineWidth: 1))
    }
    
    private func cycleStep(title: String, subtitle: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(color)
            Text(subtitle)
                .font(.system(size: 8))
                .foregroundColor(.textMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(6)
        .background(Color.appCardSecondary)
        .cornerRadius(6)
    }
    
    private var tradingRulesCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "checkmark.shield.fill")
                    .foregroundColor(.bandarGreen)
                Text("Aturan Eksekusi (Rule of Thumb)")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.textPrimary)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                ruleRow(num: "1", text: "Entry terbaik saat MACD Golden Cross baru muncul (Hari Ini atau < 3 Hari).")
                ruleRow(num: "2", text: "Pastikan Foreign Flow 1H & 5H positif secara konsisten.")
                ruleRow(num: "3", text: "Gunakan Bandar Average Cost sebagai level support dinamis untuk Stop Loss.")
                ruleRow(num: "4", text: "Jika harga naik tapi asing mulai net sell masif (distribusi), siapkan Trailing Stop.")
            }
        }
        .padding(14)
        .background(Color.appCardBackground)
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.appBorder, lineWidth: 1))
    }
    
    private func ruleRow(num: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text(num)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.bandarGreen)
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(.textSecondary)
        }
    }
}
