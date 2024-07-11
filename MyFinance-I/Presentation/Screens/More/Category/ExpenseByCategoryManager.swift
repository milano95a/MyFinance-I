//
//  ExpenseByCategoryViewModel.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 12/04/23.
//

import Foundation
import RealmSwift

class ExpenseByCategoryManager: ObservableObject {
    
    static var shared = ExpenseByCategoryManager()
    
    private init() {}
    
    // MARK: API
    
    func categories() -> [MonthlyExpensesByCategory] {
        var categoriesByMonth = [String: MonthlyExpensesByCategory]()
        
        let expenses = Realm.shared().objects(Expense.self).sorted(byKeyPath: "date", ascending: false)
        
        for expense in expenses {
            let key = "\(expense.date.monthOfTheYear)/\(expense.date.year)"
            if let _ = categoriesByMonth[key] {
                if let _ = categoriesByMonth[key]!.categoriesByName[expense.category] {
                    categoriesByMonth[key]!.categoriesByName[expense.category]!.total += expense.cost
                } else {
                    categoriesByMonth[key]!.categoriesByName[expense.category] = CategoryTotalExpenses(name: expense.category, total: expense.cost)
                }
            } else {
                categoriesByMonth[key] = MonthlyExpensesByCategory(month: expense.date.monthOfTheYear, year: expense.date.year, categoriesByName: [:])
            }
        }
        
        return Array(categoriesByMonth.values).sorted {
            $0.year * 100 + $0.month > $1.year * 100 + $1.month
        }
    }
    
    struct MonthlyExpensesByCategory: Identifiable {
        var id: String = UUID().uuidString
        var month: Int
        var year: Int
        var categoriesByName: [String: CategoryTotalExpenses]
        var categories: [CategoryTotalExpenses] {
            Array(categoriesByName.values).sorted { $0.total > $1.total }
        }
    }
    
    struct CategoryTotalExpenses: Identifiable {
        var id: String = UUID().uuidString
        var name: String
        var total: Int
    }
}
