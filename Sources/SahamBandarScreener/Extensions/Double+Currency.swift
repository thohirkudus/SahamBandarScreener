import Foundation

extension Double {
    /// Formats Rupiah value into Indonesian financial notation (e.g. Rp 14.5 Miliar, Rp 1.2 Triliun)
    var formattedIDRValue: String {
        let absVal = abs(self)
        let sign = self < 0 ? "-" : (self > 0 ? "+" : "")
        
        if absVal >= 1_000_000_000_000 {
            let triliun = absVal / 1_000_000_000_000
            return "\(sign)Rp \(String(format: "%.2f", triliun)) T"
        } else if absVal >= 1_000_000_000 {
            let miliar = absVal / 1_000_000_000
            return "\(sign)Rp \(String(format: "%.1f", miliar)) M"
        } else if absVal >= 1_000_000 {
            let juta = absVal / 1_000_000
            return "\(sign)Rp \(String(format: "%.1f", juta)) Jt"
        } else {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencySymbol = "Rp "
            formatter.maximumFractionDigits = 0
            return formatter.string(from: NSNumber(value: self)) ?? "Rp \(Int(self))"
        }
    }
    
    /// Formats price in IDR format (e.g. Rp 9.850)
    var formattedStockPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        formatter.maximumFractionDigits = 0
        let formatted = formatter.string(from: NSNumber(value: self)) ?? "\(Int(self))"
        return "Rp \(formatted)"
    }
    
    /// Formats percentage change with explicit +/- sign
    var formattedPercentChange: String {
        let sign = self > 0 ? "+" : ""
        return "\(sign)\(String(format: "%.2f", self))%"
    }
    
    /// Formats trading volume in lot or shares
    var formattedVolumeLot: String {
        let lot = self / 100.0
        if lot >= 1_000_000 {
            return String(format: "%.2fM Lot", lot / 1_000_000)
        } else if lot >= 1_000 {
            return String(format: "%.1fK Lot", lot / 1_000)
        } else {
            return "\(Int(lot)) Lot"
        }
    }
}

extension Date {
    var shortDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        return formatter.string(from: self)
    }
    
    var timeAgoDisplay: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
