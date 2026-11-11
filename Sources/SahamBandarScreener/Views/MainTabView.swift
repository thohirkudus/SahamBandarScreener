import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

public struct MainTabView: View {
    @State private var watchlistVM = WatchlistViewModel()
    @State private var selectedTab = 0
    
    public init() {
        #if canImport(UIKit) && !os(watchOS)
        // Customize TabBar appearance for iOS
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.appCardBackground)
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.goldenCrossGold)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(Color.goldenCrossGold)
        ]
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color.textMuted)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Color.textMuted)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        #endif
    }
    
    public var body: some View {
        TabView(selection: $selectedTab) {
            ScreenerView()
                .tabItem {
                    Label("Screener", systemImage: "sparkle.magnifyingglass")
                }
                .tag(0)
            
            WatchlistView()
                .tabItem {
                    Label("Watchlist", systemImage: "bookmark.fill")
                }
                .tag(1)
            
            BandarmologyGuideView()
                .tabItem {
                    Label("Strategi", systemImage: "lightbulb.fill")
                }
                .tag(2)
        }
        .environment(watchlistVM)
        .accentColor(.goldenCrossGold)
    }
}
