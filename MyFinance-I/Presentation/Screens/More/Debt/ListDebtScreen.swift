import SwiftUI

struct ListDebtScreen: View {
    @EnvironmentObject var manager: DebtManager
    @State private var showDebtEditorPopup = false
    @State private var selectedDebt: Debt?
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                listOfDebts
                addButton
            }
        }
    }
}

extension ListDebtScreen {
    @ViewBuilder
    var listOfDebts: some View {
        List(manager.debts.freeze()) { debt in
            DebtListItemView(debt: debt)
                .swipeActions {
                    Button("Paid") {
                        manager.paid(debt)
                    }.tint(.green)
                    Button("Delete") {
                        manager.delete(debt)
                    }.tint(.red)
                    Button("Edit") {
                        selectedDebt = debt
                        showDebtEditorPopup = true
                    }.tint(.blue)
                }
        }
        .popover(isPresented: $showDebtEditorPopup) { [selectedDebt] in
            EditorDebtScreen(debtManager: manager, debt: selectedDebt)
        }
    }
    
    var addButton: some View {
        ZStack {
            Circle()
                .frame(width: 48)
                .foregroundColor(.addButtonColor)
                .padding()
                .onTapGesture {
                    showDebtEditorPopup = true
                }
            Image(systemName: "plus")
                .foregroundColor(.white)
        }
    }
}





















































struct DebtScreen_Previews: PreviewProvider {
    static var previews: some View {
        ListDebtScreen()
    }
}
