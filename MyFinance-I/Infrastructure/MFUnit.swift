//
//  MFUnit.swift
//  MyFinance-I
//
//  Created by Jamoliddinov Abduraxmon on 19/07/24.
//

import Foundation

enum MFUnit: String, CaseIterable, Identifiable {
    case som = "so'm"
    case uf = "uf"
    case usd = "usd"
    case income = "income"
    
    var id: Self { self }
}
