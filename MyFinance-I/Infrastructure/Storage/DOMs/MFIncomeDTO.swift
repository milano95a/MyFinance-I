//
//  MFIncomeDTO.swift
//  MyFinance-I
//
//  Created by Jamoliddinov Abduraxmon on 19/07/24.
//

import Foundation
import RealmSwift

class MFIncomeDTO: Object, ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var date: Date = Date()
    @Persisted var amount: Int = 0
}
