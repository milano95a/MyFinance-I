import Foundation
import RealmSwift

class Debt: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var creditor = ""
    @Persisted var amount = 0
    @Persisted var purpose = ""
    @Persisted var isPaid = false
    @Persisted var date = Date()
}

extension Debt {
    func update(_ debt: Debt, creditor: String, amount: Int, purpose: String, date: Date) {
        self.writeToDB { thawedObj, thawedRealm in
            if let debt = thawedObj as? Debt {
                debt.creditor = creditor
                debt.amount = amount
                debt.purpose = purpose
                debt.date = date
            }
        }
    }
    
    static func fetchRequest(_ predicate: NSPredicate) -> Results<Debt> {
        return Realm.shared.objects(Debt.self).filter(predicate).sorted(byKeyPath: "date", ascending: false)
    }
    
    func paid() {
        self.writeToDB { thawedObj, thawedRealm in
            if let debt = thawedObj as? Debt {
                debt.isPaid = true
            }
        }
    }
}
