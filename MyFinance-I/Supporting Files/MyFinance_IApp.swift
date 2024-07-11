
import SwiftUI
import RealmSwift

@main
struct MyFinance_IApp: SwiftUI.App {
    @StateObject var expenseViewModel = MFExpenseViewModel()
    
    var body: some Scene {
        WindowGroup {
            InitialTabScreen()                
                .environmentObject(expenseViewModel)
                .environmentObject(CreditManager())
                .environmentObject(DebtManager())
                .environmentObject(InflationManager())
                .environmentObject(ExpenseChartManager())
                .environmentObject(SavingsManager())
                .environmentObject(ExportManager())
                .environmentObject(ImportManager())
                .environmentObject(ManagerCostOfThingsIn30Years(expenseViewModel))
                .environmentObject(MFBudgetsListViewModel())      
        }
    }
}
