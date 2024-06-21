//
//  SavingItemView.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 16/05/23.
//

import SwiftUI

struct SavingItemView: View {
    let item: Saving
    let change: Double
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("\(item.date.friendlyDate)")
                Spacer()
            }
            HStack {
                Text("\(item.amountWithFraction.removeZerosFromEnd())")
                Spacer()
                if change > 0 {
                    Text("+\(change.removeZerosFromEnd())%")
                        .foregroundColor(.green)
                } else if change < 0 {
                    Text("\(change.removeZerosFromEnd())%")
                        .foregroundColor(.red)
                }
            }
        }
    }
}

struct SavingItemView_Previews: PreviewProvider {
    static var previews: some View {
        SavingItemView(item: Saving(), change: 0)
    }
}
