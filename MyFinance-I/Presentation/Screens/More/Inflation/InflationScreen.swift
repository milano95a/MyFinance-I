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
                    Text("\(items[index].price)")
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
    
//    func priceChangeForItemAt(_ index: Int) -> String {
//        let currentPrice = "\(items[index].price)"
//        var previousPrice = "na"
//        if items.indices.contains(index-1) {
//            price1 = "\(items[index-1].price)"
//        }
//        return "\(price1)  >  \(price2)"
//    }
    
    func priceChangePercentForItemAt(_ index: Int) -> Double? {
        let currentPrice = items[index].price
        var previousPrice: Int!
        var result: Double?
        
        if items.indices.contains(index+1) {
            previousPrice = items[index+1].price
        } else {
            return nil
        }
        
        let change = Double(currentPrice) / Double(previousPrice)
        if change > 1 {
            result = (change - 1) * 100
        } else {
            result = -(1-change) * 100
        }
        
        if result == 0 {
            return nil
        }
        
        return result?.rounded(toPlaces: 2)
    }
}
