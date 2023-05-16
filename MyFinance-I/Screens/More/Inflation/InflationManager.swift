//
//  InflationManager.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 10/05/23.
//

import Foundation

class InflationManager: ObservableObject {
    
    // MARK: API(s)
    func giveMeInflationFor(product: String) -> [Expense] {
        let expenses = Expense.fetchRequest(.all).filter("name = %@", product).sorted { $0.date > $1.date }
        var result = [Expense]()
        
        for year in 2020...Date().year {
            for expense in expenses {
                if expense.date.year == year {
                    result.append(expense)
                    break
                }
            }
        }
        return result
    }
        
    func getUniqueProducts() -> [Expense] {
        let result = Expense.fetchRequest(.all)
        var uniqueExpenseNames = Set<String>()
        var uniqueExpenses = [Expense]()
        for expense in result {
            let count = uniqueExpenseNames.count
            uniqueExpenseNames.insert(expense.name)
            let newCount = uniqueExpenseNames.count
            if newCount > count {
                uniqueExpenses.append(expense)
            }
        }

        return uniqueExpenses
    }
}
