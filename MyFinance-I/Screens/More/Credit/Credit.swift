import Foundation
import RealmSwift

class Credit: Object, ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var borrower = ""
    @Persisted var amount = 0
    @Persisted var purpose = ""
    @Persisted var isPaid = false
    @Persisted var date = Date()
    
    enum CodingKeys: String, CodingKey {
        case id
        case borrower
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
        borrower = try values.decode(String.self, forKey: .borrower)
        amount = try values.decode(Int.self, forKey: .amount)
        purpose = try values.decode(String.self, forKey: .purpose)
        isPaid = try values.decode(Bool.self, forKey: .isPaid)
        date = try values.decode(Date.self, forKey: .date)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(borrower, forKey: .borrower)
        try container.encode(amount, forKey: .amount)
        try container.encode(purpose, forKey: .purpose)
        try container.encode(isPaid, forKey: .isPaid)
        try container.encode(date, forKey: .date)
    }
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
