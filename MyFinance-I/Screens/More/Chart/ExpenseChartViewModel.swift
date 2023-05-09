//
//  ExpenseChartViewModel.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 15/04/23.
//

import Foundation

class ExpenseChartViewModel: ObservableObject {
    
//    MARK: Intents
    func getMonthlyExpensesFor(_ year: Int) -> [BarChartData] {
        let expenses = Expense.fetchRequest(.all)
        
        var totalByMonth = [Int: Int]()
        
        for expense in expenses {
            if expense.date.year == year {
                if let _ = totalByMonth[expense.date.monthOfTheYear] {
                    totalByMonth[expense.date.monthOfTheYear]! += expense.cost
                } else {
                    totalByMonth[expense.date.monthOfTheYear] = expense.cost
                }
            }
        }
        
        var monthlyExpenses = Array(repeating: BarChartData(value: 0, text: ""), count: 12)
        
        for (month, total) in totalByMonth {
            monthlyExpenses[month-1].text = month.name
            monthlyExpenses[month-1].value = Double(Double(total) / 1_000_000).rounded(toPlaces: 1)
        }
        
        return monthlyExpenses
    }
    
    func getYears() -> [Int] {
        let expenses = Expense.fetchRequest(.all)
        var years = Set<Int>()
        
        for expense in expenses {
            years.insert(expense.date.year)
        }
        
        return Array(years).sorted()
    }
}

extension Int {
    var name: String {
        let monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        return monthNames[self-1]
    }
}
