//
//  MonthlyExpensesScreen.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 13/04/23.
//

import SwiftUI

struct ExpensesChartScreen: View {
    @EnvironmentObject var manager: ExpenseChartManager
    
    @State private var selectedYear = 2023
    @State private var years = [Int]()
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Select a year", selection: $selectedYear) {
                    ForEach(years, id: \.self) {
                        Text("Monthly expenses in \(String($0)) in mlns")
                    }
                }.pickerStyle(.automatic)
                BarChart(data: manager.getMonthlyExpensesFor(selectedYear))
            }
            .navigationBarTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                years = manager.getYears()
            }
        }
    }
}




































struct MonthlyExpensesScreen_Previews: PreviewProvider {
    static var previews: some View {
        ExpensesChartScreen()
    }
}
