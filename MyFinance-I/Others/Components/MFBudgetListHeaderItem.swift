//
//  MFBudgetListHeaderItem.swift
//  MyFinance-I
//
//  Created by Jamoliddinov Abduraxmon on 05/06/24.
//

import SwiftUI

struct MFBudgetListHeaderItem: View {
    var title: String
    var value: Int
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text("\(value)")
                .fontWeight(.bold)
        }        
    }
}
#Preview {
    MFBudgetListHeaderItem(title: "title", value: 10000000)
}
