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
    let shouldShowDailyTotal: Bool
    let shouldShowWeeklyTotal: Bool
    let shouldShowMonthlyTotal: Bool
    let shouldShowYearlyTotal: Bool
    let dailyTotal: Int
    let weeklyTotal: Int
    let monthlyTotal: Int
    let yearlyTotal: Int
    let showExpense: Bool
    
    var body: some View {
        VStack {
                if displayDate {
                    if showExpense {
                        HStack {
                            Text("\(expense.date.friendlyDate)")
                        }
                    }
                    if shouldShowYearlyTotal {
                        HStack {
                            Text("Y\(String(expense.date.year))")
                            Spacer()
                            Text("\(yearlyTotal)").fontWeight(.bold)
                        }
                        .padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
                        .foregroundColor(.yearlyTotalColor)
                    }
                    if shouldShowMonthlyTotal {
                        HStack {
                            Text("M\(expense.date.monthOfTheYear)")
                            Spacer()
                            Text("\(monthlyTotal)").fontWeight(.bold)
                        }
                        .padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
                        .foregroundColor(.monthlyTotalColor)
                    }
                    if shouldShowWeeklyTotal {
                        HStack {
                            Text("W\(expense.date.weekOfTheYear)")
                            Spacer()
                            Text("\(weeklyTotal)").fontWeight(.bold)
                        }
                        .padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
                        .foregroundColor(.weeklyTotalColor)
                    }
                    if shouldShowDailyTotal {
                        HStack {
                            Text("D\(expense.date.dayOfTheYear)")
                            Spacer()
                            Text("\(dailyTotal)").fontWeight(.bold)
                        }
                        .padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
                        .foregroundColor(.dailyTotalColor)
                    }
                }
                if showExpense {
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
        .foregroundColor(.defaultTextColor)
        .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
    }
}

//struct ExpenseListItemView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        ExpenseListItemView(
//            expense: createExpense(),
//            displayDate: true,
//            displayWeek: true,
//            displayMonth: true,
//            displayYear: true,
//            dailyTotal: 100_000,
//            weeklyTotal: 200_000,
//            monthlyTotal: 300_000,
//            yearlyTotal: 1_000_000,
//            showYearlyTotal: true,
//            showMonthlyTotal: true,
//            showWeeklyTotal: true,
//            showDailyTotal: true,
//            showExpense: true
//        )
//    }
//    
//    static func createExpense() -> Expense {
//        let expense = Expense()
//        expense.name = "Snickers"
//        expense.price = 8000
//        expense.quantity = 2
//        expense.category = "food"
//        return expense
//    }
//}
