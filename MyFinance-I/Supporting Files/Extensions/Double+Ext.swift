//
//  Double+Ext.swift
//  MyFinance-I
//
//  Created by Jamoliddinov Abduraxmon on 26/07/24.
//

import Foundation

extension Double {
    func toSpaceSeparated() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.groupingSize = 3
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}
