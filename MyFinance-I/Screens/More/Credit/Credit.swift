import Foundation
import RealmSwift

class Credit: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var borrower = ""
    @Persisted var amount = 0
    @Persisted var purpose = ""
    @Persisted var isPaid = false
    @Persisted var date = Date()
}

extension Credit {
    func update(_ credit: Credit, borrower: String, amount: Int, purpose: String, date: Date) {
        self.writeToDB { thawedObj, thawedRealm in
            if let credit = thawedObj as? Credit {
                credit.borrower = borrower
                credit.amount = amount
                credit.purpose = purpose
                credit.date = date
            }
        }
    }
    
    static func fetchRequest(_ predicate: NSPredicate) -> Results<Credit> {
        return Realm.shared().objects(Credit.self).filter(predicate).sorted(byKeyPath: "date", ascending: false)
    }
    
    func paid() {
        self.writeToDB { thawedObj, thawedRealm in
            if let credit = thawedObj as? Credit {
                credit.isPaid = true
            }
        }
    }
}
