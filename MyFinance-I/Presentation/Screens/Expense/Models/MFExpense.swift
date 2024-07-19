//
//  MFExpense.swift
//  MyFinance-I
//
//  Created by Jamoliddinov Abduraxmon on 11/07/24.
//

import Foundation
import RealmSwift

class MFExepnse: Identifiable {
    
    init?(expense: Expense?,
          olderExpense: MFExepnse? = nil,
          newerExpense: MFExepnse? = nil,
          isYearlyTotalOn: Bool = true,
          isMonthlyTotalOn: Bool = true,
          isWeeklyTotalOn: Bool = true,
          isDailyTotalOn: Bool = true,
          isExpenseOn: Bool = true,
          unit: MFUnit,
          income: Int)
    {
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
        self.unit = unit
        self.income = income
        
        func dividedByIncome(_ amount: Double) -> Double {
            if income > 0 {
                return (amount / (Double(income) * 100)).rounded(toPlaces: 3)
            } else {
                return 0
            }
        }
        
//        if unit == .som {
            if let olderExpense, olderExpense.year == year {
                self._yearlyTotal = Double(expense.cost) + olderExpense._yearlyTotal
            } else {
                self._yearlyTotal = Double(expense.cost)
            }
            
            if let olderExpense, olderExpense.year == year && olderExpense.monthOfTheYear == monthOfTheYear {
                self._monthlyTotal = Double(expense.cost) + olderExpense._monthlyTotal
            } else {
                self._monthlyTotal = Double(expense.cost)
            }
            
            if let olderExpense, olderExpense.year == year && olderExpense.weekOfTheYear == weekOfTheYear {
                self._weeklyTotal = Double(expense.cost) + olderExpense._weeklyTotal
            } else {
                self._weeklyTotal = Double(expense.cost)
            }
            
            if let olderExpense, olderExpense.year == year && olderExpense.dayOfTheYear == dayOfTheYear {
                self._dailyTotal = Double(expense.cost) + olderExpense._dailyTotal
            } else {
                self._dailyTotal = Double(expense.cost)
            }
//        } else {
//            if let olderExpense, olderExpense.year == year {
//                self.yearlyTotal = dividedByIncome(Double(expense.cost) + olderExpense.yearlyTotal)
//            } else {
//                self.yearlyTotal = dividedByIncome(Double(expense.cost))
//            }
//            
//            if let olderExpense, olderExpense.year == year && olderExpense.monthOfTheYear == monthOfTheYear {
//                self.monthlyTotal = dividedByIncome(Double(expense.cost) + olderExpense.monthlyTotal)
//            } else {
//                self.monthlyTotal = dividedByIncome(Double(expense.cost))
//            }
//            
//            if let olderExpense, olderExpense.year == year && olderExpense.weekOfTheYear == weekOfTheYear {
//                self.weeklyTotal = dividedByIncome(Double(expense.cost) + olderExpense.weeklyTotal)
//            } else {
//                self.weeklyTotal = dividedByIncome(Double(expense.cost))
//            }
//            
//            if let olderExpense, olderExpense.year == year && olderExpense.dayOfTheYear == dayOfTheYear {
//                self.dailyTotal = dividedByIncome(Double(expense.cost) + olderExpense.dailyTotal)
//            } else {
//                self.dailyTotal = dividedByIncome(Double(expense.cost))
//            }
//        }
        
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
    
    
    var yearlyTotal: String {
        if unit == .som {
            return String(_yearlyTotal)
        } else {
            if income > 0 {
//                return "\((_monthlyTotal / Double(income) * 100).rounded(toPlaces: 3).removeZerosFromEnd()) %"
                return "n/a"
            } else {
                return "n/a"
            }
        }
    }
    var _yearlyTotal: Double
    var monthlyTotal: String {
        if unit == .som {
            return String(_monthlyTotal)
        } else {
            if income > 0 {
                return "\((_monthlyTotal / Double(income) * 100).rounded(toPlaces: 3).removeZerosFromEnd()) %"
            } else {
                return "n/a"
            }
        }
    }
    var _monthlyTotal: Double
    var weeklyTotal: String {
        if unit == .som {
            return String(_weeklyTotal)
        } else {
            if income > 0 {
                return "\((_weeklyTotal / Double(income) * 100).rounded(toPlaces: 3).removeZerosFromEnd()) %"
            } else {
                return "n/a"
            }
        }
    }
    var _weeklyTotal: Double
    var dailyTotal: String {
        if unit == .som {
            return String(_dailyTotal)
        } else {
            if income > 0 {
                return "\((_dailyTotal / Double(income) * 100).rounded(toPlaces: 3).removeZerosFromEnd()) %"
            } else {
                return "n/a"
            }
        }
    }
    var _dailyTotal: Double

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
    
    var unit: MFUnit
    var income: Int
    
    var cost: String {
        if unit == .som {
            return String(Int(quantity * Double(price)))
        } else {
            if income > 0 {
                return "\((quantity * Double(price) / Double(income) * 100).rounded(toPlaces: 3).removeZerosFromEnd()) %"
            } else {
                return "n/a"
            }
        }
    }
}
