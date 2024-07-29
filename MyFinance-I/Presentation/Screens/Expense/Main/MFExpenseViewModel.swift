//
//  MFExpenseViewModel.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 05/04/23.
//

import Foundation
import RealmSwift
import Combine

class MFExpenseViewModel: ObservableObject {
    
    @Published var expensesDOM: Results<Expense>
    @Published var expenses: [MFExepnse] = []
    var subscriptions = Set<AnyCancellable>()
    
    var selectedPreferenceShowYearlyTotal: Bool {
        didSet {
            UserDefaults.selectedPreferenceShowYearlyTotal = selectedPreferenceShowYearlyTotal
            expensesDOM = Expense.fetchRequest(.all)
        }
    }
    var selectedPreferenceShowMonthlyTotal: Bool {
        didSet {
            UserDefaults.selectedPreferenceShowMonthlyTotal = selectedPreferenceShowMonthlyTotal
            expensesDOM = Expense.fetchRequest(.all)
        }
    }
    var selectedPreferenceShowWeeklyTotal: Bool {
        didSet {
            UserDefaults.selectedPreferenceShowWeeklyTotal = selectedPreferenceShowWeeklyTotal
            expensesDOM = Expense.fetchRequest(.all)
        }
    }
    var selectedPreferenceShowDailyTotal: Bool {
        didSet {
            UserDefaults.selectedPreferenceShowDailyTotal = selectedPreferenceShowDailyTotal
            expensesDOM = Expense.fetchRequest(.all)
        }
    }
    var selectedPreferenceShowExpenses: Bool {
        didSet {
            UserDefaults.selectedPreferenceShowExpenses = selectedPreferenceShowExpenses
            expensesDOM = Expense.fetchRequest(.all)
        }
    }
    var selectedUnitOfCounting: MFUnit {
        didSet {
            UserDefaults.selectedUnitOfCounting = selectedUnitOfCounting
            expensesDOM = Expense.fetchRequest(.all)
        }
    }
    
