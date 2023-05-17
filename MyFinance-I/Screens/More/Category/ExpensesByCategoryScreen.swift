//
//  ExpensesByCategoryView.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 12/04/23.
//

import SwiftUI

struct ExpensesByCategoryScreen: View {
    
    var body: some View {
        List(ExpenseByCategoryManager.shared.categories()) { monthlyExpensesByCategory in
            VStack {
                Text("\(monthlyExpensesByCategory.month)/\(String(monthlyExpensesByCategory.year))")
                ForEach(monthlyExpensesByCategory.categories) { category in
                    HStack {
                        Text("\(category.name)")
                        Spacer()
                        Text("\(category.total)")
                    }
                }
            }
        }
        .foregroundColor(.defaultTextColor)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}








































struct ExpensesByCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        ExpensesByCategoryScreen()
    }
}
