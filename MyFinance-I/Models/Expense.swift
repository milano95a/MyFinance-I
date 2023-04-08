
import Foundation
import RealmSwift

class Expense: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String = ""
    @Persisted var quantity: Double = 0.0
    @Persisted var price: Int = 0
    @Persisted var date: Date = Date()
    @Persisted var category: String = ""
}

extension Expense {
    
    static func add(expenses: [Expense]) {
        Realm.writeWithTry { realm in
            realm.add(expenses)
        }
    }
    
    static func add(name: String, quantity: Double, price: Int, date: Date) {
        let expense = Expense()
        expense.name = name
        expense.quantity = quantity
        expense.price = price
        expense.date = date

        Realm.writeWithTry { realm in
            realm.add(expense)
        }
    }
    
    static func delete(_ expense: Expense) {
        expense.write { thawedObj, thawedRealm in
            thawedRealm.delete(thawedObj)
        }
    }
    
    static func deleteAll() {
        Realm.writeWithTry { realm in
            realm.deleteAll()
        }
    }
    
    static func update(_ expense: Expense, name: String?, quantity: Double?, price: Int?, date: Date?) {
        expense.write { thawedObj, thawedRealm in
            if let name = name { thawedObj.name = name }
            if let quantity = quantity { thawedObj.quantity = quantity }
            if let price = price { thawedObj.price = price }
            if let date = date { thawedObj.date = date }
        }
    }
    
    private func write(_ callback: (Expense, Realm) -> Void) {
        guard let thawedObj = self.thaw() else { return }
        assert(thawedObj.isFrozen == false)
        guard let thawedRealm = thawedObj.realm else { return }
        do {
            try thawedRealm.write {
                callback(thawedObj, thawedRealm)
            }
        } catch let error {
            print(error)
        }
    }
}

extension Expense {
    var cost: Int {
        Int(quantity * Double(price))
    }
}
