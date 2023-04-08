//
//  ExpenseViewModel.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 05/04/23.
//

import Foundation
import RealmSwift

class ExpenseViewModel: ObservableObject {
    
    static let shared = ExpenseViewModel()
    
    @Published var expenses: Results<Expense>
    
    
    private init() {
        expenses = Realm.shared.objects(Expense.self).sorted(byKeyPath: "date", ascending: false)
        
        total = Total()
        categories = []
        sync()
    }
    
    // MARK: APIs
    
    func isSamedWeek(_ index1: Int, _ index2: Int) ->  Bool {
        let week1 = expenses[index1].date.weekOfTheYear
        let week2 = expenses[index2].date.weekOfTheYear
        
        return isSameYear(index1, index2) && week1 == week2
    }

    func isSameMonth(_ index1: Int, _ index2: Int) ->  Bool {
        let month1 = expenses[index1].date.monthOfTheYear
        let month2 = expenses[index2].date.monthOfTheYear
        
        return isSameYear(index1, index2) && month1 == month2
    }

    func isSameYear(_ index1: Int, _ index2: Int) ->  Bool {
        let year1 = expenses[index1].date.year
        let year2 = expenses[index2].date.year
        return year1 == year2
    }

    func isSameDay(_ index1: Int, _ index2: Int) -> Bool {
        let day1 = expenses[index1].date.dayOfTheYear
        let day2 = expenses[index2].date.dayOfTheYear
        
        return isSameYear(index1, index2) && day1 == day2
    }
    
    func dailyTotalFor(_ expense: Expense) -> Int {
        let key = "\(expense.date.year)\(expense.date.dayOfTheYear)"
        return total.dailyTotals[key] ?? 0
    }
    
    func weeklyTotalFor(_ expense: Expense) -> Int {
        let key = "\(expense.date.year)\(expense.date.weekOfTheYear)"
        return total.weeklyTotals[key] ?? 0
    }
    
    func monthlyTotalFor(_ expense: Expense) -> Int {
        let key = "\(expense.date.year)\(expense.date.monthOfTheYear)"
        return total.monthlyTotals[key] ?? 0
    }
    
    func yearlyTotalFor(_ expense: Expense) -> Int {
        let key = "\(expense.date.year)"
        return total.yearlyTotals[key] ?? 0
    }
    
    func getSuggestions(with text: String) -> Results<Expense> {
        let suggestions = Realm.shared.objects(Expense.self).filter(NSPredicate(format: "name CONTAINS[c] '\(text)'"))
        return suggestions
    }
    
    static func emptySuggestions() -> Results<Expense> {
        let suggestions = Realm.shared.objects(Expense.self).filter(NSPredicate(value: false))
        return suggestions
    }
    
    func searchExpenses(with searchText: String) {
        if searchText.isEmpty {
            expenses = Realm.shared.objects(Expense.self)
                .sorted(byKeyPath: "date", ascending: false)
        } else {
            expenses = Realm.shared.objects(Expense.self)
                .filter(NSPredicate(format: "name CONTAINS[c] '\(searchText)'"))
                .sorted(byKeyPath: "date", ascending: false)
        }
    }
    
    // MARK: Intents
    func delete(_ expense: Expense) {
        self.objectWillChange.send()
        Expense.delete(expense)
        sync()
    }
    
    func update(_ expense: Expense, name: String?, price: Int?, quantity: Double?, date: Date?) {
        self.objectWillChange.send()
        Expense.update(expense, name: name, quantity: quantity, price: price, date: date)
        sync()
    }
    
    func add(name: String, price: Int, quantity: Double, date: Date) {
        self.objectWillChange.send()
        Expense.add(name: name, quantity: quantity, price: price, date: date)
        sync()
    }
    
    func add(oldExpenenses: [OldExpense]) {
        var expenses = [Expense]()
        
        for oldExpenense in oldExpenenses {
            if oldExpenense.isExpense {
                let category = oldExpenense.productName.firstWord()
                var name = oldExpenense.productName.dropFirstWord()
                if name.starts(with: " ") {
                    name = String(name.dropFirst())
                }
                
                let expense = Expense()
                expense.name = name
                expense.quantity = oldExpenense.quantity
                expense.price = oldExpenense.price
                expense.date = oldExpenense._date
                expense.category = category
                expenses.append(expense)
            }
        }
        
        Expense.add(expenses: expenses)
    }
    
    func deleteAll() {
        self.objectWillChange.send()
        Expense.deleteAll()
    }
    
    // MARK: Totals
    @Published var total: Total
    
    func calculateTotals() {
        var dailyTotals = [String: Int]()
        var weeklyTotals = [String: Int]()
        var monthlyTotals = [String: Int]()
        var yearlyTotals = [String: Int]()

        for expense in expenses {
            let dailyTotalKey = "\(expense.date.year)\(expense.date.dayOfTheYear)"
            if let _ = dailyTotals[dailyTotalKey] {
                dailyTotals[dailyTotalKey]! += expense.cost
            } else {
                dailyTotals[dailyTotalKey] = expense.cost
            }
            
            let weeklyTotalKey = "\(expense.date.year)\(expense.date.weekOfTheYear)"
            if let _ = weeklyTotals[weeklyTotalKey] {
                weeklyTotals[weeklyTotalKey]! += expense.cost
            } else {
                weeklyTotals[weeklyTotalKey] = expense.cost
            }

            let monthlyTotalKey = "\(expense.date.year)\(expense.date.monthOfTheYear)"
            if let _ = monthlyTotals[monthlyTotalKey] {
                monthlyTotals[monthlyTotalKey]! += expense.cost
            } else {
                monthlyTotals[monthlyTotalKey] = expense.cost
            }

            let yearlyTotalKey = "\(expense.date.year)"
            if let _ = yearlyTotals[yearlyTotalKey] {
                yearlyTotals[yearlyTotalKey]! += expense.cost
            } else {
                yearlyTotals[yearlyTotalKey] = expense.cost
            }
        }
        
        total = Total(dailyTotals: dailyTotals, weeklyTotals: weeklyTotals, monthlyTotals: monthlyTotals, yearlyTotals: yearlyTotals)
    }
    
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

    // MARK: Categories
    
    var categories: Set<String>
    
    func getCategorySuggestions(with text: String) -> [String] {
        return Array(categories)
    }
    
    func loadCategories() {
        expenses = Realm.shared.objects(Expense.self)
        
        for expense in expenses {
            categories.insert(expense.category)
        }
    }
    
    // MARK: Utilities
    
    private func sync() {
        calculateTotals()
        loadCategories()
    }
}
