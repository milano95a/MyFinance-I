import Foundation
import RealmSwift

class Debt: Object, ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var creditor = ""
    @Persisted var amount = 0
    @Persisted var purpose = ""
    @Persisted var isPaid = false
    @Persisted var date = Date()
    
    enum CodingKeys: String, CodingKey {
        case id
        case creditor
        case amount
        case purpose
        case isPaid
        case date
    }
    
    required override init() {}
    
    required init(from decoder: Decoder) throws {
        super.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(ObjectId.self, forKey: .id)
        creditor = try values.decode(String.self, forKey: .creditor)
        amount = try values.decode(Int.self, forKey: .amount)
        purpose = try values.decode(String.self, forKey: .purpose)
        isPaid = try values.decode(Bool.self, forKey: .isPaid)
        date = try values.decode(Date.self, forKey: .date)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(creditor, forKey: .creditor)
        try container.encode(amount, forKey: .amount)
        try container.encode(purpose, forKey: .purpose)
        try container.encode(isPaid, forKey: .isPaid)
        try container.encode(date, forKey: .date)
    }
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
        return Realm.shared().objects(Debt.self).filter(predicate).sorted(byKeyPath: "date", ascending: false)
    }
    
    func paid() {
        self.writeToDB { thawedObj, thawedRealm in
            if let debt = thawedObj as? Debt {
                debt.isPaid = true
            }
        }
    }
}
