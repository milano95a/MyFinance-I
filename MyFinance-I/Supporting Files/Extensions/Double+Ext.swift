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
    
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16 //maximum digits in Double after dot (maximum precision)
        return String(formatter.string(from: number) ?? "")
    }
}
