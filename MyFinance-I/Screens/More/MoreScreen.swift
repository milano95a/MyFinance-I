import SwiftUI

struct MoreScreen: View {
    
    var body: some View {
        NavigationStack {
            Form {
                NavigationLink("Debts", destination: ListDebtScreen(debtManager: ViewModelDebt()))
                    .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                NavigationLink("Credits", destination: ListCreditScreen(creditManager: ViewModelCredit()))
                    .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                NavigationLink("Expenses by cateogry", destination: ExpensesByCategoryScreen())
                    .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                NavigationLink("Expenses chart", destination: ExpensesChartScreen(vm: ExpenseChartViewModel()))
                    .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                NavigationLink("Inflation", destination: ProductsListScreen())
                    .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))

            }
            .foregroundColor(.defaultTextColor)
            .navigationTitle("More")
        }
    }
}














































struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        MoreScreen()
    }
}
