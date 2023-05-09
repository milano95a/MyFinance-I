//
//  Total.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 14/04/23.
//

import Foundation

struct Total {
    var dailyTotals = [String: Int]()
    var weeklyTotals = [String: Int]()
    var monthlyTotals = [String: Int]()
    var yearlyTotals = [String: Int]()
    
    init() {}
    
    init(dailyTotals: [String : Int] = [String: Int](), weeklyTotals: [String : Int] = [String: Int](), monthlyTotals: [String : Int] = [String: Int](), yearlyTotals: [String : Int] = [String: Int]()) {
        self.dailyTotals = dailyTotals
        self.weeklyTotals = weeklyTotals
        self.monthlyTotals = monthlyTotals
        self.yearlyTotals = yearlyTotals
    }
}