    init() {
        expensesDOM = Expense.fetchRequest(.all)
        selectedPreferenceShowYearlyTotal = UserDefaults.selectedPreferenceShowYearlyTotal
        selectedPreferenceShowMonthlyTotal = UserDefaults.selectedPreferenceShowMonthlyTotal
        selectedPreferenceShowWeeklyTotal = UserDefaults.selectedPreferenceShowWeeklyTotal
        selectedPreferenceShowDailyTotal = UserDefaults.selectedPreferenceShowDailyTotal
        selectedPreferenceShowExpenses = UserDefaults.selectedPreferenceShowExpenses
        
        self.selectedUnitOfCounting = UserDefaults.selectedUnitOfCounting
        
        $expensesDOM
            .dropFirst()
            .sink { [weak self] value in
                guard let self else { return }
                var newExpenses = [MFExepnse]()
                var latestIncome: Int = 0
                for index in stride(from: value.count-1, through: 0, by: -1) {
                    if value[index].income > 0 {
                        latestIncome = value[index].income
                    }                    
                    let newerExpense = MFExepnse(expense: value.element(at: index-1), unit: self.selectedUnitOfCounting, income: latestIncome)
                    let olderExpense = newExpenses.last
                    
                    if let newExpense = MFExepnse(expense: value[index],
                                                  olderExpense: olderExpense,
                                                  newerExpense: newerExpense,
                                                  isYearlyTotalOn: selectedPreferenceShowYearlyTotal,
                                                  isMonthlyTotalOn: selectedPreferenceShowMonthlyTotal,
                                                  isWeeklyTotalOn: selectedPreferenceShowWeeklyTotal,
                                                  isDailyTotalOn: selectedPreferenceShowDailyTotal,
                                                  isExpenseOn: selectedPreferenceShowExpenses,
                                                  unit: selectedUnitOfCounting,
                                                  income: latestIncome) {
                        newExpenses.append(newExpense)
                    }
                }
                            
                expenses = newExpenses.reversed()
        }
        .store(in: &subscriptions)
        
        valuePublisher(expensesDOM)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                guard let self else { return }
                var newExpenses = [MFExepnse]()
                var latestIncome: Int = 0
                for index in stride(from: value.count-1, through: 0, by: -1) {
                    if value[index].income > 0 {
                        latestIncome = value[index].income
                    }
                    let newerExpense = MFExepnse(expense: value.element(at: index-1), unit: self.selectedUnitOfCounting, income: latestIncome)
                    let olderExpense = newExpenses.last
                    
                    if let newExpense = MFExepnse(expense: value[index],
                                                  olderExpense: olderExpense,
                                                  newerExpense: newerExpense,
                                                  isYearlyTotalOn: selectedPreferenceShowYearlyTotal,
                                                  isMonthlyTotalOn: selectedPreferenceShowMonthlyTotal,
                                                  isWeeklyTotalOn: selectedPreferenceShowWeeklyTotal,
                                                  isDailyTotalOn: selectedPreferenceShowDailyTotal,
                                                  isExpenseOn: selectedPreferenceShowExpenses,
                                                  unit: selectedUnitOfCounting,
                                                  income: latestIncome) {
                        newExpenses.append(newExpense)
                    }
                }
                            
                expenses = newExpenses.reversed()
            }).store(in: &subscriptions)
    }
    
    // MARK: Intents
    
    func findById(_ id: ObjectId) -> Expense? {
        Expense.findById(id)
    }
    
    func delete(_ id: ObjectId?) {
        if let id {
            if let expense = Realm.shared().object(ofType: Expense.self, forPrimaryKey: id) {
                self.objectWillChange.send()
                Expense.delete(expense)
            }
        }
    }
    
    func update(_ expense: Expense, name: String, category: String, price: Int, quantity: Double, date: Date, income: Int, ufRate: Int, usdRate: Int) {
        self.objectWillChange.send()
        Expense.update(expense, name: name, category: category, quantity: quantity, price: price, date: date, income: income, ufRate: ufRate, usdRate: usdRate)
    }
    
    func add(name: String, category: String, price: Int, quantity: Double, date: Date, income: Int, ufRate: Int, usdRate: Int) {
        self.objectWillChange.send()
        Expense.add(name: name, category: category, quantity: quantity, price: price, date: date, income: income, ufRate: ufRate, usdRate: usdRate)
    }

    func searchExpenses(with searchText: String) {
        if searchText.starts(with: "c:") {
            let text = searchText.dropFirst(2)
            if text.isEmpty {
                expensesDOM = Expense.fetchRequest(.all)
            } else {
                expensesDOM = Expense.fetchRequest(.contains(field: "category", String(text)))
            }
        } else if searchText.isEmpty || searchText.count < 3 {
            expensesDOM = Expense.fetchRequest(.all)
        } else {
            expensesDOM = Expense.fetchRequest(.contains(field: "name", searchText))
        }
    }
    
    // MARK: Helper(s)
}

// MARK: Suggestions APIs
extension MFExpenseViewModel {
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

// MARK: Preferenes APIs
extension MFExpenseViewModel {
    func setPreferenceYearlyTotal(_ value: Bool) {
        selectedPreferenceShowYearlyTotal = value
    }

    func setPreferenceMonthlyTotal(_ value: Bool) {
        selectedPreferenceShowMonthlyTotal = value
    }

    func setPreferenceWeeklyTotal(_ value: Bool) {
        selectedPreferenceShowWeeklyTotal = value
    }

    func setPreferenceDailyTotal(_ value: Bool) {
        selectedPreferenceShowDailyTotal = value
    }
    
    func setPreferenceExpense(_ value: Bool) {
        selectedPreferenceShowExpenses = value
    }
    
    func setPreferencUnit(_ unit: MFUnit) {
        selectedUnitOfCounting = unit
    }
}
