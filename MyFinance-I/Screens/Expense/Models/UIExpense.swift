//
//  UIExpense.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 25/04/23.
//

import Foundation
import RealmSwift

struct UIExpense: Identifiable {
    var id: ObjectId
    var name: String
    var quantity: Double
    var price: Int
    var date: Date
    var category: String
    var cost: Int {
        Int(quantity * Double(price))
    }
    
    var isSameDayAsPrevious: Bool
    
    var dailyTotal: Int
    var weeklyTotal: Int
    var monthlyTotal: Int
    var yearlyTotal: Int
    
    var showDailyTotal: Bool
    var showWeeklyTotal: Bool
    var showMonthlyTotal: Bool
    var showYearlyTotal: Bool
    var showExpense: Bool
}
