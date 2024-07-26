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
    
    @Published var selectedPreferenceShowYearlyTotal: Bool
    @Published var selectedPreferenceShowMonthlyTotal: Bool
    @Published var selectedPreferenceShowWeeklyTotal: Bool
    @Published var selectedPreferenceShowDailyTotal: Bool
    @Published var selectedPreferenceShowExpenses: Bool
//    var showMonthlyTotal: Bool
//    var showWeeklyTotal: Bool
//    var showDailyTotal: Bool
//    var showExpense: Bool
    @Published var selectedUnitOfCounting: MFUnit 
//    {
//        didSet {
//            UserDefaults.selectedUnitOfCounting = selectedUnitOfCounting
//            expensesDOM = Expense.fetchRequest(.all)
//        }
//    }
    
    init() {
        expensesDOM = Expense.fetchRequest(.all)
        selectedPreferenceShowYearlyTotal = UserDefaults.selectedPreferenceShowYearlyTotal
//        UserDefaults.standard.bool(forKey: "showYearlyTotal")
        selectedPreferenceShowMonthlyTotal = UserDefaults.selectedPreferenceShowMonthlyTotal
//        UserDefaults.standard.bool(forKey: "showMonthlyTotal")
        selectedPreferenceShowWeeklyTotal = UserDefaults.selectedPreferenceShowWeeklyTotal
//        UserDefaults.standard.bool(forKey: "showWeeklyTotal")
        selectedPreferenceShowDailyTotal = UserDefaults.selectedPreferenceShowDailyTotal
//        UserDefaults.standard.bool(forKey: "showDailyTotal")
        selectedPreferenceShowExpenses = UserDefaults.selectedPreferenceShowExpenses
//        UserDefaults.standard.bool(forKey: "showExpense")
        
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
        
        $selectedPreferenceShowYearlyTotal.sink { [weak self] value in
            UserDefaults.selectedPreferenceShowYearlyTotal = value
//            self?.expensesDOM = Expense.fetchRequest(.all)
        }.store(in: &subscriptions)
        
        $selectedPreferenceShowMonthlyTotal.sink { [weak self] value in
            UserDefaults.selectedPreferenceShowMonthlyTotal = value
//            self?.expensesDOM = Expense.fetchRequest(.all)
        }.store(in: &subscriptions)
        
        $selectedPreferenceShowWeeklyTotal.sink { [weak self] value in
            UserDefaults.selectedPreferenceShowWeeklyTotal = value
//            self?.expensesDOM = Expense.fetchRequest(.all)
        }.store(in: &subscriptions)
        
        $selectedPreferenceShowDailyTotal.sink { [weak self] value in
            UserDefaults.selectedPreferenceShowDailyTotal = value
//            self?.expensesDOM = Expense.fetchRequest(.all)
        }.store(in: &subscriptions)
        
        $selectedPreferenceShowExpenses.sink { [weak self] value in
            UserDefaults.selectedPreferenceShowExpenses = value
//            self?.expensesDOM = Expense.fetchRequest(.all)
        }.store(in: &subscriptions)
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
//        UserDefaults.selectedPreferenceShowYearlyTotal = showYearlyTotal
//        UserDefaults.standard.set(showYearlyTotal, forKey: "showYearlyTotal")
//        self.showYearlyTotal = UserDefaults.standard.bool(forKey: "showYearlyTotal")
//        expensesDOM = Expense.fetchRequest(.all)
    }

    func setPreferenceMonthlyTotal(_ value: Bool) {
        selectedPreferenceShowMonthlyTotal = value
//        UserDefaults.selectedPreferenceShowMonthlyTotal = showMonthlyTotal
//        UserDefaults.standard.set(showMonthlyTotal, forKey: "showMonthlyTotal")
//        self.showMonthlyTotal = UserDefaults.standard.bool(forKey: "showMonthlyTotal")
//        expensesDOM = Expense.fetchRequest(.all)
    }

    func setPreferenceWeeklyTotal(_ value: Bool) {
        selectedPreferenceShowWeeklyTotal = value
//        UserDefaults.selectedPreferenceShowWeeklyTotal = showWeeklyTotal
//        UserDefaults.standard.set(showWeeklyTotal, forKey: "showWeeklyTotal")
//        self.showWeeklyTotal = UserDefaults.standard.bool(forKey: "showWeeklyTotal")
//        expensesDOM = Expense.fetchRequest(.all)
    }

    func setPreferenceDailyTotal(_ value: Bool) {
        selectedPreferenceShowDailyTotal = value
//        UserDefaults.selectedPreferenceShowDailyTotal = showDailyTotal
//        UserDefaults.standard.set(showDailyTotal, forKey: "showDailyTotal")
//        self.showDailyTotal = UserDefaults.standard.bool(forKey: "showDailyTotal")
//        expensesDOM = Expense.fetchRequest(.all)
    }
    
    func setPreferenceExpense(_ value: Bool) {
        selectedPreferenceShowExpenses = value
//        UserDefaults.selectedPreferenceShowExpenses = showExpense
//        UserDefaults.standard.set(showExpense, forKey: "showExpense")
//        self.showExpense = UserDefaults.standard.bool(forKey: "showExpense")
//        expensesDOM = Expense.fetchRequest(.all)
    }
    
    func setPreferencUnit(_ unit: MFUnit) {
        selectedUnitOfCounting = unit
    }
}
