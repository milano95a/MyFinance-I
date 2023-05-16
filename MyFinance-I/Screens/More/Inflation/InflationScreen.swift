//
//  InflationScreen.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 03/05/23.
//

import SwiftUI

struct InflationScreen: View {
    var items: [Expense]
    
    var body: some View {
        List(items.indices, id: \.self) { index in
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Spacer()
                    Text("\(String(items[index].date.year))")
                    Spacer()
                }
                Text("\(items[index].name)")
                HStack {
                    Text(priceChangeForItemAt(index))
                    Spacer()
                    if let change = priceChangePercentForItemAt(index) {
                        if change > 0 {
                            Text("+\(change.removeZerosFromEnd())%").foregroundColor(.red)
                        } else {
                            Text("\(change.removeZerosFromEnd())%").foregroundColor(.green)
                        }
                    }
                }
            }
        }
    }
    
    func priceChangeForItemAt(_ index: Int) -> String {
        let price2 = "\(items[index].price)"
        var price1 = "na"
        if items.indices.contains(index-1) {
            price1 = "\(items[index-1].price)"
        }
        return "\(price1)  >  \(price2)"
    }
    
    func priceChangePercentForItemAt(_ index: Int) -> Double? {
        let newPrice = items[index].price
        var oldPrice = 0
        var result: Double? = nil
        if items.indices.contains(index-1) {
            oldPrice = items[index-1].price
        } else {
            return result
        }
        
        let change = Double(newPrice) / Double(oldPrice)
        if change > 1 {
            result = (change - 1) * 100
        } else {
            result = -(1-change) * 100
        }
        
        return result?.rounded(toPlaces: 2)
    }
}
