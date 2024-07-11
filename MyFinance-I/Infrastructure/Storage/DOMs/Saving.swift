//
//  Saving.swift
//  MyFinance-I
//
//  Created by Jamoliddinov Abduraxmon on 11/07/24.
//

import Foundation
import RealmSwift

class Saving: Object, ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var date: Date = Date()
    @Persisted private var amount: Int = 0
    
    var amountWithFraction: Double {
        get {
            return Double(amount)/100.0
        }
        set {
            amount = Int(newValue * 100.0)
        }
    }
    
    init(date: Date, amount: Int, change: Double) {
        self.date = date
        self.amount = amount
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case amount
        case date
    }
    
    required override init() {}
    
    required init(from decoder: Decoder) throws {
        super.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(ObjectId.self, forKey: .id)
        amount = try values.decode(Int.self, forKey: .amount)
        date = try values.decode(Date.self, forKey: .date)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(amount, forKey: .amount)
        try container.encode(date, forKey: .date)
    }
}
