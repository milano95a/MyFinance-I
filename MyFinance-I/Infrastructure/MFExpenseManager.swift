//
//  MFExpenseManager.swift
//  MyFinance-I
//
//  Created by Jamoliddinov Abduraxmon on 06/09/24.
//

import Foundation
import RealmSwift

protocol MFExpenseManager {
    mutating func getExpensesWithTotals(searchText: String, unit: MFUnit, showYearlyTotal: Bool, showMonthlyTotal: Bool, showWeeklyTotal: Bool, showDailyTotal: Bool, showExpenses: Bool) -> [MFExepnse]
}

struct MFDefaultExpenseManager: MFExpenseManager {
    
    private init() { }
    
    static var shared = MFDefaultExpenseManager()
    var expenses: [MFExepnse] = []
    
    mutating func getExpensesWithTotals(searchText: String = "", unit: MFUnit, showYearlyTotal: Bool, showMonthlyTotal: Bool, showWeeklyTotal: Bool, showDailyTotal: Bool, showExpenses: Bool) -> [MFExepnse] {
        var expensesDOM: Results<Expense>
        if searchText.isEmpty {
            expensesDOM = Expense.fetchRequest(.all)
        } else if searchText.starts(with: "c:") {
            let text = searchText.dropFirst(2)
            expensesDOM = Expense.fetchRequest(.contains(field: "category", String(text)))
        } else {
            expensesDOM = Expense.fetchRequest(.contains(field: "name", searchText))
        }

        var newExpenses = [MFExepnse]()
        var latestIncome: Int = 0
        for index in stride(from: expensesDOM.count-1, through: 0, by: -1) {
            if expensesDOM[index].income > 0 {
                latestIncome = expensesDOM[index].income
            }
            let newerExpense = MFExepnse(expense: expensesDOM.element(at: index-1), unit: unit, income: latestIncome)
            let olderExpense = newExpenses.last
            
            if let newExpense = MFExepnse(expense: expensesDOM[index],
                                          olderExpense: olderExpense,
                                          newerExpense: newerExpense,
                                          isYearlyTotalOn: showYearlyTotal,
                                          isMonthlyTotalOn: showMonthlyTotal,
                                          isWeeklyTotalOn: showWeeklyTotal,
                                          isDailyTotalOn: showDailyTotal,
                                          isExpenseOn: showExpenses,
                                          unit: unit,
                                          income: latestIncome) {
                newExpenses.append(newExpense)
            }
        }
        self.expenses = newExpenses.reversed()
        return expenses
    }
    
    func getPrevExpense(with currentItem: MFExepnse) -> MFExepnse? {
        let items = Expense.fetchRequest(.findObjects(withName: currentItem.name))
        var currentItemFound: Bool = false
        
        for element in items {
            if currentItemFound {
                return MFExepnse(expense: element, unit: .som, income: 0)
            }
            if element.id == currentItem.id {
                currentItemFound = true
            }
        }
        
        return nil
    }
}
