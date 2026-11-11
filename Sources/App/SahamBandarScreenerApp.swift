import SwiftUI
import SahamBandarScreener

@main
public struct SahamBandarScreenerApp: App {
    public init() {}
    
    public var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(.dark)
        }
    }
}
