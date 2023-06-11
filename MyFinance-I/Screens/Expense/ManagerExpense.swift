//
//  ExpenseViewModel.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 05/04/23.
//

import Foundation
import RealmSwift

class ManagerExpense: ObservableObject {
    
    @Published var expenses: Results<Expense>
    @Published var total: Total
    @Published var showYearlyTotal: Bool
    @Published var showMonthlyTotal: Bool
    @Published var showWeeklyTotal: Bool
    @Published var showDailyTotal: Bool
    @Published var showExpense: Bool
    
    init() {
        expenses            = Expense.fetchRequest(.all)
        total               = Total()
        showYearlyTotal     = UserDefaults.standard.bool(forKey: "showYearlyTotal")
        showMonthlyTotal    = UserDefaults.standard.bool(forKey: "showMonthlyTotal")
        showWeeklyTotal     = UserDefaults.standard.bool(forKey: "showWeeklyTotal")
        showDailyTotal      = UserDefaults.standard.bool(forKey: "showDailyTotal")
        showExpense         = UserDefaults.standard.bool(forKey: "showExpense")
    }
    
    func getExpenses() -> [UIExpense] {
        var uiExpenses = [UIExpense]()
        
        for (index, expense) in expenses.enumerated() {
            if index == 0 {
                let uiExpense = UIExpense(
                    id: expense.id,
                    name: expense.name,
                    quantity: expense.quantity,
                    price: expense.price,
                    date: expense.date,
                    category: expense.category,
                    isSameDayAsPrevious: false,
                    dailyTotal: 0,
                    weeklyTotal: 0,
                    monthlyTotal: 0,
                    yearlyTotal: 0,
                    showDailyTotal: showDailyTotal,
                    showWeeklyTotal: showWeeklyTotal,
                    showMonthlyTotal: showMonthlyTotal,
                    showYearlyTotal: showYearlyTotal,
                    showExpense: showExpense)
                
                uiExpenses.append(uiExpense)
            } else {
                let isSameYearAsPrevious = expense.date.year == expenses[index-1].date.year
                let isSameDayAsPrevious = expense.date.dayOfTheYear == expenses[index-1].date.dayOfTheYear && isSameYearAsPrevious
                let isSameWeekAsPrevious = expense.date.weekOfTheYear == expenses[index-1].date.weekOfTheYear && isSameYearAsPrevious
                let isSameMonthAsPrevious = expense.date.monthOfTheYear == expenses[index-1].date.monthOfTheYear && isSameYearAsPrevious
                
                let uiExpense = UIExpense(
                    id: expense.id,
                    name: expense.name,
                    quantity: expense.quantity,
                    price: expense.price,
                    date: expense.date,
                    category: expense.category,
                    isSameDayAsPrevious: isSameDayAsPrevious,
                    dailyTotal: 0,
                    weeklyTotal: 0,
                    monthlyTotal: 0,
                    yearlyTotal: 0,
                    showDailyTotal: showDailyTotal,
                    showWeeklyTotal: showWeeklyTotal && !isSameWeekAsPrevious,
                    showMonthlyTotal: showMonthlyTotal && !isSameMonthAsPrevious,
                    showYearlyTotal: showYearlyTotal && !isSameYearAsPrevious,
                    showExpense: showExpense)
                
                uiExpenses.append(uiExpense)
            }
        }
        
        for index in stride(from: uiExpenses.lastIndex, through: 0, by: -1) {
            if index == uiExpenses.lastIndex {
                uiExpenses[index].dailyTotal = uiExpenses[index].cost
                uiExpenses[index].weeklyTotal = uiExpenses[index].cost
                uiExpenses[index].monthlyTotal = uiExpenses[index].cost
                uiExpenses[index].yearlyTotal = uiExpenses[index].cost
            } else {
                if uiExpenses[index].date.isSameDay(uiExpenses[index+1].date) {
                    uiExpenses[index].dailyTotal = uiExpenses[index].cost + uiExpenses[index+1].dailyTotal
                } else {
                    uiExpenses[index].dailyTotal = uiExpenses[index].cost
                }
                if uiExpenses[index].date.isSameWeek(uiExpenses[index+1].date) {
                    uiExpenses[index].weeklyTotal = uiExpenses[index].cost + uiExpenses[index+1].weeklyTotal
                } else {
                    uiExpenses[index].weeklyTotal = uiExpenses[index].cost
                }
                if uiExpenses[index].date.isSameMonth(uiExpenses[index+1].date) {
                    uiExpenses[index].monthlyTotal = uiExpenses[index].cost + uiExpenses[index+1].monthlyTotal
                } else {
                    uiExpenses[index].monthlyTotal = uiExpenses[index].cost
                }
                
                if uiExpenses[index].date.year == uiExpenses[index+1].date.year {
                    uiExpenses[index].yearlyTotal = uiExpenses[index].cost + uiExpenses[index+1].yearlyTotal
                } else {
                    uiExpenses[index].yearlyTotal = uiExpenses[index].cost
                }
            }
        }
        return uiExpenses
    }
    
