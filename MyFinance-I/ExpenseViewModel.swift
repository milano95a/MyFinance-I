//
//  ExpenseViewModel.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 05/04/23.
//

import Foundation
import RealmSwift

class ExpenseViewModel: ObservableObject {
    @Published var expenses = try! Realm().objects(Expense.self)
    
    // MARK: Intents
    
    func importDataFromJson() {
        
    }
    
    func delete(_ expense: Expense) {
        self.objectWillChange.send()
        Expense.delete(expense)
    }
    
    func update(_ expense: Expense, name: String?, price: Int?, quantity: Double?, date: Date?) {
        self.objectWillChange.send()
        Expense.update(expense, name: name, quantity: quantity, price: price, date: date)
    }
    
    func add(name: String, price: Int, quantity: Double, date: Date) {
        self.objectWillChange.send()
        Expense.add(name: name, quantity: quantity, price: price, date: date)
    }
    
    func deleteAll() {
        self.objectWillChange.send()
        Expense.deleteAll()
    }
    
    // MARK: Helper functions
}
