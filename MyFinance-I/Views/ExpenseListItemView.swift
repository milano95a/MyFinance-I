//
//  ExpenseListItemView.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 05/04/23.
//

import SwiftUI

struct ExpenseListItemView: View {
    let expense: Expense
    let displayDate: Bool
    let displayWeek: Bool
    let displayMonth: Bool
    let displayYear: Bool
    let dailyTotal: Int
    let weeklyTotal: Int
    let monthlyTotal: Int
    let yearlyTotal: Int
    
    var body: some View {
        VStack {
            if displayDate {
                HStack {
                    Text("\(expense.date.friendlyDate)")
                }
                if displayYear {
                    HStack {
                        Text("Y\(String(expense.date.year))")
                        Spacer()
                        Text("\(yearlyTotal)")
                    }.padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
                }
                if displayMonth {
                    HStack {
                        Text("M\(expense.date.monthOfTheYear)")
                        Spacer()
                        Text("\(monthlyTotal)")
                    }.padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
                }
                if displayWeek {
                    HStack {
                        Text("W\(expense.date.weekOfTheYear)")
                        Spacer()
                        Text("\(weeklyTotal)")
                    }.padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
                }
                HStack {
                    Text("D\(expense.date.dayOfTheYear)")
                    Spacer()
                    Text("\(dailyTotal)")
                }.padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
            }
            HStack {
                Text("\(expense.name)")
                Spacer()
                Text("\(expense.cost)")
            }
            .padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
            HStack {
                Text("\(expense.category)")
                Spacer()
            }
            .padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))

        }
    }
}

struct ExpenseListItemView_Previews: PreviewProvider {
    
    static var previews: some View {
        ExpenseListItemView(
            expense: createExpense(),
            displayDate: true,
            displayWeek: true,
            displayMonth: true,
            displayYear: true,
            dailyTotal: 100_000,
            weeklyTotal: 200_000,
            monthlyTotal: 300_000,
            yearlyTotal: 1_000_000)
    }
    
    static func createExpense() -> Expense {
        let expense = Expense()
        expense.name = "Snickers"
        expense.price = 8000
        expense.quantity = 2
        expense.category = "food"
        return expense
    }
}