    // MARK: Intents
    
    func findById(_ id: ObjectId) -> Expense? {
        Expense.findById(id)
    }
    
    func delete(_ uiExpense: UIExpense) {
        if let expense = Realm.shared().object(ofType: Expense.self, forPrimaryKey: uiExpense.id) {
            self.objectWillChange.send()
            Expense.delete(expense)
        }
    }
    
    func update(_ expense: Expense, name: String, category: String, price: Int, quantity: Double, date: Date) {
        self.objectWillChange.send()
        Expense.update(expense, name: name, category: category, quantity: quantity, price: price, date: date)
    }
    
    func add(name: String, category: String, price: Int, quantity: Double, date: Date) {
        self.objectWillChange.send()
        Expense.add(name: name, category: category, quantity: quantity, price: price, date: date)
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
    
    func setPreferenceYearlyTotal(_ showYearlyTotal: Bool) {
        UserDefaults.standard.set(showYearlyTotal, forKey: "showYearlyTotal")
        self.showYearlyTotal = UserDefaults.standard.bool(forKey: "showYearlyTotal")
    }

    func setPreferenceMonthlyTotal(_ showMonthlyTotal: Bool) {
        UserDefaults.standard.set(showMonthlyTotal, forKey: "showMonthlyTotal")
        self.showMonthlyTotal = UserDefaults.standard.bool(forKey: "showMonthlyTotal")
    }

    func setPreferenceWeeklyTotal(_ showWeeklyTotal: Bool) {
        UserDefaults.standard.set(showWeeklyTotal, forKey: "showWeeklyTotal")
        self.showWeeklyTotal = UserDefaults.standard.bool(forKey: "showWeeklyTotal")
    }

    func setPreferenceDailyTotal(_ showDailyTotal: Bool) {
        UserDefaults.standard.set(showDailyTotal, forKey: "showDailyTotal")
        self.showDailyTotal = UserDefaults.standard.bool(forKey: "showDailyTotal")
    }
    
    func setPreferenceExpense(_ showExpense: Bool) {
        UserDefaults.standard.set(showExpense, forKey: "showExpense")
        self.showExpense = UserDefaults.standard.bool(forKey: "showExpense")
    }
    
    func searchExpenses(with searchText: String) {
        if searchText.starts(with: "c:") {
            let text = searchText.dropFirst(2)
            if text.isEmpty {
                expenses = Expense.fetchRequest(.all)
            } else {
                expenses = Expense.fetchRequest(.contains(field: "category", String(text)))
            }
        } else if searchText.isEmpty || searchText.count < 3 {
            expenses = Expense.fetchRequest(.all)
        } else {
            expenses = Expense.fetchRequest(.contains(field: "name", searchText))
        }
    }
}

// MARK: Totals APIs
extension ManagerExpense {
    
    func calculateTotals() {
        let creationDate = Date()
        
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
        let interval = Date().timeIntervalSince(creationDate)
        print("ExpenseManager \(interval)")

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
}

// MARK: Charts APIs
extension ManagerExpense {
    func monthlyExpenses(_ year: String) -> [BarChartData] {
        var data = [BarChartData]()
        let keysForGivenYear = total.monthlyTotals.keys.filter { $0.hasPrefix(year) }
        let keysSorted = keysForGivenYear.sorted { Int($0)! < Int($1)! }
        
        for key in keysSorted {
            let monthOfYear = String(key.dropFirst(4))
            let monthlyTotalExpense = total.monthlyTotals[key]!
            let monthlyExpenseInDouble = Double(monthlyTotalExpense) / 1_000_000
            
            let barchartItem = BarChartData(value: monthlyExpenseInDouble.rounded(toPlaces: 1), text: monthOfYear)
            data.append(barchartItem)
        }
        return data
    }
}

// MARK: Suggestions APIs
extension ManagerExpense {
    func getSuggestions(with string: String) -> [Expense] {
        let result = Expense.fetchRequest(.contains(field: "name", string))
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
    
    func getCategorySuggestions(with string: String) -> [String] {
        let result = Expense.fetchRequest(.contains(field: "category", string))
        var set = Set<String>()
        for item in result {
            set.insert(item.category)
        }
        return Array(set)
    }
}
