//
//  ExpenseListItemView.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 05/04/23.
//

import SwiftUI

struct ExpenseListItemView: View {
    let expense: MFExepnse
    let showDate: Bool
    let showDailyTotal: Bool
    let showWeeklyTotal: Bool
    let showMonthlyTotal: Bool
    let showYearlyTotal: Bool
    let dailyTotal: String
    let weeklyTotal: String
    let monthlyTotal: String
    let yearlyTotal: String
    let showExpense: Bool
    
    var body: some View {
        if showYearlyTotal || showMonthlyTotal || showWeeklyTotal || showDailyTotal || showExpense {
            VStack(spacing: 0) {
                if showDate {
                    dateView
                    
                    if showYearlyTotal {
                        yearlyTotalView
                    }
                    
                    if showMonthlyTotal {
                        monthlyTotalView
                    }
                    
                    if showWeeklyTotal {
                        weeklyTotalView
                    }
                    
                    if showDailyTotal {
                        dailyTotalView
                    }
                }
                if showExpense {
                    expenseView
                }
            }
            .foregroundColor(.defaultTextColor)
            .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder
    var expenseView: some View {
        HStack {
            Text("\(expense.name)")
            Spacer()
            Text(expense.cost)
        }
        .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
        HStack {
            Text("\(expense.category)").font(.caption)
            Spacer()
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 4, trailing: 0))

    }
    
    var dateView: some View {
        HStack {
            Text("\(expense.date.friendlyDate)")
        }
    }
    
    var yearlyTotalView: some View {
        HStack {
            Text("Y\(String(expense.date.year))")
            Spacer()
            Text(expense.yearlyTotal).fontWeight(.bold)
        }
        .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
        .foregroundColor(.yearlyTotalColor)
    }
    
    var monthlyTotalView: some View {
        HStack {
            Text("M\(expense.date.monthOfTheYear)")
            Spacer()
            Text(expense.monthlyTotal).fontWeight(.bold)
        }
        .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
        .foregroundColor(.monthlyTotalColor)
    }
    
    var weeklyTotalView: some View {
        HStack {
            Text("W\(expense.date.weekOfTheYear)")
            Spacer()
            Text(expense.weeklyTotal).fontWeight(.bold)
        }
        .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
        .foregroundColor(.weeklyTotalColor)
    }
    
    var dailyTotalView: some View {
        HStack {
            Text("D\(expense.date.dayOfTheYear)")
            Spacer()
            Text(expense.dailyTotal).fontWeight(.bold)
        }
        .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
        .foregroundColor(.dailyTotalColor)
    }
}




#Preview {
    ExpenseListItemView(expense: MFExepnse.mockData,
                        showDate: true,
                        showDailyTotal: true,
                        showWeeklyTotal: true,
                        showMonthlyTotal: true,
                        showYearlyTotal: true,
                        dailyTotal: MFExepnse.mockData.cost,
                        weeklyTotal: MFExepnse.mockData.cost,
                        monthlyTotal: MFExepnse.mockData.cost,
                        yearlyTotal: MFExepnse.mockData.cost,
                        showExpense: true)
}
