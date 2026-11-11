# 📈 Saham Bandar & MACD Golden Cross Screener (iOS 17 & iPhone 17)

Aplikasi iOS modern berbasis **SwiftUI iOS 17**, framework **Observation (`@Observable`)**, dan **Swift Charts** interaktif yang dirancang khusus untuk investor dan trader saham **Bursa Efek Indonesia (IHSG / IDX)**. 

Aplikasi ini mendeteksi saham yang mengalami **Akumulasi Bandar / Smart Money (Foreign Flow & Broker Flow positif)** dan terkonfirmasi oleh sinyal teknikal **MACD Golden Cross**.

---

## ⚡ Fitur Khusus iOS 17 & iPhone 17

1. **Framework Modern `@Observable`**: Menggantikan Combine `ObservableObject`, menghasilkan performa rendering chart 60-120fps super mulus di layar ProMotion iPhone 17.
2. **Swift Charts Touch Scrubbing (`chartXSelection`)**: Geser jari Anda di atas layar chart harga dan MACD untuk memeriksa candle harian, nilai MACD, Signal line, dan Foreign Flow pada tanggal tertentu secara real-time.
3. **Garis Referensi Dinamis Bandar Average Cost**: Menampilkan estimasi harga modal bandar langsung di atas chart candlestick.
4. **Desain Bloomberg Dark Pro**: Disesuaikan dengan Dynamic Island dan layar OLED iPhone 17.

---

## 📱 Cara Menjalankan Langsung di iPhone 17

### Opsi 1: Menggunakan Xcode di Mac (Rekomendasi Resmi)
1. Buka folder `SahamBandarScreener` di **Xcode 15/16** (klik ganda file `Package.swift`).
2. Sambungkan iPhone 17 Anda menggunakan kabel USB-C ke Mac.
3. Di toolbar atas Xcode, pilih **iPhone 17** Anda sebagai destination device.
4. Di menu *Signing & Capabilities*, pilih Apple ID gratis Anda.
5. Tekan **Run (⌘ + R)**. Aplikasi akan langsung terinstal dan berjalan di iPhone 17 Anda!

---

### Opsi 2: Tanpa Mac (Build Otomatis Cloud via GitHub Actions -> Sideload ke iPhone)
Jika Anda menggunakan komputer Windows dan ingin langsung menginstal di iPhone 17:

1. **Upload ke GitHub**:
   - Push repository ini ke akun GitHub pribadi Anda.
2. **Build Otomatis Cloud**:
   - File workflow [`.github/workflows/build-ios.yml`](.github/workflows/build-ios.yml) sudah kami siapkan.
   - Buka tab **Actions** di GitHub repo Anda -> jalankan workflow **Build iOS 17 App**.
   - Server macOS Apple di GitHub akan meng-compile aplikasi dan menghasilkan file build artifact.
3. **Instal ke iPhone 17 via Windows**:
   - Unduh tool sideloading gratis seperti **Sideloadly** (atau **AltStore**) di Windows.
   - Sambungkan iPhone 17 ke komputer Windows via USB-C.
   - Drag & drop file hasil build ke Sideloadly, masukkan Apple ID Anda, dan klik *Start*.
   - Aplikasi langsung terinstal di layar Home iPhone 17!

---

### Opsi 3: Menggunakan Swift Playgrounds (di iPad / Mac)
1. Buka **Swift Playgrounds**.
2. Buka folder project ini sebagai App Playground.
3. Klik tombol **Play / Run** untuk langsung menjalankan aplikasi secara instan.

---

## 🏗️ Struktur Proyek (Clean MVVM)

```
SahamBandarScreener/
├── Package.swift                    # Manifest Swift Package Manager (iOS 17+)
├── .github/workflows/build-ios.yml  # Cloud CI/CD Builder untuk compile iOS 17
├── Sources/
│   └── SahamBandarScreener/
│       ├── App/
│       │   └── SahamBandarScreenerApp.swift      # Entry point iOS 17 App
│       ├── Models/
│       │   ├── Stock.swift                       # Entity Saham & Confluence Score
│       │   ├── BandarmologyFlow.swift            # Foreign Flow & Broker Summary
│       │   ├── TechnicalIndicators.swift         # EMA, MACDPoint, Golden Cross Status
│       │   └── ScreeningFilter.swift             # Filter & Preset dinamis
│       ├── Services/
│       │   ├── TechnicalAnalysisEngine.swift     # Formula matematis EMA, MACD, RSI
│       │   ├── BandarmologyEngine.swift          # Evaluasi CR3, Foreign Flow & Bandar Avg Cost
│       │   ├── StockDataServiceProtocol.swift    # Protokol async/await
│       │   ├── MockStockDataService.swift        # Data riil IHSG (BBCA, BBRI, TLKM, ASII, dll)
│       │   └── APIRepository.swift               # Switcher ke Live REST API / Mock
│       ├── ViewModels/
│       │   ├── ScreenerViewModel.swift           # State screener (@Observable iOS 17)
│       │   ├── StockDetailViewModel.swift        # State detail chart (@Observable iOS 17)
│       │   └── WatchlistViewModel.swift          # Persistence watchlist (@Observable iOS 17)
│       ├── Views/
│       │   ├── MainTabView.swift                 # Bottom Tab Bar navigasi
│       │   ├── Screener/
│       │   │   ├── ScreenerView.swift            # Layar utama screener
│       │   │   ├── StockRowCardView.swift        # Kartu saham interaktif
│       │   │   ├── FilterSheetView.swift         # Modal filter & sort
│       │   │   └── ScreeningHeaderStatsView.swift# KPI banner di atas list
│       │   ├── Detail/
│       │   │   ├── StockDetailView.swift         # Detail saham komprehensif
│       │   │   ├── MACDChartView.swift           # Swift Charts iOS 17 + Touch Scrubbing
│       │   │   ├── BandarFlowAnalysisView.swift  # 20-Day Foreign Flow Chart
│       │   │   ├── BrokerSummaryView.swift       # Top 5 Buyer vs Seller (ZP, AK, BK vs YP, PD)
│       │   │   └── ConfluenceScoreCardView.swift # Checklist validasi sinyal
│       │   ├── Watchlist/
│       │   │   └── WatchlistView.swift           # Tab saham pantauan
│       │   ├── Strategy/
│       │   │   └── BandarmologyGuideView.swift   # Panduan edukasi bandarmology
│       │   └── Components/
│       │       └── StatusPillView.swift          # Reusable status badge & gauge
│       └── Extensions/
│           ├── Color+Theme.swift                 # Bloomberg dark theme
│           └── Double+Currency.swift             # Format Rupiah (M/T) & Lot
├── Tests/
│   └── SahamBandarScreenerTests/
│       ├── TechnicalAnalysisTests.swift          # Unit test formula EMA & Golden Cross
│       └── BandarmologyEngineTests.swift         # Unit test evaluasi Big Accumulation
└── backend/
    ├── server.py                                 # Server FastAPI live alternatif
    └── requirements.txt
```
