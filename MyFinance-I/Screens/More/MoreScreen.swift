import SwiftUI

struct MoreScreen: View {
    
    @State private var showSettingsPopup = false
    
    var body: some View {
        NavigationStack {
            listOfLinks
            .navigationTitle("More")
            .toolbar {
                toolbar
            }
            .popover(isPresented: $showSettingsPopup) {
                MoreSettingsScreen()
            }
        }
    }
    
    var listOfLinks: some View {
        Form {
            CustomNavigationLink("Debts", destination: ListDebtScreen())
            CustomNavigationLink("Credits", destination: ListCreditScreen())
            CustomNavigationLink("Expenses by cateogry", destination: ExpensesByCategoryScreen())
            CustomNavigationLink("Expenses chart", destination: ExpensesChartScreen())
            CustomNavigationLink("Inflation", destination: ProductsListScreen())
            CustomNavigationLink("Savings", destination: SavingsScreen())
            CustomNavigationLink("Cost of things in 30 years", destination: ScreenCostOfThingsIn30Years())
            CustomNavigationLink("Assets", destination: AssetsScreen())
            CustomNavigationLink("Budget", destination: MFBudgetScreen())
        }
        .foregroundColor(.defaultTextColor)
    }
    
    @ToolbarContentBuilder
    var toolbar: some ToolbarContent {
        ToolbarItem {
            Button(action: {
                showSettingsPopup = true
            }, label: {
                Image(systemName: "gear")
            })
        }
    }
}
















































struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        MoreScreen()
    }
}
