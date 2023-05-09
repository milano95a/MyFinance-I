//
//  InflationScreen.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 03/05/23.
//

import SwiftUI

struct InflationScreen: View {
    var items: [ProductInflation]
    
    var body: some View {
        List(items) { item in
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Spacer()
                    Text("\(String(item.year))")
                    Spacer()
                }
                Text("\(item.productName)")
                HStack {
                    Text("\(item.firstMonthMeanPrice)  >  \(item.lastMonthMeanPrice)")
                    Spacer()
                    if item.change > 0 {
                        Text("+\(item.change.rounded(toPlaces: 2).removeZerosFromEnd())%")
                            .foregroundColor(.red)
                    } else {
                        Text("\(item.change.rounded(toPlaces: 2).removeZerosFromEnd()) %")
                            .foregroundColor(.green)
                    }
                }
            }
        }
    }
}

struct ProductInflation: Identifiable {
    var id: Int { year }
    var year: Int
    var productName: String
    var firstMonthMeanPrice: Int
    var lastMonthMeanPrice: Int
    var change: Double {
        let change = Double(lastMonthMeanPrice) / Double(firstMonthMeanPrice)
        if change > 1 {
            return (change - 1) * 100
        } else {
            return -(1 - change) * 100
        }
    }
}

struct InflationScreen_Previews: PreviewProvider {
    static var previews: some View {
        InflationScreen(items: [
            ProductInflation(year: 2022,
                             productName: "Super Twist",
                             firstMonthMeanPrice: 4300,
                             lastMonthMeanPrice: 5000),
            ProductInflation(year: 2021,
                             productName: "Super Twist",
                             firstMonthMeanPrice: 5300,
                             lastMonthMeanPrice: 4300)

        ])
    }
}
