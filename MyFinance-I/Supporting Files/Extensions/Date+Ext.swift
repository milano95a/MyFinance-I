//
//  Date+Ext.swift
//  MyFinance-I
//
//  Created by Jamoliddinov Abduraxmon on 02/08/24.
//

import Foundation

extension Date {
    var dayOfTheYear: Int {
        Calendar.current.ordinality(of: .day, in: .year, for: self)!
    }
    
    var weekOfTheYear: Int {
        Calendar.current.component(.weekOfYear, from: self)
    }
    
    var monthOfTheYear: Int {
        Calendar.current.component(.month, from: self)
    }
    
    var year: Int {
        Calendar.current.component(.year, from: self)
    }

    var friendlyDate: String {
        self.formatted(date: .abbreviated, time: .omitted)
    }
    
    func isSameWeek(_ date: Date) -> Bool {
        self.weekOfTheYear == date.weekOfTheYear && self.year == date.year
    }
    
    func isSameDay(_ date: Date) -> Bool {
        return self.dayOfTheYear == date.dayOfTheYear && self.year == date.year
    }
    
    func isSameMonth(_ date: Date) -> Bool {
        self.monthOfTheYear == date.monthOfTheYear && self.year == date.year
    }
    
    func monthsSince(_ date: Date) -> [Date] {
        var result = [Date]()
        var nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: date)!

        while nextMonth < Date.now {
            result.append(nextMonth)
            nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: nextMonth)!
        }
                    
        return result
    }
    
    /// Converts date inito string with custom format
    func formatDate(with format: String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
