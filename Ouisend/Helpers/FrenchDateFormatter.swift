//
//  FrenchDateFormatter.swift
//  Ouisend
//
//  Created by Esso Awesso on 02/03/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import Foundation


class FrenchDateFormatter {
    
    static func formatDateForServer(_ date: Date) -> String {
        let french = DateFormatter()
        french.dateStyle = .medium
        french.timeStyle = .medium
        french.locale    = Locale(identifier: "FR-fr")
        french.dateFormat = "yyyy-MM-dd"
        return french.string(for: date) ?? french.string(for: Date()) ?? ""
    }
    
    static func formatDate(_ date: Date) -> String {
        let french = DateFormatter()
        french.dateStyle = .medium
        french.timeStyle = .medium
        french.locale    = Locale(identifier: "FR-fr")
        french.dateFormat = "dd MMMM YYYY"
        return french.string(for: date) ?? french.string(for: Date()) ?? ""
    }
    
    static func formatMinDate(_ date: Date) -> String {
        let french = DateFormatter()
        french.dateStyle = .medium
        french.timeStyle = .medium
        french.locale    = Locale(identifier: "FR-fr")
        french.dateFormat = "dd MMM YYYY"
        return french.string(for: date) ?? french.string(for: Date()) ?? ""
    }
    
    static func formatMinMinDate(_ date: Date) -> String {
        let french = DateFormatter()
        french.dateStyle = .medium
        french.timeStyle = .medium
        french.locale    = Locale(identifier: "FR-fr")
        french.dateFormat = "MMM YYYY"
        return french.string(for: date) ?? french.string(for: Date()) ?? ""
    }
    
    static func formatDateAndHour(_ date: Date) -> String {
        let french = DateFormatter()
        french.dateStyle = .medium
        french.timeStyle = .medium
        french.locale    = Locale(identifier: "FR-fr")
        french.dateFormat = "dd MMMM YYYY 'à' HH:mm"
        return french.string(for: date) ?? french.string(for: Date()) ?? ""
    }
    
    static func formatDateMonthYear(_ date: Date) -> String {
        let french = DateFormatter()
        french.dateStyle = .medium
        french.timeStyle = .medium
        french.locale    = Locale(identifier: "FR-fr")
        french.dateFormat = "MMMM YYYY"
        return french.string(for: date) ?? french.string(for: Date()) ?? ""
    }
    
    static func makeDate(year: Int, month: Int, day: Int = 1, hr: Int = 0, min: Int = 0, sec: Int = 0) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        // calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let components = DateComponents(year: year, month: month, day: day, hour: hr, minute: min, second: sec)
        return calendar.date(from: components)!
    }
}
