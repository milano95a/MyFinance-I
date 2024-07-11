//
//  MFExpense.swift
//  MyFinance-I
//
//  Created by Jamoliddinov Abduraxmon on 11/07/24.
//

import Foundation
import RealmSwift

class MFExepnse: Identifiable {
    
    init?(expense: Expense?, olderExpense: MFExepnse? = nil, newerExpense: MFExepnse? = nil, isYearlyTotalOn: Bool = true, isMonthlyTotalOn: Bool = true, isWeeklyTotalOn: Bool = true, isDailyTotalOn: Bool = true, isExpenseOn: Bool = true) {
        guard let expense else { return nil}
        
        self.id = expense.id
        self.name = expense.name
        self.quantity = expense.quantity
        self.price = expense.price
        self.category = expense.category
        
        self.date = expense.date
        self.year = expense.date.year
        self.monthOfTheYear = expense.date.monthOfTheYear
        self.weekOfTheYear = expense.date.weekOfTheYear
        self.dayOfTheYear = expense.date.dayOfTheYear
        
        if let olderExpense, olderExpense.year == year {
            self.yearlyTotal = expense.cost + olderExpense.yearlyTotal
        } else {
            self.yearlyTotal = expense.cost
        }
        
        if let olderExpense, olderExpense.year == year && olderExpense.monthOfTheYear == monthOfTheYear {
            self.monthlyTotal = expense.cost + olderExpense.monthlyTotal
        } else {
            self.monthlyTotal = expense.cost
        }
        
        if let olderExpense, olderExpense.year == year && olderExpense.weekOfTheYear == weekOfTheYear {
            self.weeklyTotal = expense.cost + olderExpense.weeklyTotal
        } else {
            self.weeklyTotal = expense.cost
        }
        
        if let olderExpense, olderExpense.year == year && olderExpense.dayOfTheYear == dayOfTheYear {
            self.dailyTotal = expense.cost + olderExpense.dailyTotal
        } else {
            self.dailyTotal = expense.cost
        }
        
        self.isYearlyTotalOn = true
        self.isMonthlyTotalOn = true
        self.isWeeklyTotalOn = true
        self.isDailyTotalOn = true
        self.isExpenseOn = true
        
        self.showYearlyTotal = isYearlyTotalOn && newerExpense?.year != year
        self.showMonthlyTotal = isMonthlyTotalOn && newerExpense?.monthOfTheYear != monthOfTheYear
        self.showWeeklyTotal = isWeeklyTotalOn && newerExpense?.weekOfTheYear != weekOfTheYear
        self.showDailyTotal = isDailyTotalOn && newerExpense?.dayOfTheYear != dayOfTheYear
        
        self.showExpense = isExpenseOn
        if let newerExpense {
            self.showDate = newerExpense.year != year || newerExpense.monthOfTheYear != monthOfTheYear || newerExpense.weekOfTheYear != weekOfTheYear ||  newerExpense.dayOfTheYear != dayOfTheYear
        } else {
            self.showDate = true
        }
    }
    
    var id: ObjectId
    var name: String
    var quantity: Double
    var price: Int
    var category: String
    
    var date: Date
    var year: Int
    var monthOfTheYear: Int
    var weekOfTheYear: Int
    var dayOfTheYear: Int
    

    var yearlyTotal: Int
    var monthlyTotal: Int
    var weeklyTotal: Int
    var dailyTotal: Int

    var isYearlyTotalOn: Bool
    var isMonthlyTotalOn: Bool
    var isWeeklyTotalOn: Bool
    var isDailyTotalOn: Bool
    var isExpenseOn: Bool
    
    var showYearlyTotal: Bool
    var showMonthlyTotal: Bool
    var showWeeklyTotal: Bool
    var showDailyTotal: Bool
    var showExpense: Bool
 
    var showDate: Bool
    
    var cost: Int {
        Int(quantity * Double(price))
    }
}
