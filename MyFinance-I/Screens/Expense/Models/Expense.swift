
import Foundation
import RealmSwift

class Expense: Object, ObjectKeyIdentifiable, Decodable, Encodable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String = ""
    @Persisted var quantity: Double = 0.0
    @Persisted var price: Int = 0
    @Persisted var date: Date = Date()
    @Persisted var category: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case quantity
        case price
        case date
        case category
    }
    
    required override init() {}
    
    required init(from decoder: Decoder) throws {
        super.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(ObjectId.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        quantity = try values.decode(Double.self, forKey: .quantity)
        price = try values.decode(Int.self, forKey: .price)
        date = try values.decode(Date.self, forKey: .date)
        category = try values.decode(String.self, forKey: .category)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(price, forKey: .price)
        try container.encode(date, forKey: .date)
        try container.encode(category, forKey: .category)
    }
}

// MARK: Database stuff
extension Expense {
    
    static func findById(_ id: ObjectId) -> Expense? {
        Realm.shared().object(ofType: Expense.self, forPrimaryKey: id)
    }
    
    static func add(expenses: [Expense]) {
        Realm.writeWithTry { realm in
            realm.add(expenses)
        }
    }
    
    static func add(name: String, category: String, quantity: Double, price: Int, date: Date) {
        let expense = Expense()
        expense.name = name
        expense.category = category
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
    
    static func update(_ expense: Expense, name: String?, category: String?, quantity: Double?, price: Int?, date: Date?) {
        expense.write { thawedObj, thawedRealm in
            if let name = name { thawedObj.name = name }
            if let category = category { thawedObj.category = category }
            if let quantity = quantity { thawedObj.quantity = quantity }
            if let price = price { thawedObj.price = price }
            if let date = date { thawedObj.date = date }
        }
    }
    
    static func fetchRequest(_ predicate: NSPredicate) -> Results<Expense> {
        return Realm.shared().objects(Expense.self).filter(predicate).sorted(byKeyPath: "date", ascending: false)
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

// MARK: Utitlies
extension Expense {
    var cost: Int {
        Int(quantity * Double(price))
    }
}

extension NSPredicate {
    static var all = NSPredicate(format: "TRUEPREDICATE")
    static var none = NSPredicate(format: "FALSEPREDICATE")
    static func contains(field: String, _ string: String) -> NSPredicate {
        NSPredicate(format: "\(field) CONTAINS[c] '\(string)'")
    }
    static func equals(field: String, equalsTo string: ObjectId) -> NSPredicate {
        NSPredicate(format: "\(field) == \(string)")
    }

}

