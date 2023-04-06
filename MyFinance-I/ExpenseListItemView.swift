//
//  ExpenseListItemView.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 05/04/23.
//

import SwiftUI

struct ExpenseListItemView: View {
    let expense: Expense
    
    var body: some View {
        VStack {
            HStack {
                Text("5/4/2023")
            }
            HStack {
                Text("M1")
                Spacer()
                Text("200,000")
            }.padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
            HStack {
                Text("W3")
                Spacer()
                Text("150,000")
            }.padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
            HStack {
                Text("\(expense.name)")
                Spacer()
                Text("\(expense.price)")
            }
            .padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
        }
    }
}

struct ExpenseListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseListItemView(expense: Expense())
    }
}
