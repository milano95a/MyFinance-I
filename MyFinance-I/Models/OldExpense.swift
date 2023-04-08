//
//  OldExpense.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 07/04/23.
//

import Foundation

struct OldExpense: Codable {
    var quantity: Double
    var price: Int
    var productName: String
    var date: Int64
    var isExpense: Bool
    
    var _date: Date {
        Date(timeIntervalSince1970: Double(date/1000))
    }
}
